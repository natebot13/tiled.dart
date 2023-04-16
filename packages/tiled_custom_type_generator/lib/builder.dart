import 'package:build/build.dart';

import 'src/extractor.dart';

Builder extractTypes([BuilderOptions options = BuilderOptions.empty]) {
  final config = Map.of(options.config);
  final customTypesConfig = config.remove('custom_types_path');
  final customTypesPath =
      customTypesConfig is String ? customTypesConfig : 'custom-types.json';
  final includeTypesList =
      Set<String>.from(config.remove('include_types') as List? ?? <String>[]);

  return TiledCustomTypeAggregator(
    customTypesPath,
    includeTypesList,
  );
}
