import 'dart:convert';
import 'dart:io';

import 'package:tiled_project/tiled_project.dart';
import 'package:test/test.dart';

void main() {
  group('Read a tiled-project', () {
    final content = File('test/test.tiled-project').readAsStringSync();
    final jsonMap = jsonDecode(content);
    final project = TiledProject.fromJson(jsonMap);

    test('same input/output', () {
      expect(jsonMap, project.toJson());
    });
  });
}
