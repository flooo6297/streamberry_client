import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_state.dart';

class UndefinedButton extends StatelessWidget {
  final ButtonData buttonData;
  final ButtonData nonDefinedButtonDesign;
  final ButtonPanelState buttonPanelState;

  const UndefinedButton(
      this.buttonData,
      this.buttonPanelState,
      this.nonDefinedButtonDesign,{
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: buttonPanelState.gridTilingSize.height * buttonData.positionY,
      left: buttonPanelState.gridTilingSize.width * buttonData.positionX,
      height: buttonPanelState.gridTilingSize.height * buttonData.height,
      width: buttonPanelState.gridTilingSize.width * buttonData.width,
      child: Container(
        margin: buttonPanelState.margin,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: nonDefinedButtonDesign.color, width: 3.0),
        ),
      ),
    );
  }

}
