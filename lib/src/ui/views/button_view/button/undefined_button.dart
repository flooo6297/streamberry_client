import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/default_button.dart';

class UndefinedButton extends StatelessWidget {
  final ButtonData buttonData;
  final ButtonPanelCubit buttonPanelCubit;

  const UndefinedButton(
      this.buttonData,
      this.buttonPanelCubit,{
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double borderRadius = 0.0;

    if (buttonPanelCubit.state.gridTilingSize.width > buttonPanelCubit.state.gridTilingSize.height) {
      borderRadius = (buttonPanelCubit.state.gridTilingSize.height-buttonPanelCubit.state.margin.vertical)*buttonPanelCubit.state.borderRadius;
    } else {
      borderRadius = (buttonPanelCubit.state.gridTilingSize.width-buttonPanelCubit.state.margin.horizontal)*buttonPanelCubit.state.borderRadius;
    }

    return Container(
      margin: buttonPanelCubit.state.margin,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: (buttonPanelCubit.state.nonDefinedButtonDesign.buttonType as DefaultButton).color, width: 3.0),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

}
