import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_type.dart';
import 'package:streamberry_client/src/blocs/button_panel/default_button/button_functions/on_click.dart';
import 'package:streamberry_client/src/blocs/button_panel/slider_button/slider_button_widget.dart';
import 'package:streamberry_client/src/json_converters/axis_serializer.dart';
import 'package:streamberry_client/src/json_converters/color_serializer.dart';

part 'slider_button.g.dart';

@JsonSerializable()
class SliderButton extends ButtonType {


  @AxisSerializer()
  Axis axis = Axis.vertical;

  @ColorSerializer()
  Color backgroundColor = Colors.white24;

  @ColorSerializer()
  Color foregroundColor = Colors.greenAccent;

  OnClick onClick = OnClick('','');

  SliderButton({this.axis = Axis.vertical});


  @override
  Widget buildButton(ButtonPanelCubit buttonPanelCubit, ButtonData buttonData) {
    return SliderButtonWidget(buttonPanelCubit, buttonData);
  }

  @override
  bool get canBeOverwritten => false;

  @override
  void delete() {

  }

  factory SliderButton.fromJson(Map<String, dynamic> json) =>
      _$SliderButtonFromJson(json);

  @override
  Map<String, dynamic> toJson()  => _$SliderButtonToJson(this);

  @override
  String get type => 'sliderButton';

}