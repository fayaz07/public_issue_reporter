class Result {
  bool hasData, success;
  String message;
  dynamic data;

  Result({this.hasData, this.success, this.message, this.data});

  @override
  String toString() {
    return "Result { success: ${this.success}, hasData: ${this.hasData}, message: ${message ?? "No message"}, data: ${data ?? "No data"} }";
  }
}