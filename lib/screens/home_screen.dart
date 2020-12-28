import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:movie_app/bloc/authentication_bloc/authentication_event.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:movie_app/widgets/genre_widget.dart';
import 'package:movie_app/widgets/now_playing_widget.dart';
import 'package:movie_app/widgets/persons_widget.dart';
import 'package:movie_app/widgets/top_movies_widget.dart';

class HomeScreen extends StatefulWidget {
  final auth.User firebaseUser;

  const HomeScreen({Key key, this.firebaseUser}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState(firebaseUser);
}

class _HomeScreenState extends State<HomeScreen> {
  final auth.User firebaseUser;

  _HomeScreenState(this.firebaseUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Movie App"),
        backgroundColor: Style.Colors.mainColor,
        leading: IconButton(
            icon: Icon(
              EvaIcons.person,
              color: Colors.white,
            ),
            onPressed: () {
              _showAlertDialog();
            }),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLoggedOut());
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          NowPlaying(),
          GenresScreen(),
          PersonList(),
          TopMovies()
        ],
      ),
    );
  }

  void _showAlertDialog() {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        // This closes the dialog. `context` means the BuildContext, which is
        // available by default inside of a State object. If you are working
        // with an AlertDialog in a StatelessWidget, then you would need to
        // pass a reference to the BuildContext.
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Style.Colors.mainColor,
      title: Text(
        "User Detail",
        style: TextStyle(
          color: Style.Colors.secondColor,
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
      ),
      content: Text(
        "Email-id: ${firebaseUser.email} ",
        style: TextStyle(
          color: Style.Colors.secondColor,
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
