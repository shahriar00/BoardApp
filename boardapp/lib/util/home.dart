import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class BoardApp extends StatefulWidget {
  const BoardApp({super.key});

  @override
  State<BoardApp> createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
  var firebasedb = FirebaseFirestore.instance.collection('board').snapshots();

  TextEditingController namecontroller = TextEditingController();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Board App"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _dialogBuilder(context);
        },
        child: Icon(Icons.edit),
      ),

      //Data read from the firebase database
      body: StreamBuilder(
          stream: firebasedb,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            return ListView.builder(
                itemCount: snapshot.requireData.size,
                itemBuilder: (context, int index) {
                  // return CustomCard(
                  //     snapshot: snapshot.requireData, index: index);

                  return Container(
                    height: 150,
                    child: Card(
                        elevation: 10,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.requireData.docs[index]['title'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                snapshot.requireData.docs[index]['description'],
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 28,
                              ),
                              Row(
                                children: [
                                  //Update Data .........
                                  IconButton(
                                      onPressed: () {
                                        var docid =
                                            snapshot.requireData.docs[index].id;
                                        TextEditingController
                                            namecontrollerupdate =
                                            TextEditingController(
                                                text: snapshot.requireData
                                                    .docs[index]['name']);
                                        TextEditingController
                                            titlecontrollerupdate =
                                            TextEditingController(
                                                text: snapshot.requireData
                                                    .docs[index]['title']);
                                        TextEditingController
                                            descontrollerupdate =
                                            TextEditingController(
                                                text: snapshot
                                                        .requireData.docs[index]
                                                    ['description']);
                                        showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Information For Update'),
                                              content: Column(
                                                children: [
                                                  Text(
                                                      "Text Editing Controller."),
                                                  Expanded(
                                                      child: TextField(
                                                    autocorrect: true,
                                                    autofocus: true,
                                                    decoration: InputDecoration(
                                                        labelText: "Your Name"),
                                                    controller:
                                                        namecontrollerupdate,
                                                  )),
                                                  Expanded(
                                                      child: TextField(
                                                    autocorrect: true,
                                                    autofocus: true,
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            "Your Title"),
                                                    controller:
                                                        titlecontrollerupdate,
                                                  )),
                                                  Expanded(
                                                      child: TextField(
                                                    autocorrect: true,
                                                    autofocus: true,
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            "Your Description"),
                                                    controller:
                                                        descontrollerupdate,
                                                  )),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  child: const Text('Update'),
                                                  onPressed: () {
                                                    //Navigator.of(context).pop();

                                                    //Save Data in the Firebase Database

                                                    if (namecontrollerupdate.text.isNotEmpty && titlecontrollerupdate
                                                            .text.isNotEmpty &&
                                                        descontrollerupdate
                                                            .text.isNotEmpty) {
                                                      FirebaseFirestore.instance
                                                          .collection('board')
                                                          .doc(docid)
                                                          .update({
                                                        "name":
                                                            namecontrollerupdate.text,
                                                        "title": titlecontrollerupdate
                                                            .text,
                                                        "description":
                                                            descontrollerupdate
                                                                .text,
                                                        // "timestamp":
                                                        //     DateTime.now()
                                                      }).then((response) =>
                                                              Navigator.pop(
                                                                  context));
                                                    }
                                                  },
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  child: const Text('Save'),
                                                  onPressed: () {
                                                    //Navigator.of(context).pop();

                                                    //Save Data in the Firebase Database

                                                    if (namecontroller
                                                            .text.isNotEmpty &&
                                                        titlecontroller
                                                            .text.isNotEmpty &&
                                                        descriptioncontroller
                                                            .text.isNotEmpty) {
                                                      FirebaseFirestore.instance
                                                          .collection('board')
                                                          .add({
                                                            "name":
                                                                namecontroller
                                                                    .text,
                                                            "title":
                                                                titlecontroller
                                                                    .text,
                                                            "description":
                                                                descriptioncontroller
                                                                    .text,
                                                            //"timestamp": DateTime.now()
                                                          })
                                                          .then((response) => {
                                                                print(response),
                                                                Navigator.pop(
                                                                    context)
                                                              })
                                                          .catchError((error) {
                                                            print(error);
                                                          });
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.edit_document)),

                                  //Delete Data..........

                                  IconButton(
                                      onPressed: () {
                                        var docid =
                                            snapshot.requireData.docs[index].id;
                                        FirebaseFirestore.instance
                                            .collection('board')
                                            .doc(docid)
                                            .delete();
                                      },
                                      icon: Icon(Icons.delete))
                                ],
                              )
                            ])),
                  );
                });
          }),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Information'),
          content: Column(
            children: [
              Text("Text Editing Controller."),
              Expanded(
                  child: TextField(
                autocorrect: true,
                autofocus: true,
                decoration: InputDecoration(labelText: "Your name"),
                controller: namecontroller,
              )),
              Expanded(
                  child: TextField(
                autocorrect: true,
                autofocus: true,
                decoration: InputDecoration(labelText: "Your Title"),
                controller: titlecontroller,
              )),
              Expanded(
                  child: TextField(
                autocorrect: true,
                autofocus: true,
                decoration: InputDecoration(labelText: "Your Description"),
                controller: descriptioncontroller,
              )),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Save'),
              onPressed: () {
                //Navigator.of(context).pop();

                //Save Data in the Firebase Database

                if (namecontroller.text.isNotEmpty &&
                    titlecontroller.text.isNotEmpty &&
                    descriptioncontroller.text.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection('board')
                      .add({
                        "name": namecontroller.text,
                        "title": titlecontroller.text,
                        "description": descriptioncontroller.text,
                        //"timestamp": DateTime.now()
                      })
                      .then((response) =>
                          {print(response), Navigator.pop(context)})
                      .catchError((error) {
                        print(error);
                      });
                }
              },
            ),

            //Update and Delete Data from the board..........

            //Delete Data
            //TextButton(onPressed: () {}, child: Text("Delete")),

            //Update Data
            //TextButton(onPressed: () {}, child: Text("Update"))
          ],
        );
      },
    );
  }
}
