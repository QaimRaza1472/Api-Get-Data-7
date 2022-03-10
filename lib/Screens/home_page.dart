import 'dart:convert';

import 'package:api_get_data_7/Themes/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List users = [];
  bool isLoading=false;

@override
  void initState() {
        super.initState();
        this.fetchUser();
  }

  fetchUser() async{

  var url = "https://randomuser.me/api/?results=100";
  var response = await http.get(url);
  if(response.statusCode==200){
    var items = json.decode(response.body)['results'];
    print(response.body);
    setState(() {
      users = items;
      isLoading=false;
    });
  }else{
    setState(() {
      users = [];
      isLoading=true;


    });
  }



  }











  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primary,
        title:const Text("Listing Users",
        style: TextStyle(
            color: Colors.white,
        ),
        ) ,
      ),
      body: getBody(),


    );
  }
  Widget ? getBody(){
  if(users.contains(null)|| users.length<0 ||isLoading ){
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.red,
      ),
    );
  }
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context,index){
          return getCard(users[index]);
        }
    );


  }
  Widget getCard(items){
  var fullName = items['name']['title']+' '+items['name']['first']+' '+items['name']['last'];
  var email=items["email"];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration:  BoxDecoration(
                  color: Colors.grey.withOpacity(0.6),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(items['picture']['large'].toString()),
                    fit: BoxFit.cover,
                  ),

                ),
              ),
              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(fullName.toString(),
                  style:  const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold

                  ),
                  ),
                  const SizedBox(height: 10,),
                  Text(email.toString(),
                    style: const TextStyle(
                      color: Colors.grey
                    ),
                  ),
                  Text(items['location']['street']['number'].toString(),
                    style: const TextStyle(
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



}
