import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildingAdderCubit extends Cubit<BuildingAdderEvent> {
  BuildingAdderCubit() : super(BuildingAdderInitState());
  static BuildingAdderCubit get(context) => BlocProvider.of(context);

  void emailBuildingAdder(int number, String name, double latitude, double longitude, String photoURL) {

  }
}

abstract class BuildingAdderEvent {}
class BuildingAdderInitState extends BuildingAdderEvent {}
class BuildingAdderLoading extends BuildingAdderEvent {}
class BuildingAdderSuccess extends BuildingAdderEvent {}
class BuildingAdderError extends BuildingAdderEvent {
  final String error;
  BuildingAdderError(this.error);
}