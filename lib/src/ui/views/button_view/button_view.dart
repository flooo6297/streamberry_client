import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_client/src/ui/views/button_view/button/button.dart';

class ButtonView extends StatefulWidget {
  final ButtonPanelCubit buttonPanelCubit;

  // ignore: prefer_const_constructors_in_immutables
  ButtonView({Key? key, required this.buttonPanelCubit}) : super(key: key);

  @override
  _ButtonViewState createState() => _ButtonViewState();
}

class _ButtonViewState extends State<ButtonView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.0,
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: BlocProvider(
          create: (context) => widget.buttonPanelCubit,
          child: BlocBuilder<ButtonPanelCubit, ButtonPanelState>(
            builder: (context, topPanelState) {
              ButtonPanelState panelState =
                  context.read<ButtonPanelCubit>().getState();
              return Container(
                color: panelState.backgroundColor,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height:
                    panelState.ySize * panelState.gridTilingSize.height,
                    width: panelState.xSize * panelState.gridTilingSize.width,
                    child: Stack(
                      children: [
                        ...(panelState.panelList
                            .map((buttonData) =>
                            Button(buttonData, widget.buttonPanelCubit))
                            .toList()),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
