import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/authentication_bloc/authentication_event.dart';
import 'package:movie_app/bloc/authentication_bloc/authentication_state_bloc.dart';
import 'package:movie_app/repository/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInState();
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutState();
    }
  }

  //Authentication Logged Out
  Stream<AuthenticationState> _mapAuthenticationLoggedOutState() async* {
    yield AuthenticationFailure();
    _userRepository.signOut();
  }

  //Authentication LoggedIn
  Stream<AuthenticationState> _mapAuthenticationLoggedInState() async* {
    yield AuthenticationSuccess(await _userRepository.getUser());
  }

  //Authentication Started
  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      final firebaseUser = await _userRepository.getUser();
      yield AuthenticationSuccess(firebaseUser);
    } else {
      yield AuthenticationFailure();
    }
  }
}
