import 'dart:async';
import 'dart:convert';

import 'package:yelp_fusion_flutter/config.dart';
import 'package:yelp_fusion_flutter/models/business.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ParsedResponse<T> {
  ParsedResponse(this.statusCode, this.body);

  final int statusCode;
  final T body;

  bool isSuccess() {
    return statusCode >= 200 && statusCode < 300;
  }
}

const int CODE_OK = 200;
const int CODE_REDIRECTION = 300;
const int CODE_NOT_FOUND = 404;

class Repository {
  static final Repository _repo = new Repository._internal();
  static const String API_KEY = "IaoQhf0vepwGXHDceRVU74E4pEBkCUsVr0RbqjAj9wJF8cB2lKuY8KWu99hVDTUfMY3mokO_7z5Fuz8ssbx5sYM4ajjLNax4jB_mriLvhbcuspVCp-Fkay23izQiWXYx";
  static const Map<String, String> AUTH_HEADER = {"Authorization": "Bearer $API_KEY"};

  static Repository get() {
    return _repo;
  }

  Repository._internal();

  Future<List<Business>> getBusinesses() async {

    String webAddress = "https://api.yelp.com/v3/businesses/search?latitude=${AppConfig.latitude}&longitude=${AppConfig.longitude}";

    http.Response response = await http.get(webAddress, headers: AUTH_HEADER).catchError((resp) {});

    // Error handling
    if (response == null || response.statusCode < CODE_OK || response.statusCode >= CODE_REDIRECTION) {
      return Future.error(response.body);
    }

    Map<String, dynamic> map = json.decode(response.body);

    Iterable jsonList = map["businesses"];
    List<Business> businesses = jsonList.map((model) => Business.fromJson(model)).toList();

    debugPrint(jsonList.toString());

    return businesses;
  }
}
