class Companies{
  String id;
  String name;
  bool loading;

  Companies({required this.id, required this.name, required this.loading});

  factory Companies.fromData(dynamic data){
    return Companies(id: data['id'],
      name: data['name'].toString().contains("Unit")?data['name'].toString():"${data['name'].toString()} Unit",
      loading: true);
  }
}