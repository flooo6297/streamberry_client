import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/json_converters/color_serializer.dart';
import 'package:streamberry_client/src/json_converters/edge_insets_serializer.dart';
import 'package:streamberry_client/src/json_converters/size_serializer.dart';

part 'button_panel_state.g.dart';

@JsonSerializable()
class ButtonPanelState {
  late List<ButtonData> panelList;

  late ButtonData nonDefinedButtonDesign;

  String name = 'Folder';

  @SizeSerializer()
  late Size gridTilingSize;

  @ColorSerializer()
  late Color backgroundColor;

  @EdgeInsetsSerializer()
  late EdgeInsets margin;

  late double borderRadius;

  late int xSize;
  late int ySize;

  ButtonPanelState(this.xSize, this.ySize, this.gridTilingSize,
      this.backgroundColor, this.margin, this.name, this.borderRadius) {
    panelList = [];

    nonDefinedButtonDesign = ButtonData(0, 0);

    for (int i = 0; i < xSize; i++) {
      for (int j = 0; j < ySize; j++) {
        panelList.add(ButtonData(i, j, enabled: false));
      }
    }
  }

  ButtonPanelState.copy(ButtonPanelState stateToCopy) {
    gridTilingSize = stateToCopy.gridTilingSize;
    xSize = stateToCopy.xSize;
    ySize = stateToCopy.ySize;
    panelList = List<ButtonData>.of(stateToCopy.panelList);
    backgroundColor = stateToCopy.backgroundColor;
    margin = stateToCopy.margin;
    nonDefinedButtonDesign = stateToCopy.nonDefinedButtonDesign;
    name = stateToCopy.name;
    borderRadius = stateToCopy.borderRadius;
  }

  ButtonData? getButtonDataById(String id) {
    Iterable<ButtonData> buttons = panelList.where((element) => element.id == id);
    if (buttons.isEmpty) {
      return null;
    }
    return buttons.first;
  }

  factory ButtonPanelState.fromJson(Map<String, dynamic> json) =>
      _$ButtonPanelStateFromJson(json);

  Map<String, dynamic> toJson() => _$ButtonPanelStateToJson(this);
}
