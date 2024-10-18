import 'Location.dart';
import 'Assets.dart';

enum TreeType {
  company,
  location,
  asset,
  component
}

class Tree {
  String id;
  String name;
  String? sensorType;
  String? status;
  TreeType type;
  int level;
  List<Tree> children;

  Tree({required this.id, required this.name, this.sensorType, this.status, required this.type, required this.level, required this.children});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'sensorType': sensorType,
      'type': type,
      'level': level,
      ''
      'children': children.map((child) => child.toJson()).toList(),
    };
  }

  static Tree fromJson(Map<String, dynamic> json) {
    return Tree(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      sensorType: json['sensorType'],
      type: json['type'],
      level: json['level'],
      children: (json['children'] as List)
          .map((childJson) => Tree.fromJson(childJson))
          .toList(),
    );
  }
}