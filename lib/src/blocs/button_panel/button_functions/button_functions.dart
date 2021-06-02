import 'package:flutter/cupertino.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/folder/folder_functions.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/on_click.dart';

import 'button_action.dart';

abstract class ButtonFunctions{
  //List<Function()> actions();

  Map<String, ButtonAction> actions(Map<String, String> params);

  get title;

  get function;

  static Map<String, ButtonFunctions> functions = {
    FolderFunctions().function: FolderFunctions(),
  };

  static List<ButtonAction> getActions(ButtonData buttonData) {

    List<ButtonAction> toReturn = [];

    for (OnClick onClick in buttonData.onClicks) {
      if (ButtonFunctions.functions.containsKey(onClick.function)) {
        if (ButtonFunctions.functions[onClick.function]!.actions(onClick.params).containsKey(onClick.action)) {
          toReturn.add(ButtonFunctions.functions[onClick.function]!.actions(onClick.params)[onClick.action]!);
        }
      }
    }

    return toReturn;
  }

}