import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginCEvent> {
  LoginCubit() : super(LoginCInitState());
  static LoginCubit get(context) => BlocProvider.of(context);

  void emailLogin(String email, String password) {
    emit(LoginCLoginLoading());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).
    then((value) {
      emit(LoginCLoginSuccess());
    }).catchError((error) {
      emit(LoginCLoginError(error.toString()));
    });
  }
}

abstract class LoginCEvent {}
class LoginCInitState extends LoginCEvent {}
class LoginCLoginLoading extends LoginCEvent {}
class LoginCLoginSuccess extends LoginCEvent {}
class LoginCLoginError extends LoginCEvent {
  final String error;
  LoginCLoginError(this.error);
}
class LoginCGuest extends LoginCEvent {}