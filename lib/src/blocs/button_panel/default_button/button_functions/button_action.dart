import 'package:flutter/material.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/on_click.dart';

abstract class ButtonAction {

  ButtonAction(this.parentType);

  ButtonFunctions parentType;

  get title;
  get tooltip;

  get actionName;

  ButtonFunctions getParentType() => parentType;

  Future<void> runFunction(ButtonPanelCubit buttonPanelCubit);

  bool isVisible(BuildContext context);

  Map<String, String> getDefaultParams();

  OnClick toOnClick() {
    return OnClick(getParentType().function, actionName, params: getDefaultParams());
  }

}