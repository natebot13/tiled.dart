import 'dart:async';

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'tiled_custom_type.dart';

class TiledCustomTypeGenerator extends GeneratorForAnnotation<TiledCustomType> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return "// Generated some code!!!";
  }
}
