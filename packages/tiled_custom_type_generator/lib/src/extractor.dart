import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:expressions/expressions.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart'
    hide GeneratorForAnnotation, Generator;
import 'package:logging/logging.dart';
import 'package:generic_reader/generic_reader.dart';

import 'package:tiled/tiled.dart';
import 'package:tiled_project/tiled_project.dart';
import 'package:tiled_custom_type_annotation/tiled_custom_type_annotation.dart';
import 'field_helpers.dart';

final logger = Logger('TiledCustomTypeAggregator');
final cachedTypeNameToId = <String, int>{};
final cachedTypeNameToColor = <String, String?>{};
int nextId = 1;

const defaultValues = {
  PropertyType.bool: false,
  PropertyType.color: '',
  PropertyType.float: 0,
  PropertyType.file: '',
  PropertyType.int: 0,
  PropertyType.object: 0,
  PropertyType.string: '',
  PropertyType.class_: {}
};

JsonEncoder encoder = new JsonEncoder.withIndent('    ');

TypeChecker get typeChecker => TypeChecker.fromRuntime(TiledCustomType);
TypeChecker get enumChecker => TypeChecker.fromRuntime(TiledCustomEnum);

TiledCustomTypeMember decodeMemberAnnotation(ConstantReader cr) {
  final typeReader = cr.read('type');
  final type = typeReader.isNull ? null : typeReader.get<PropertyType>();
  return TiledCustomTypeMember(
    type: type,
  );
}

/// Reads all dart files and outputs json definitions of their custom types to
/// a single file
class TiledCustomTypeAggregator implements Builder {
  final String _outFile;
  final Set<String> includeList;
  TiledCustomTypeAggregator(this._outFile, this.includeList);

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': [_outFile, 'custom_type_parser.g.dart'],
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    GenericReader.addDecoder<TiledCustomTypeMember>(decodeMemberAnnotation);

    log.info('Processing with $includeList to $_outFile');

    await for (final projectAsset in buildStep.findAssets(
      Glob('**.tiled-project'),
    )) {
      final projectJson =
          jsonDecode(await buildStep.readAsString(projectAsset));
      final tiledProject = TiledProject.fromJson(projectJson);
      for (final propertyType in tiledProject.propertyTypes) {
        final typeName = propertyType.name;
        cachedTypeNameToColor[typeName] = propertyType.color;
        int cachedId = cachedTypeNameToId[typeName] ?? propertyType.id;
        if (nextId <= cachedId) nextId = cachedId + 1;
        if (cachedId != propertyType.id) {
          logger.warning(
            'Custom types with the same name have different ids! Using the lower id.',
          );
          cachedId = cachedId < propertyType.id ? cachedId : propertyType.id;
        }
        cachedTypeNameToId[typeName] = cachedId;
      }
    }

    List<CustomPropertyType> properties = [];

    for (final included in includeList) {
      final uri = Uri.parse(included);
      final packageUri = await Isolate.resolvePackageUri(uri);
      log.fine('Parsing file at $packageUri for external custom types');
      if (packageUri == null) {
        log.warning('Included type file not found: $included');
        return;
      }
      final content = File.fromUri(packageUri).readAsStringSync();
      final json = jsonDecode(content);
      if (json is! List<dynamic>) {
        log.warning('Included file $included is not a list of types');
      }
      for (final item in json) {
        if (item is Map<String, dynamic>) {
          final includedType = CustomPropertyType.fromJson(item);
          includedType.id =
              (cachedTypeNameToId[includedType.name] ??= nextId++);
          includedType.color =
              (cachedTypeNameToColor[includedType.name] ??= includedType.color);

          properties.add(includedType);
        }
      }
    }

    final generator = CustomTypeGenerator();

    final codeBuffer = StringBuffer();
    codeBuffer.writeln('// GENERATED CODE, DO NOT MANUALLY EDIT.');
    codeBuffer.writeln();
    codeBuffer.writeln("import 'package:tiled/tiled.dart';");
    codeBuffer.writeln('\n');

    final customTypeGuts = StringBuffer();
    final customEnumGuts = StringBuffer();
    final objectRefGuts = StringBuffer();

    await for (final asset in buildStep.findAssets(
      Glob("**.dart", recursive: true),
    )) {
      final resolver = buildStep.resolver;
      if (!await resolver.isLibrary(asset)) continue;
      final library = LibraryReader(
        await resolver.libraryFor(asset, allowSyntaxErrors: true),
      );

      final props = generator.generate(library, buildStep);
      final propsByName = Map.fromEntries(
        props.map((prop) => MapEntry(prop.name, prop)),
      );
      if (props.isNotEmpty) {
        codeBuffer.writeln("import '${asset.pathSegments.skip(1).join('/')}';");
        for (final prop in props) {
          final typeName = prop.name;
          if (prop.type == 'class') {
            customTypeGuts.writeln(
              "  if (property.propertyType == '$typeName') return $typeName.fromJson(property.value);",
            );
          }
          if (prop.type == 'enum') {
            customEnumGuts.writeln(
              "  if (property.propertyType == '$typeName') return $typeName.values.asNameMap()[property.value];",
            );
          }
          objectRefGuts.writeln("      case '$typeName':");
          for (final path in objectRefPaths('', prop, propsByName)) {
            objectRefGuts.writeln('        parents.add(prop.value$path!);');
          }
          objectRefGuts.writeln('        break;');
        }
      }
      properties.addAll(props);
    }

    codeBuffer.writeln();

    // Write custom type inflation block
    codeBuffer.writeln(
      'Object? \$getCustomTypeInstance(CustomTypeProperty property) {',
    );
    codeBuffer.write(customTypeGuts.toString());
    codeBuffer.writeln('  return null;');
    codeBuffer.writeln('}');
    codeBuffer.writeln();

    // Write custom enum mapping
    codeBuffer.writeln(
      "Object? \$getCustomTypeEnum(StringProperty property) {",
    );
    codeBuffer.write(customEnumGuts.toString());
    codeBuffer.writeln('  return null;');
    codeBuffer.writeln('}');
    codeBuffer.writeln();

    // Write custom types that could point to other objects
    codeBuffer.writeln('Set<int> \$getParents(Property<Object> prop) {');
    codeBuffer.writeln('  final parents = <int>{};');
    codeBuffer.writeln('  if (prop is CustomTypeProperty) {');
    codeBuffer.writeln('    switch (prop.propertyType) {');
    codeBuffer.write(objectRefGuts.toString());
    codeBuffer.writeln('    }');
    codeBuffer.writeln('  }');
    codeBuffer.writeln('  return parents;');
    codeBuffer.writeln('}');
    codeBuffer.writeln();

    buildStep.writeAsString(
      buildStep.allowedOutputs.first,
      encoder.convert(properties),
    );

    buildStep.writeAsString(
      buildStep.allowedOutputs.skip(1).first,
      codeBuffer.toString(),
    );
  }
}

Iterable<String> objectRefPaths(
  String prefix,
  CustomPropertyType prop,
  Map<String, CustomPropertyType> propsByName,
) sync* {
  for (final member in prop.members ?? <Member>[]) {
    final path = prefix + "['${member.name}']";
    if (member.type == 'object') {
      yield path;
    } else if (member.type == 'class') {
      final subType = propsByName[member.propertyType];
      if (subType != null) {
        yield* objectRefPaths(path, subType, propsByName);
      }
    }
  }
}

class CustomTypeGenerator {
  Iterable<CustomPropertyType> generate(
      LibraryReader library, BuildStep buildStep) {
    final values = <CustomPropertyType>{};

    for (final annotatedElement in library.annotatedWith(enumChecker)) {
      final generatedValue = generateForAnnotatedElement(
        annotatedElement.element,
        annotatedElement.annotation,
        buildStep,
      );
      if (generatedValue != null) {
        values.add(generatedValue);
      }
    }

    for (final annotatedElement in library.annotatedWith(typeChecker)) {
      final generatedValue = generateForAnnotatedElement(
        annotatedElement.element,
        annotatedElement.annotation,
        buildStep,
      );
      if (generatedValue != null) {
        values.add(generatedValue);
      }
    }

    return values;
  }

  CustomPropertyType? generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement && element is! EnumElement) {
      throw InvalidGenerationSourceError(
        'ya put the annotation in the wrong spot, dummy',
      );
    }

    cachedTypeNameToId[element.name!] ??= nextId++;

    if (element is ClassElement) {
      final helper = ClassGeneratorHelper(element);
      return helper.generate(buildStep);
    } else {
      final helper = EnumGeneratorHelper(element as EnumElement);
      return helper.generate();
    }
  }
}

class ClassGeneratorHelper {
  final ClassElement element;

  ClassGeneratorHelper(
    this.element,
  );

  CustomPropertyType? generate(BuildStep buildStep) {
    final sortedFields = createSortedFieldSet(element);

    // Used to keep track of why a field is ignored. Useful for providing
    // helpful errors when generating constructor calls that try to use one of
    // these fields.
    final unavailableReasons = <String, String>{};

    final accessibleFields = sortedFields.fold<Map<String, FieldElement>>(
      <String, FieldElement>{},
      (map, field) {
        if (!field.isPublic) {
          unavailableReasons[field.name] = 'It is assigned to a private field.';
        } else if (field.getter == null) {
          assert(field.setter != null);
          unavailableReasons[field.name] =
              'Setter-only properties are not supported.';
          log.warning('Setters are ignored: ${element.name}.${field.name}');
        } else {
          assert(!map.containsKey(field.name));
          map[field.name] = field;
        }

        return map;
      },
    );

    final evaluator = const ExpressionEvaluator();
    final defaultParameters = {
      for (final parameter in element.unnamedConstructor!.parameters
          .where((parameter) => parameter.isInitializingFormal)
          .where((element) => element.hasDefaultValue))
        parameter.name:
            evaluator.eval(Expression.parse(parameter.defaultValueCode!), {})
    };

    var accessibleFieldSet = accessibleFields.values.toSet();
    final memberChecker = TypeChecker.fromRuntime(TiledCustomTypeMember);
    return CustomPropertyType()
      ..type = 'class'
      ..name = element.name
      ..id = cachedTypeNameToId[element.name]!
      ..color = cachedTypeNameToColor[element.name]
      ..useAs = [
        'property',
        'map',
        'layer',
        'object',
        'tile',
      ]
      ..members = accessibleFieldSet.map((field) {
        final memberReader = ConstantReader(
          memberChecker.firstAnnotationOf(field),
        );

        TiledCustomTypeMember memberAnnotation = TiledCustomTypeMember();
        if (!memberReader.isNull) {
          memberAnnotation = memberReader.get<TiledCustomTypeMember>();
        }

        var typeString = field.type.getDisplayString(withNullability: false);
        if (typeString == 'String') typeString = 'string';
        if (typeString == 'double') typeString = 'float';
        var memberType = memberAnnotation.type ??
            PropertyType.values.asNameMap()[typeString] ??
            PropertyType.class_;

        String? propertyType;
        if (memberType == PropertyType.class_) {
          propertyType = typeString;
        }
        if (field.type.isDartCoreEnum) {
          propertyType = typeString;
          memberType = PropertyType.string;
        }

        return Member(
          name: field.name,
          type: memberType.name,
          propertyType: propertyType,
          value: defaultParameters[field.name] ?? defaultValues[memberType]!,
        );
      }).toList();
  }
}

class EnumGeneratorHelper {
  final EnumElement element;
  EnumGeneratorHelper(this.element);
  CustomPropertyType? generate() {
    return CustomPropertyType()
      ..id = cachedTypeNameToId[element.name]!
      ..name = element.name
      ..storageType = 'string'
      ..type = 'enum'
      ..values = element.fields
          .map((field) => field.name)
          .where((e) => e != 'values')
          .toList()
      ..valuesAsFlags = false;
  }
}
