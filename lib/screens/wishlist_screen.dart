import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:movie_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:movie_app/bloc/authentication_bloc/authentication_event.dart';

class WishListScreen extends StatelessWidget {
  final String documentId;

  WishListScreen(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          final List<dynamic> names = (data['movieName']);
          return Scaffold(
            backgroundColor: Style.Colors.mainColor,
            appBar: AppBar(
              centerTitle: true,
              title: Text("Movie App"),
              backgroundColor: Style.Colors.mainColor,
            ),
            body: ListView.builder(
                itemCount: names.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.only(
                      left: 30.0,
                      top: 20.0,
                    ),
                    child: Text('${names[index]}',
                        style: TextStyle(
                            color: Colors.white, fontSize: 14.0, height: 1.5)),
                  );
                }),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 25.0,
                width: 25.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 4.0,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
