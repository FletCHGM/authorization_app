import 'package:authorization_app/features/repos/repos_view.dart';
part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<TryToLogin>((event, emit) async {
      try {
        emit(AuthLoadig());
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.login!, password: event.passwd!);
        Navigator.of(event.context!)
            .push(MaterialPageRoute(builder: (context) => const HomePage()));
        emit(AuthSuccess());
      } on FirebaseAuthException catch (e) {
        UserAlert().loginErrorAlerts(e.code, event.context!);
        emit(AuthFailure(e.code));
      }
    });
    on<TryToReg>((event, emit) async {
      try {
        emit(AuthLoadig());
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.login!,
          password: event.passwd!,
        );
        Navigator.of(event.context!)
            .push(MaterialPageRoute(builder: (context) => const LoginPage()));
        emit(AuthSuccess());
      } on FirebaseAuthException catch (e) {
        UserAlert().regErrorAlerts(e.code, event.context!);
        emit(AuthFailure(e.code));
      }
    });
  }
}
