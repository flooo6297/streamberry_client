import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_client/src/app.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/blocs/button_panel/slider_button/slider_button.dart';
import 'package:streamberry_client/src/blocs/data_update/data_update_bloc.dart';

class SliderButtonWidget extends StatelessWidget {
  final ButtonPanelCubit buttonPanelCubit;
  final ButtonData buttonData;

  const SliderButtonWidget(this.buttonPanelCubit, this.buttonData, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SliderButton sliderButton = buttonData.buttonType as SliderButton;

    double borderRadius = 0.0;

    if (buttonPanelCubit.getState().gridTilingSize.width >
        buttonPanelCubit.getState().gridTilingSize.height) {
      borderRadius = (buttonPanelCubit.getState().gridTilingSize.height -
          buttonPanelCubit.getState().margin.vertical) *
          buttonPanelCubit.getState().borderRadius;
    } else {
      borderRadius = (buttonPanelCubit.getState().gridTilingSize.width -
          buttonPanelCubit.getState().margin.horizontal) *
          buttonPanelCubit.getState().borderRadius;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: buttonPanelCubit.getState().margin,
            decoration: BoxDecoration(
              color: sliderButton.backgroundColor,
              border: Border.all(
                  color: sliderButton.backgroundColor, width: buttonData.borderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius-buttonData.borderWidth/2),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerDown: (pointerDownEvent) {
                        Offset position = pointerDownEvent.localPosition;
                        double value = 0;
                        if (sliderButton.axis == Axis.vertical) {
                          value = (constraints.biggest.height - position.dy)/constraints.biggest.height;
                        }
                        List<Map<String, dynamic>> jsons =
                        [sliderButton.onClick..params['set-volume'] = '$value'].map((e) => e.toJson()).toList();
                        App.socketOf(context).emit('runActions', jsonEncode({'actions': jsons}));
                      },
                      onPointerMove: (pointerMoveEvent) {
                        Offset position = pointerMoveEvent.localPosition;
                        double value = 0;
                        if (sliderButton.axis == Axis.vertical) {
                          value = (constraints.biggest.height - position.dy)/constraints.biggest.height;
                        }
                        List<Map<String, dynamic>> jsons =
                        [sliderButton.onClick..params['set-volume'] = '$value'].map((e) => e.toJson()).toList();
                        App.socketOf(context).emit('runActions', jsonEncode({'actions': jsons}));
                      },
                      child: Container(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        child: BlocBuilder<DataUpdateBloc, Map<String, String>>(
                          builder: (context, state) {

                            double distance = (sliderButton.axis == Axis.vertical
                                    ? constraints.biggest.height
                                    : constraints.biggest.width) *
                                double.parse(state['volume'] ?? '0.5');

                            if (sliderButton.axis == Axis.vertical) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    color: Colors.greenAccent,
                                    height: distance,
                                  ),
                                ],
                              );
                            } else {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    color: Colors.greenAccent,
                                    width: distance,
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
