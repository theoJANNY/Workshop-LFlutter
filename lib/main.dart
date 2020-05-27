import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CardDB.dart';
import 'CardModel.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selection/selection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  List<User> listOfUser = new List();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  List<TextEditingController> memoController = new List();
  var uuid = Uuid();

  void initState() {
    memoController.add(new TextEditingController());
    memoController.add(new TextEditingController());
    memoController.add(new TextEditingController());

    super.initState();
    getListOfUser();
  }

  getListOfUser() async {
    UserDB userDB = UserDB();
    listOfUser = await userDB.getUser();
  }

  changeUser(User user) {
    memoController[0].text = user.first_name;
    memoController[1].text = user.last_name;
    memoController[2].text = user.telephone;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Modifier un utilisateur",
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close, color: Colors.black),
                  )
                ]),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First name',
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      controller: memoController[0],
                    ),
                  ),
                  Card(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last name',
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      controller: memoController[1],
                    ),
                  ),
                  Card(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Telephone',
                      ),
                      keyboardType: TextInputType.number,
                      controller: memoController[2],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(),
                    FloatingActionButton(
                      backgroundColor: Colors.blue,
                      onPressed: () async {
                        if (memoController[0].text.isNotEmpty ||
                            memoController[1].text.isNotEmpty ||
                            memoController[2].text.isNotEmpty) {
                          FocusScope.of(context).requestFocus(new FocusNode());

                          UserDB userDB = UserDB();
                          user.last_name = memoController[1].text;
                          user.first_name = memoController[0].text;
                          user.telephone = memoController[2].text;
                          await userDB.updateUser(user);
                          listOfUser = await userDB.getUser();
                          setState(() {
                            listOfUser = listOfUser;
                            memoController[0].text = "";
                            memoController[1].text = "";
                            memoController[2].text = "";
                          });
                          Navigator.of(context).pop();
                          key.currentState.showSnackBar(SnackBar(
                            content:
                            new Text("L'utilisateur a bien été ajouté"),
                            duration: new Duration(seconds: 2),
                            backgroundColor: Colors.green,
                            action: new SnackBarAction(
                                label: "Ok",
                                textColor: Colors.white,
                                onPressed: () {}),
                          ));
                        } else {
                          key.currentState.showSnackBar(new SnackBar(
                            content: new Text(
                                "Veuillez insérer du text dans tout les champs"),
                            duration: new Duration(seconds: 2),
                            backgroundColor: Colors.red,
                            action: new SnackBarAction(
                                label: "Ok",
                                textColor: Colors.white,
                                onPressed: () {}),
                          ));
                        }
                      },
                      child: Icon(Icons.save, color: Colors.white),
                    )
                  ]),
            ],
          );
        });
  }

  Future<Widget> buildListCard() async {
    UserDB userDB = UserDB();

    listOfUser = await userDB.getUser();
    if (listOfUser.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: listOfUser.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () async {
                  changeUser(listOfUser[index]);
                },
                child: Card(
                    margin: EdgeInsets.only(
                      top: MediaQuery
                          .of(context)
                          .size
                          .height * 0.01,
                      bottom: MediaQuery
                          .of(context)
                          .size
                          .height * 0.01,
                      right: MediaQuery
                          .of(context)
                          .size
                          .width * 0.01,
                      left: MediaQuery
                          .of(context)
                          .size
                          .width * 0.01,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTYQ-T4F-hkpnb3ryHEyx3SofZH-5v72-K5tzndAFTBISztN7Jp&usqp=CAU"),
                        ),
                        Container(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 10,
                            ),
                            Text("Prénom: " + listOfUser[index].first_name),
                            Container(
                              height: 10,
                            ),
                            Text("Nom: " + listOfUser[index].last_name),
                            Container(
                              height: 10,
                            ),
                            Text("Téléphone: " + listOfUser[index].telephone),
                            Container(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ))
            );
          });
    } else {
      return Center(
        child: Text(
          "Aucun utilisateur",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      );
    } // IconButton(icon: Icon(Icons.edit), onPressed: (){}
  }

  addUser(var oldcontext) {
    //this goes in our State class as a global variable
    memoController[0].text = "";
    memoController[1].text = "";
    memoController[2].text = "";
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Ajouter un utilisateur",
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close, color: Colors.black),
                  )
                ]),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First name',
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      controller: memoController[0],
                    ),
                  ),
                  Card(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last name',
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      controller: memoController[1],
                    ),
                  ),
                  Card(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Telephone',
                      ),
                      keyboardType: TextInputType.number,
                      controller: memoController[2],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(),
                    FloatingActionButton(
                      backgroundColor: Colors.blue,
                      onPressed: () async {
                        if (memoController[0].text.isNotEmpty ||
                            memoController[1].text.isNotEmpty ||
                            memoController[2].text.isNotEmpty) {
                          FocusScope.of(context).requestFocus(new FocusNode());

                          UserDB userDB = UserDB();
                          User inputUser = User(
                              DateTime.now().toString(),
                              memoController[2].text,
                              memoController[0].text,
                              memoController[1].text,
                              id: uuid.v1());
                          await userDB.insertUser(inputUser);
                          setState(() {
                            listOfUser.add(inputUser);
                            memoController[0].text = "";
                            memoController[1].text = "";
                            memoController[2].text = "";
                          });
                          Navigator.of(context).pop();
                          key.currentState.showSnackBar(SnackBar(
                            content:
                            new Text("L'utilisateur a bien été ajouté"),
                            duration: new Duration(seconds: 2),
                            backgroundColor: Colors.green,
                            action: new SnackBarAction(
                                label: "Ok",
                                textColor: Colors.white,
                                onPressed: () {}),
                          ));
                        } else {
                          key.currentState.showSnackBar(new SnackBar(
                            content: new Text(
                                "Veuillez insérer du text dans tout les champs"),
                            duration: new Duration(seconds: 2),
                            backgroundColor: Colors.red,
                            action: new SnackBarAction(
                                label: "Ok",
                                textColor: Colors.white,
                                onPressed: () {}),
                          ));
                        }
                      },
                      child: Icon(Icons.save, color: Colors.white),
                    )
                  ]),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My App"),
      ),
      key: key,
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder<Widget>(
            future: buildListCard(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data;
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          addUser(context);
        },
        tooltip: 'Add Card',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
