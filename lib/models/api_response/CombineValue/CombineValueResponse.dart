class CombineValueResponse {
  int row;
  int column;
  int value;

  CombineValueResponse({this.row, this.column, this.value});

  CombineValueResponse.fromJson(Map<String, dynamic> json) {
    row = json['row'];
    column = json['column'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row'] = this.row;
    data['column'] = this.column;
    data['value'] = this.value;
    return data;
  }
}