import 'package:firebaseauthproject/blocs/authentication_bloc/authentication_state.dart';
import 'package:firebaseauthproject/blocs/authentication_bloc/authentication_event.dart';
import 'package:firebaseauthproject/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication_state.dart';

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
      yield* _mapAuthenticationLoggedInToState();
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutInToState();
    }
  }

  //AuthenticationLoggedOut
  Stream<AuthenticationState> _mapAuthenticationLoggedOutInToState() async* {
    yield AuthenticationFailure();
    _userRepository.signOut();
  }

  //AuthenticationLoggedIn
  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    yield AuthenticationSuccess(await _userRepository.getUser());
  }

  // AuthenticationStarted
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
