import 'dart:math';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_functions/on_click.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_client/src/json_converters/color_serializer.dart';

part 'button_data.g.dart';

@JsonSerializable()
class ButtonData {
  @ColorSerializer()
  late Color color;

  late int height;
  late int width;
  late int positionX;
  late int positionY;

  List<OnClick> onClicks = [];
  late bool enabled;

  @JsonKey(defaultValue: null)
  ButtonPanelState? childState;

  String image;

  get canBeOverwritten => (!enabled && onClicks.isEmpty);

  void delete() {
    enabled = false;
    onClicks.clear();
  }

  ButtonData(
    this.positionX,
    this.positionY, {
    this.color = Colors.white24,
    this.height = 1,
    this.width = 1,
    List<OnClick> onClicks = const [],
    this.enabled = true,
    this.childState,
    this.image = '',
  })  : assert(height > 0),
        assert(width > 0) {
    this.onClicks.addAll(onClicks);
  }

  bool equals(ButtonData buttonData) {
    bool actionListsAreSame = true;
    if (onClicks.length != buttonData.onClicks.length) {
      actionListsAreSame = false;
    } else {
      for (int i = 0; i < onClicks.length; i++) {
        if (!onClicks[i].equals(buttonData.onClicks[i])) {
          actionListsAreSame = false;
        }
      }
    }

    return positionY == buttonData.positionY &&
        positionX == buttonData.positionX &&
        color == buttonData.color &&
        height == buttonData.height &&
        width == buttonData.width &&
        actionListsAreSame &&
        enabled == buttonData.enabled &&
        image == buttonData.image;
  }

  factory ButtonData.fromJson(Map<String, dynamic> json) =>
      _$ButtonDataFromJson(json);

  Map<String, dynamic> toJson() => _$ButtonDataToJson(this);
}
