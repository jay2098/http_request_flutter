import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = 'https://randomuser.me/api/?results=25';
  List data;

  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      var extractData = json.decode(response.body);
      data = extractData["results"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Contact List'),
        ),
        body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            return ListTile(
              title: Text(data[i]["name"]["first"]),
              subtitle: Text(data[i]["phone"]),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(data[i]["picture"]["thumbnail"]),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SecondPage(data[i])));
              },
            );
          },
        ));
  }
}

class SecondPage extends StatelessWidget {
  SecondPage(this.data);

  final data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Second Page"),
        ),
        body: Center(
          child: Container(
            width: 150.0,
            height: 150.0,
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: DecorationImage(
                image: NetworkImage(data["picture"]["large"]),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(75.0)),
              border: Border.all(
                color: Colors.red,
                width: 4.0,
              ),
            ),
          ),
        ));
  }
}
