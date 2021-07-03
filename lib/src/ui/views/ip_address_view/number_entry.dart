import 'package:flutter/material.dart';

class NumberEntry extends StatelessWidget {

  final Function(String) onTap;

  final String entry;

  const NumberEntry(this.entry, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 4.0,
        color: Theme.of(context).cardColor,
        child: Container(
          height: 32,
          width: 32,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onTap(entry),
            child: Center(
              child: Text(
                entry
              ),
            ),
          ),
        ),
      ),
    );
  }
}
