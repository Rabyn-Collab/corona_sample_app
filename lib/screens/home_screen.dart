import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User{
  String id;
  String firstName;
  String lastName;
  String email;
  String title;
  String picture;
  User({this.email, this.firstName, this.id, this.lastName, this.picture, this.title});
  factory User.fromJson(Map<String, dynamic>json){
    return User(
    email: json['email'],
      firstName: json['firstName'],
      id: json['id'],
      lastName: json['lastName'],
      picture: json['picture'],
      title: json['title']
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


 List<User> res = [];



  Future<void> getData() async{
   final url = 'https://dummyapi.io/data/api/user?limit=10';
   final response = await http.get(Uri.parse(url), headers: {
     'app-id': '609e3a6e0be9944596eb9a3c'
   });
   final dat =  jsonDecode(response.body);
   final data = dat['data'] as List;

   setState(() {
     res =  data.map((e) => User.fromJson(e)).toList();
   });

  }

  @override
  void initState() {
   getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
              child:res.isEmpty ? Text('Welcome') : ListView.builder(
                  itemCount: res.length,
                  itemBuilder: (context, index)=> Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Container(
                        width: 100,
                        child: Image.network(res[index].picture, fit: BoxFit.cover,),
                      ),
                      title: Text('${res[index].firstName} ${res[index].lastName}'),
                      subtitle: Text(res[index].email),
                    ),
                  ),
            )
        )
    ),
    );
  }
}

