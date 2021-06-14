import 'package:flutter/material.dart';
import 'package:streamberry_client/src/app.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/button_action.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/folder/folder_functions.dart';

class CloseFolderAction extends ButtonAction {
  late ButtonPanelCubit buttonPanelCubit;

  CloseFolderAction(ButtonFunctions parentType) : super(parentType);

  @override
  bool isVisible(BuildContext context) => Navigator.canPop(context);

  @override
  Future<void> runFunction(
    ButtonPanelCubit buttonPanelCubit,
  ) async {
    return Future.value();
  }

  Future<void> runFolderFunction(ButtonPanelCubit buttonPanelCubit,
      ButtonData parentButtonData, BuildContext context) async {
    buttonPanelCubit.path.removeLast();
    buttonPanelCubit.refresh(context);

    return Future.value();
  }

  @override
  get title => 'Close the current folder';

  @override
  get tooltip => '';

  @override
  get actionName => 'closeAction';

  @override
  Map<String, String> getDefaultParams() => {};
}
