class Assets {
  String companyId;
  String? gatewayId;
  String id;
  String? locationId;
  String name;
  String? parentId;
  String? sensorId;
  String? sensorType;
  String? status;

  Assets({required this.companyId,this.gatewayId, required this.id, this.locationId, required this.name, this.parentId, this.sensorId, required this.sensorType, required this.status});

  factory Assets.fromData(String companyId,dynamic data) =>
      Assets(companyId: companyId, gatewayId: data['gatewayId'], id: data['id'], locationId: data['locationId'],
          name: data['name'], parentId: data['parentId'], sensorId: data['sensorId'],
          sensorType: data['sensorType'], status: data['status']);
}
