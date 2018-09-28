// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ViewPort _$ViewPortFromJson(Map<String, dynamic> json) {
  return ViewPort()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..groups = (json['groups'] as List)
        .map((e) => Group.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$ViewPortToJson(ViewPort instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'groups': instance.groups
    };

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group()
    ..name = json['name'] as String
    ..properties = (json['properties'] as List)
        .map((e) => Property.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$GroupToJson(Group instance) =>
    <String, dynamic>{'name': instance.name, 'properties': instance.properties};

Property _$PropertyFromJson(Map<String, dynamic> json) {
  return Property()
    ..name = json['name'] as String
    ..value = json['value'] as String
    ..display = json['display'] as String;
}

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'display': instance.display
    };
