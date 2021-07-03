import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_client/src/blocs/ip_address/ip_address_bloc.dart';

class IpPartView extends StatefulWidget {
  final IpPart part;
  final IpPart selected;
  final Function(IpPart) onSelect;
  final Color selectedColor;
  final Color backgroundColor;

  const IpPartView(this.part, this.selected,
      this.backgroundColor, this.selectedColor, this.onSelect, Key key)
      : super(key: key);

  @override
  IpPartViewState createState() => IpPartViewState();
}

class IpPartViewState extends State<IpPartView>
    with SingleTickerProviderStateMixin {
  late bool _edited;

  late String _content;

  String get content => _content;

  late AnimationController _animationController;
  late Animation<Color?> _backgroundColorAnimation;

  void backSpace() {
    setState(() {
      _edited = true;
      _content = _content.substring(
          0, (_content.length - 1 < 0 ? 0 : _content.length - 1));
    });
  }

  void addNumber(String number) {
    setState(() {
      if (!_edited) {
        _content = '';
      }
      if (widget.part == IpPart.PORT) {
        if (_content.length + 1 <= 5) {
          _content += number;
        }
      } else {
        if (_content.length + 1 <= 3) {
          _content += number;
        }
      }
      _edited = true;
    });
  }

  @override
  void initState() {
    IpAddressBloc _ipAddressBloc = context.read<IpAddressBloc>();
    switch (widget.part) {

      case IpPart.PART1:
        _content = _ipAddressBloc.state.part1;
        break;
      case IpPart.PART2:
        _content = _ipAddressBloc.state.part2;
        break;
      case IpPart.PART3:
        _content = _ipAddressBloc.state.part3;
        break;
      case IpPart.PART4:
        _content = _ipAddressBloc.state.part4;
        break;
      case IpPart.PORT:
        _content = _ipAddressBloc.state.port;
        break;
      case IpPart.NONE:
        _content = '';
        break;
    }
    _edited = false;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _backgroundColorAnimation =
        ColorTween(begin: widget.selectedColor, end: widget.backgroundColor)
            .animate(
      CurveTween(curve: Curves.fastOutSlowIn).animate(_animationController),
    );
    _prepareAnimation();
    super.initState();
  }

  @override
  void didUpdateWidget(IpPartView oldWidget) {
    _prepareAnimation();
    super.didUpdateWidget(oldWidget);
  }

  void _prepareAnimation() {
    if (widget.part == widget.selected) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundColorAnimation,
      builder: (context, child) {
        return Material(
          borderRadius: BorderRadius.circular(8.0),
          elevation: 4.0,
          color: _backgroundColorAnimation.value,
          child: child,
        );
      },
      child: SizedBox(
        width: 60,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () => widget.onSelect(widget.part),
          child: Center(
            child: Text(
              _content,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: _getTextColor(context),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getTextColor(BuildContext context) {
    if (!_edited) {
      if (widget.selected == widget.part) {
        return Colors.grey;
      }
      return Theme.of(context).highlightColor;
    }
    if (_content.length > 0) {
      if (widget.part == IpPart.PORT) {
        if (int.parse(_content) > 65535) {
          return Colors.red;
        }
      } else {
        if (int.parse(_content) > 255) {
          return Colors.red;
        }
      }
    }
    return Colors.blue;
  }

  bool isValid() {
    if (_content.length <= 0) {
      return false;
    }
    if (_content.length > 0) {
      if (widget.part == IpPart.PORT) {
        if (int.parse(_content) > 65535) {
          return false;
        }
      } else {
        if (int.parse(_content) > 255) {
          return false;
        }
      }
    }
    return true;
  }

}

enum IpPart { PART1, PART2, PART3, PART4, PORT, NONE }
