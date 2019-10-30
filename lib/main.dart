import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Internet Connectivity',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _connectivityStatus = 'Unknown';
  Connectivity connectivity;

  StreamSubscription<ConnectivityResult> _subscription;

  Future getData() async {
    http.Response response =
        await http.get('https://jsonplaceholder.typicode.com/posts/');
    if (response.statusCode == HttpStatus.OK) {
      var result = jsonDecode(response.body);
      return result;
    }
  }

  @override
  void initState() {
    super.initState();
    connectivity = Connectivity();
    _subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      print(result);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connectivy'),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> data = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.wifi),
                title: Text(data[index]['title']),
                //subtitle: Text(data[index]['body']),
              ),
              itemCount: data.length,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
