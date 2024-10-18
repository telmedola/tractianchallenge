class ApiReturn {
  int statusCode = 0;
  dynamic data;

  setReturn({required statusCode, required dynamic data}){
    this.statusCode = statusCode;
    this.data = data;
  }
}