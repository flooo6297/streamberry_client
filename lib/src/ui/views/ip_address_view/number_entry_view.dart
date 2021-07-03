import 'package:flutter/material.dart';
import 'package:streamberry_client/src/ui/views/ip_address_view/back_space_entry.dart';
import 'package:streamberry_client/src/ui/views/ip_address_view/number_entry.dart';

class NumberEntryView extends StatelessWidget {

  final Function(String) numberTapped;
  final Function() backSpaceTapped;

  const NumberEntryView(this.numberTapped, this.backSpaceTapped);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NumberEntry('1', (entry) => numberTapped(entry)),
        NumberEntry('2', (entry) => numberTapped(entry)),
        NumberEntry('3', (entry) => numberTapped(entry)),
        NumberEntry('4', (entry) => numberTapped(entry)),
        NumberEntry('5', (entry) => numberTapped(entry)),
        NumberEntry('6', (entry) => numberTapped(entry)),
        NumberEntry('7', (entry) => numberTapped(entry)),
        NumberEntry('8', (entry) => numberTapped(entry)),
        NumberEntry('9', (entry) => numberTapped(entry)),
        NumberEntry('0', (entry) => numberTapped(entry)),
        BackSpaceEntry(() => backSpaceTapped()),
      ],
    );
  }
}
