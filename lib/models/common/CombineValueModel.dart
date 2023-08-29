class CombineValueModel {
  int id,row,column,value;

  CombineValueModel(this.row,this.column,this.value,{this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row'] = this.row;
    data['column'] = this.column;
    data['value']=this.value;

    return data;
  }

  @override
  String toString() {
    return 'CombineValueModel{id: $id, row: $row,column: $column, value: $value}';
  }
}