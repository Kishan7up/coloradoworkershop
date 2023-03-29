import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RestaurantList extends StatefulWidget {
  static const routeName = '/RestaurantList';

  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  List<api_response_demo> _restaurantList = [];

  Future<void> _fetchRestaurantList() async {
    final response = await http.get(
      Uri.parse('https://admin.fataakse.co.in/api/vendors?page=1'),
    );
    if (response.statusCode == 200) {
      setState(() {
        var responsedetails = json.decode(response.body);
        print(responsedetails['first_page_url'].toString());
        Map<String, dynamic> jsonAPIResponse = responsedetails;
        api_response_demo companyDetailsResponse =
            api_response_demo.fromJson(jsonAPIResponse);
        //api_response_demo
        _restaurantList.add(companyDetailsResponse);
        // _restaurantList = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRestaurantList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant List'),
      ),
      body: ListView.builder(
        itemCount: _restaurantList.length,
        itemBuilder: (context, index) {
          final restaurant = _restaurantList[index];
          return Container(
            // Add your container details here using restaurant data
            child: Text(_restaurantList[index].firstPageUrl),
          );
        },
      ),
    );
  }
}

class api_response_demo {
  int currentPage;
  String firstPageUrl;
  int lastPage;
  String lastPageUrl;
  List<Links> links;
  Null nextPageUrl;
  String path;
  int perPage;
  int total;

  api_response_demo(
      {this.currentPage,
      this.firstPageUrl,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.total});

  api_response_demo.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];

    firstPageUrl = json['first_page_url'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;

    data['first_page_url'] = this.firstPageUrl;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    return data;
  }
}

class Links {
  String url;
  String label;
  bool active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
