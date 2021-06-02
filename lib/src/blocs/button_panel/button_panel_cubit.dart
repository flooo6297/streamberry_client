import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_state.dart';

class ButtonPanelCubit extends Cubit<ButtonPanelState> {


  List<int> path = [];

  ButtonPanelCubit._(ButtonPanelState initialState,)
      : super(initialState);

  ButtonPanelCubit(ButtonPanelState initialState) : super(initialState);

  String getPathString() {
    String pathString = "Home";
    ButtonPanelState cur = state;
    for (var value in path) {
      cur = cur.panelList[value].childState!;
      pathString = '$pathString ❯ ${cur.name}';
    }
    return pathString;
  }

  ButtonPanelState getState() {
    ButtonPanelState cur = state;
    for (int i = 0; i < path.length; i++) {
      if (cur.panelList[path[i]].childState == null) {
        path.removeRange(i, path.length);
        return cur;
      }
      cur = cur.panelList[path[i]].childState!;
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
