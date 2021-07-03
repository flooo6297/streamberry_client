import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:streamberry_client/src/app.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/ui/views/button_view/button/cached_image.dart';
import 'package:streamberry_client/src/ui/views/button_view/button/undefined_button.dart';

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

    return buttonData.buttonType.buildButton(buttonPanelCubit, buttonData);

  }
}
