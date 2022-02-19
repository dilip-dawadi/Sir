// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoProvider extends ChangeNotifier {
  final httpClient = http.Client();
  List? todoData = [];
  Map? mapResponse = {};
  int? adminCurrentPage = 1;
  String? test;
  Map<String, String> customHeaders = {
    "Accept": "application/json",
    "Content-Type": "application/json;charset=UTF-8"
  };

  //Get request
  Future fetchData(int adminCurrentPage) async {
    try {
      final Uri restAPIURL = Uri.parse(
          "https://kalijfarm.herokuapp.com/kalijs?adminPage=$adminCurrentPage");
      http.Response response = await httpClient.get(restAPIURL);
      mapResponse = await jsonDecode(response.body.toString());
      todoData = mapResponse?['adminData'];
      if (response.statusCode == 200) {
        return 'success';
      } else {
        // server error
        return Future.error('Server Error');
      }
    } catch (error) {
      return Future.error(error.toString());
    }
  }

  //Post request
  Future addData(Map<String, String> body) async {
    try {
      final Uri restAPIURL =
          Uri.parse("https://kalijfarm.herokuapp.com/kalijs");
      http.Response response = await httpClient.post(restAPIURL,
          headers: customHeaders, body: jsonEncode(body));
      if (response.statusCode == 201) {
        return 'success';
      } else {
        // server error
        return 'error';
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  //Delete request
  Future deleteData(String id) async {
    try {
      final Uri restAPIURL =
          Uri.parse("https://kalijfarm.herokuapp.com/kalijs/$id");

      http.Response response =
          await httpClient.delete(restAPIURL, headers: customHeaders);
      if (response.statusCode == 200) {
        return 'success';
      } else {
        // server error
        return 'error';
      }
    } catch (e) {
      return Future.error(e);
    }
  }

// update request
  Future updateData(Map<String, String> body, String id) async {
    try {
      final Uri restAPIURL =
          Uri.parse("https://kalijfarm.herokuapp.com/kalijs/$id");
      http.Response response = await httpClient.patch(restAPIURL,
          headers: customHeaders, body: jsonEncode(body));
      if (response.statusCode == 200) {
        return 'success';
      } else {
        // server error
        return 'error';
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
