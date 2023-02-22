import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:tiled/tiled.dart';

import 'src/tiled_custom_type.dart';
export 'src/tiled_custom_type.dart';

class TiledCustomTypeLocator implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.tiled-custom-type'],
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final resolver = buildStep.resolver;
    if (!await resolver.isLibrary(buildStep.inputId)) return;
    final lib = LibraryReader(await buildStep.inputLibrary);
    final tiledCustomTypeAnnotation = TypeChecker.fromRuntime(TiledCustomType);
    final annotated = lib.annotatedWith(tiledCustomTypeAnnotation);

    if (annotated.isNotEmpty) {
      int i = 1;
      StringBuffer buffer = StringBuffer();
      for (final element in annotated) {
        final visitor = TiledCustomTypeVisitor(i);
        element.element.visitChildren(visitor);
        i += 1;

        buffer.writeln(jsonEncode(visitor.propertyType.toJson()));
        buildStep.writeAsString(
          buildStep.inputId.changeExtension('.tiled-custom-type'),
          buffer.toString(),
        );
      }
    }
  }
}

class TiledCustomTypeVisitor extends SimpleElementVisitor {
  CustomPropertyType propertyType;
  TiledCustomTypeVisitor(int id)
      : propertyType = CustomPropertyType(id: id, type: 'class');

  @override
  visitConstructorElement(ConstructorElement element) {
    propertyType.name = element.type.returnType.toString();
  }

  @override
  visitFieldElement(FieldElement element) {}
}

class TiledCustomTypeExporter implements Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) {}

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': ['project.tiled-project'],
      };
}

Builder tiledCustomTypeLocator(BuilderOptions options) =>
    TiledCustomTypeLocator();

Builder tiledCustomTypeExporter(BuilderOptions options) =>
    TiledCustomTypeExporter();
