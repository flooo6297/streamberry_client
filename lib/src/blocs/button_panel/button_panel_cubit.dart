import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_client/src/app.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_state.dart';

class ButtonPanelCubit extends Cubit<ButtonPanelState> {


  List<String> path = [];

  ButtonPanelCubit._(ButtonPanelState initialState,)
      : super(initialState);

  ButtonPanelCubit(ButtonPanelState initialState) : super(initialState);

  String getPathString() {
    return state.name;
  }

  ButtonPanelState getState() {
    return state;
  }

  void setState(ButtonPanelState newState) {
    emit(ButtonPanelState.copy(newState));
  }

  void refresh(BuildContext context) {
    _saveAndSync(context);
  }

  ButtonData? getButtonData(ButtonData buttonData) {
    return getState().panelList.firstWhere((element) => element==(buttonData));
  }

  void _saveAndSync(BuildContext context) {
    App.socketOf(context).emit('requestState', jsonEncode({'path': path}));
    //emit(ButtonPanelState.copy(state));
  }
}
