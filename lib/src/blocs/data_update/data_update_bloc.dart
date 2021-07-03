import 'package:bloc/bloc.dart';

class DataUpdateBloc extends Cubit<Map<String, String>> {


  DataUpdateBloc() : super({});

  void newUpdate(Map<String, String> update) => emit(update);

}
