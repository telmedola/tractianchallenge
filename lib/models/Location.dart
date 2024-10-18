class Location {
  String? companyId;
  String id;
  String name;
  String? parentId;

  Location({this.companyId, required this.id, required this.name, this.parentId});

  factory Location.fromData(String companyId,dynamic data) =>
      Location(companyId: companyId,id: data['id'], name: data['name'], parentId: data['parentId']);


}