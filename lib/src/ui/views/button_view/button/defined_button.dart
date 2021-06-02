import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:streamberry_client/src/app.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/folder/actions/open_folder_action.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/on_click.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';

class DefinedButton extends StatelessWidget {
  final ButtonData buttonData;
  final ButtonPanelCubit buttonPanelCubit;

  const DefinedButton(
      this.buttonData,
      this.buttonPanelCubit, {
        Key? key,
      }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: buttonPanelCubit.state.gridTilingSize.height * buttonData.positionY,
      left: buttonPanelCubit.state.gridTilingSize.width * buttonData.positionX,
      height: buttonPanelCubit.state.gridTilingSize.height * buttonData.height,
      width: buttonPanelCubit.state.gridTilingSize.width * buttonData.width,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            height: buttonPanelCubit.state.gridTilingSize.height * buttonData.height,
            width: buttonPanelCubit.state.gridTilingSize.width * buttonData.width,
            child: Container(
              margin: buttonPanelCubit.state.margin,
              decoration: BoxDecoration(
                color: buttonData.color,
                border: Border.all(color: buttonData.color, width: 3.0),
              ),
              child: IconButton(
                onPressed: () {
                  List<OnClick> onClicks = List.of(buttonData.onClicks);
                  ButtonFunctions.getActions(buttonData).forEach((buttonAction) {
                    if (buttonAction is OpenFolderAction) {
                      buttonAction.runFolderFunction(buttonPanelCubit, buttonData);
                    } else {
                      buttonAction.runFunction(buttonPanelCubit);
                    }
                    onClicks.removeWhere((element) => element.equals(buttonAction.toOnClick()));
                  });
                  List<Map<String, dynamic>> jsons = onClicks.map((e) => e.toJson()).toList();
                  App.socketOf(context).write(jsonEncode({'actions' :jsons}));
                },
                icon: const Icon(Icons.margin),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
