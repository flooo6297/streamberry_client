import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:streamberry_client/src/app.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/folder/actions/close_folder_action.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/folder/actions/open_folder_action.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/on_click.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/default_button.dart';
import 'package:streamberry_client/src/ui/views/button_view/button/cached_image.dart';

class DefaultButtonWidget extends StatefulWidget {

  final ButtonPanelCubit buttonPanelCubit;
  final ButtonData buttonData;

  const DefaultButtonWidget(this.buttonPanelCubit, this.buttonData, {Key? key}) : super(key: key);

  @override
  _DefaultButtonWidgetState createState() => _DefaultButtonWidgetState();
}

class _DefaultButtonWidgetState extends State<DefaultButtonWidget> {
  @override
  Widget build(BuildContext context) {
    DefaultButton defaultButton = widget.buttonData.buttonType as DefaultButton;

    double borderRadius = 0.0;

    if (widget.buttonPanelCubit.state.gridTilingSize.width >
        widget.buttonPanelCubit.state.gridTilingSize.height) {
      borderRadius = (widget.buttonPanelCubit.state.gridTilingSize.height -
          widget.buttonPanelCubit.state.margin.vertical) *
          widget.buttonPanelCubit.state.borderRadius;
    } else {
      borderRadius = (widget.buttonPanelCubit.state.gridTilingSize.width -
          widget.buttonPanelCubit.state.margin.horizontal) *
          widget.buttonPanelCubit.state.borderRadius;
    }

    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          height:
          widget.buttonPanelCubit.state.gridTilingSize.height * widget.buttonData.height,
          width: widget.buttonPanelCubit.state.gridTilingSize.width * widget.buttonData.width,
          child: Container(
            margin: widget.buttonPanelCubit.state.margin,
            decoration: BoxDecoration(
              color: defaultButton.color,
              border: Border.all(color: defaultButton.color, width: 3.0),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: InkWell(
              onTap: () {
                List<OnClick> onClicks = List.of(defaultButton.onClicks);
                ButtonFunctions.getActions(widget.buttonData).forEach((buttonAction) {
                  if (buttonAction is OpenFolderAction) {
                    buttonAction.runFolderFunction(
                        widget.buttonPanelCubit, widget.buttonData, context);
                  } else if (buttonAction is CloseFolderAction) {
                    buttonAction.runFolderFunction(
                        widget.buttonPanelCubit, widget.buttonData, context);
                  } else {
                    buttonAction.runFunction(widget.buttonPanelCubit);
                  }
                  onClicks.removeWhere((element) => element
                      .equals(buttonAction.toOnClick(), ignoreParams: true));
                });
                List<Map<String, dynamic>> jsons =
                onClicks.map((e) => e.toJson()).toList();
                App.socketOf(context).emit('runActions', jsonEncode({'actions': jsons}));
              },
              child: CachedImage(defaultButton.image),
            ),
          ),
        ),
        Positioned(
          left: widget.buttonPanelCubit.state.margin.left,
          top: widget.buttonPanelCubit.state.margin.top,
          height:
          widget.buttonPanelCubit.state.gridTilingSize.height * widget.buttonData.height -
              widget.buttonPanelCubit.state.margin.vertical,
          width:
          widget.buttonPanelCubit.state.gridTilingSize.width * widget.buttonData.width -
              widget.buttonPanelCubit.state.margin.horizontal,
          child: Align(
            alignment: defaultButton.textAlignment,
            child: Padding(
              padding: EdgeInsets.all(widget.buttonData.borderWidth),
              child: IgnorePointer(
                ignoring: true,
                child: Text(
                  defaultButton.text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: defaultButton.textSize, color: defaultButton.textColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}