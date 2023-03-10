class RecentViewDBTable {
  int id;
  String CustomerID;

  String CustomerName;

  RecentViewDBTable(this.CustomerID, this.CustomerName, {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.CustomerID;
    data['CustomerName'] = this.CustomerName;

    return data;
  }

  @override
  String toString() {
    return 'RecentViewDBTable{id: $id, CustomerID: $CustomerID, CustomerName: $CustomerName}';
  }
}
