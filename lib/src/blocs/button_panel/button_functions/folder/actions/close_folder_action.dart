import 'package:flutter/material.dart';
import 'package:streamberry_client/src/app.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/button_action.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/folder/folder_functions.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_state.dart';

class CloseFolderAction extends ButtonAction {
  late ButtonPanelCubit buttonPanelCubit;

  @override
  bool isVisible(BuildContext context) => Navigator.canPop(context);

  @override
  Future<void> runFunction(
      ButtonPanelCubit buttonPanelCubit,
  ) async {
    buttonPanelCubit.path.removeLast();
    buttonPanelCubit.refresh();
    return Future.value();
  }

  Future<void> runFolderFunction(
      ButtonPanelCubit buttonPanelCubit,
      ButtonPanelState buttonPanelState,
      ) async {

    buttonPanelCubit.path.removeLast();
    buttonPanelCubit.refresh();

    return Future.value();
  }

  @override
  get title => 'Close the current folder';

  @override
  get tooltip => '';

  @override
  void setParams(Map<String, String> params) {
  }

  @override
  get actionName => 'closeAction';

  @override
  Map<String, String> getParams() => {};

  @override
  ButtonFunctions getParentType() => FolderFunctions();
}
