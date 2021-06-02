import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/ui/views/button_view/button/defined_button.dart';
import 'package:streamberry_client/src/ui/views/button_view/button/undefined_button.dart';

class Button extends StatelessWidget {
  final ButtonData buttonData;
  final ButtonPanelCubit buttonPanelCubit;

  const Button(
    this.buttonData,
    this.buttonPanelCubit, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (buttonData.canBeOverwritten) {
      return UndefinedButton(buttonData, buttonPanelCubit.state, context.read<ButtonPanelCubit>().getState().nonDefinedButtonDesign);
    }
    return DefinedButton(buttonData, buttonPanelCubit);
  }
}
