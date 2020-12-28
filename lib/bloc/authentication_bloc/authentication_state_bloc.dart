import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final auth.User firebaseUser;

  AuthenticationSuccess(this.firebaseUser);

  @override
  List<Object> get props => [firebaseUser];
}
class AuthenticationFailure extends AuthenticationState {}
