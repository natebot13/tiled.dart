// GENERATED CODE, DO NOT MANUALLY EDIT.

import 'package:tiled/tiled.dart';

import 'more_custom_types.dart';
import 'my_custom_types.dart';
Object? $getCustomTypeInstance(CustomTypeProperty property) {
  if (property.propertyType == 'FileData') return FileData.fromJson(property.value);
  if (property.propertyType == 'FilePair') return FilePair.fromJson(property.value);
  if (property.propertyType == 'SomeCoolObject') return SomeCoolObject.fromJson(property.value);
  return null;
}


Object? $getCustomTypeEnum(StringProperty property) {
  if (property.propertyType == 'Thing') return Thing.values.asNameMap()[property.value];
  return null;
}
