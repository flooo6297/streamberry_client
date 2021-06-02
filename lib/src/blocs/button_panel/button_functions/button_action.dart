import 'package:flutter/material.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/on_click.dart';

import '../button_panel_cubit.dart';

abstract class ButtonAction {

  get title;
  get tooltip;

  get actionName;

  ButtonFunctions getParentType();

  void setParams(Map<String, String> params);
  Map<String, String> getParams();

  Future<void> runFunction(ButtonPanelCubit buttonPanelCubit);

  bool isVisible(BuildContext context);

  OnClick toOnClick() {
    return OnClick(getParentType().function, actionName, params: getParams());
  }

}