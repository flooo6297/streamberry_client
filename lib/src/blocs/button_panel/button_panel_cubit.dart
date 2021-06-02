import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_state.dart';

class ButtonPanelCubit extends Cubit<ButtonPanelState> {


  List<int> path = [];

  ButtonPanelCubit._(ButtonPanelState initialState,)
      : super(initialState);

  static ButtonPanelCubit init(int x, int y,
      {ButtonData? parentButtonData,
      ButtonPanelCubit? parentButtonPanelCubit}) {
    ButtonPanelState initialState = ButtonPanelState(
        x,
        y,
        const Size(100, 100),
        Colors.black87,
        const EdgeInsets.all(8.0)); //TODO: Implement loading from disk
    return ButtonPanelCubit._(initialState,);
  }

  ButtonPanelCubit(ButtonPanelState initialState) : super(initialState);

  ButtonPanelState getState() {
    ButtonPanelState cur = state;
    for (var value in path) {
      cur = cur.panelList[value].childState!;
    }
    return cur;
  }

  void setState(ButtonPanelState newState) {
    emit(ButtonPanelState.copy(newState));
  }

  void refresh() {
    _saveAndSync();
  }

  ButtonData? getButtonData(ButtonData buttonData) {
    return getState().panelList.firstWhere((element) => element.equals(buttonData));
  }

  void _saveAndSync() {
    emit(ButtonPanelState.copy(state));
  }
}
