import 'package:json_annotation/json_annotation.dart';

part 'Models.g.dart';

@JsonSerializable(nullable: false)
class ViewPort
{
  int id;
  String name;
  List<Group> groups;

  ViewPort();

  factory ViewPort.fromJson(Map<String, dynamic> json) => _$ViewPortFromJson(json);
  Map<String, dynamic> toJson() => _$ViewPortToJson(this);
}

@JsonSerializable(nullable: false)
class Group
{
  String name;
  List<Property> properties;
  List<Group> subGroups;
  GroupLayout layout;

  Group();

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable(nullable: false)
class Property
{
  String name;
  String value;
  String display;
  bool editable = true;

  Property();

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyToJson(this);
}

@JsonSerializable(nullable:false)
class GroupLayout
{
  int columns;

  GroupLayout();
}