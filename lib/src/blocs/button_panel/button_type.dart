
import 'package:flutter/material.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';

abstract class ButtonType {

  bool get canBeOverwritten;

  String get type;

  void delete();

  Widget buildButton(ButtonPanelCubit buttonPanelCubit, ButtonData buttonData);

  Widget buildSettings(ButtonPanelCubit buttonPanelCubit, ButtonData buttonData);

}