import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  RegisterEmailChanged({this.email});

  @override
  List<Object> get props => [email];
}

class RegisteredPasswordChanged extends RegisterEvent{
  final String password;

  RegisteredPasswordChanged({this.password});

  @override
  List<Object> get props => [password];
}

class RegisterSubmitted extends RegisterEvent{
  final String email;
  final String password;

  RegisterSubmitted({this.password,this.email});

  @override
  List<Object> get props => [password,email];
}
