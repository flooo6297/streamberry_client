import 'package:flutter/material.dart';

class BackSpaceEntry extends StatelessWidget {

  final Function() onTap;

  const BackSpaceEntry(this.onTap);

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
            onTap: () => onTap(),
            child: Center(
              child: Icon(Icons.backspace_outlined, size: 16.0,),
            ),
          ),
        ),
      ),
    );
  }
}
