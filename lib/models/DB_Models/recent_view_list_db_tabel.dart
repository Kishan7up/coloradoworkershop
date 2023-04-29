class RecentViewDBTable {
  int id;
  String title;
  String caseNo;
  String caseDetailShort;
  String caseDetailLong;
  String filter;
  String link;

  RecentViewDBTable(this.title, this.caseNo, this.caseDetailShort,
      this.caseDetailLong, this.filter, this.link,
      {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['caseNo'] = this.caseNo;
    data['caseDetailShort'] = this.caseDetailShort;
    data['caseDetailLong'] = this.caseDetailLong;
    data['filter'] = this.filter;
    data['link'] = this.link;

    return data;
  }

  @override
  String toString() {
    return 'RecentViewDBTable{id: $id, title: $title, caseNo: $caseNo, caseDetailShort: $caseDetailShort, caseDetailLong: $caseDetailLong, filter: $filter, link: $link}';
  }
}
