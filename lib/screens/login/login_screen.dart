import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/login_bloc/login_bloc.dart';
import 'package:movie_app/repository/user_repository.dart';
import 'package:movie_app/screens/login/login_form.dart';
import 'package:movie_app/widgets/curved_widget.dart';
import 'package:movie_app/style/theme.dart' as Style;

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  const LoginScreen({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Style.Colors.transparent,
      ),
      body: BlocProvider<LoginBloc>(
        create: (context)=>LoginBloc(userRepository: _userRepository),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Style.Colors.titleColor, Style.Colors.mainColor],
          )),
          child: Stack(
            children: [
              CurvedWidget(
                child: Container(
                  padding: const EdgeInsets.only(top: 100.0, left: 50.0),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors:  [Style.Colors.titleColor, Style.Colors.titleColor.withOpacity(0.4)],
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 40,
                      color:Style.Colors.secondColor,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 230),
                child: LoginForm(
                  userRepository: _userRepository,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
