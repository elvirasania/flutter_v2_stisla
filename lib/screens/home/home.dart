import 'dart:convert';

import 'package:flutter_v2_stisla/models/category.dart';
import 'package:flutter_v2_stisla/utils/api_urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_v2_stisla/screens/auth/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var categoryList = <Category>[];

  void fetchData() async {
    var categories = await getList();
    if (categories != null) {
      categoryList.addAll(categories);
    }
  }

  Future<List<Category>?> getList() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('token');
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.categories);

      http.Response response = await http.get(url, headers: headers);

      print(response.statusCode);
      print(categoryList.length);
      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        var jsonString = response.body;
        return categoryFromJson(jsonString);
      }
    } catch (error) {
      print('Testing');
    }
    return null;
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await _prefs;
    var token = prefs.getString('token');
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.logout);
      http.Response response = await http.post(url, headers: headers);
      // print(response.statusCode);
      // print(response.body);
      print(token);
      prefs.clear();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const AuthScreen()));
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  logout();
                },
                child: const Text(
                  'logout',
                  style: TextStyle(color: Colors.white),
                ))
          ],
          leading: TextButton(
              onPressed: () {
                fetchData();
              },
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
              )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text('List Category'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(categoryList[index].name),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
