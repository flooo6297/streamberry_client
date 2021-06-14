import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/folder/folder_functions.dart';

import '../../button_action.dart';

class OpenFolderAction extends ButtonAction {
  late ButtonPanelCubit buttonPanelCubit;

  OpenFolderAction(ButtonFunctions parentType) : super(parentType);

  @override
  Future<void> runFunction(
      ButtonPanelCubit buttonPanelCubit,
  ) async {
    return Future.value();
  }

  Future<void> runFolderFunction(
      ButtonPanelCubit buttonPanelCubit,
    ButtonData parentButtonData,BuildContext context,
  ) async {
    buttonPanelCubit.path.add(buttonPanelCubit
        .getState()
        .panelList
        .firstWhere((element) => element==(parentButtonData)).id);
    buttonPanelCubit.refresh(context);

    return Future.value();
  }

  @override
  get title => 'Add Folder';

  @override
  get tooltip => 'Adds a folder, that can be opened';

  @override
  bool isVisible(BuildContext context) => true;

  @override
  get actionName => 'openAction';

  @override
  Map<String, String> getDefaultParams() => {};
}
