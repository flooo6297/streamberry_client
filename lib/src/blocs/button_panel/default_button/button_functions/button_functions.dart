import 'package:flutter/cupertino.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/folder/folder_functions.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/on_click.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/default_button.dart';

import 'button_action.dart';

abstract class ButtonFunctions {
  //List<Function()> actions();

  Map<String, ButtonAction> actions(Map<String, String> params);

  get title;

  get function;

  static Map<String, ButtonFunctions> functions = <ButtonFunctions>[
    FolderFunctions(),
  ].asMap().map((key, value) => MapEntry(value.function as String, value));

  static List<ButtonAction> getActions(ButtonData buttonData) {
    List<ButtonAction> toReturn = [];

    for (OnClick onClick in (buttonData.buttonType as DefaultButton).onClicks) {
      if (ButtonFunctions.functions.containsKey(onClick.function)) {
        if (ButtonFunctions.functions[onClick.function]!
            .actions(onClick.params)
            .containsKey(onClick.action)) {
          toReturn.add(ButtonFunctions.functions[onClick.function]!
              .actions(onClick.params)[onClick.action]!);
        }
      }
    }

    return toReturn;
  }
}
