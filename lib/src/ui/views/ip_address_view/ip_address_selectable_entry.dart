import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_client/src/blocs/ip_address/ip_address_bloc.dart';
import 'package:streamberry_client/src/ui/views/ip_address_view/ip_part.dart';

class IpAddressSelectableEntry extends StatefulWidget {

  IpAddressSelectableEntry({required Key? key})
      : super(key: key);

  @override
  IpAddressSelectableEntryState createState() =>
      IpAddressSelectableEntryState();
}

class IpAddressSelectableEntryState extends State<IpAddressSelectableEntry> {
  IpPart _selected = IpPart.PART1;

  GlobalKey<IpPartViewState> _part1Key = GlobalKey();
  GlobalKey<IpPartViewState> _part2Key = GlobalKey();
  GlobalKey<IpPartViewState> _part3Key = GlobalKey();
  GlobalKey<IpPartViewState> _part4Key = GlobalKey();
  GlobalKey<IpPartViewState> _portKey = GlobalKey();

  late IpAddressBloc _ipAddressBloc;

  @override
  Widget build(BuildContext context) {
    _ipAddressBloc = context.read<IpAddressBloc>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IpPartView(
          IpPart.PART1,
          _selected,
          Theme.of(context).backgroundColor,
          Theme.of(context).selectedRowColor,
          (part) => _selectPart(part),
          _part1Key,
        ),
        Text(
          ' . ',
          style: Theme.of(context).textTheme.headline6!,
        ),
        IpPartView(
          IpPart.PART2,
          _selected,
          Theme.of(context).backgroundColor,
          Theme.of(context).selectedRowColor,
          (part) => _selectPart(part),
          _part2Key,
        ),
        Text(
          ' . ',
          style: Theme.of(context).textTheme.headline6!,
        ),
        IpPartView(
          IpPart.PART3,
          _selected,
          Theme.of(context).backgroundColor,
          Theme.of(context).selectedRowColor,
          (part) => _selectPart(part),
          _part3Key,
        ),
        Text(
          ' . ',
          style: Theme.of(context).textTheme.headline6!,
        ),
        IpPartView(
          IpPart.PART4,
          _selected,
          Theme.of(context).backgroundColor,
          Theme.of(context).selectedRowColor,
          (part) => _selectPart(part),
          _part4Key,
        ),
        Text(
          ' : ',
          style: Theme.of(context).textTheme.headline6!,
        ),
        IpPartView(
          IpPart.PORT,
          _selected,
          Theme.of(context).backgroundColor,
          Theme.of(context).selectedRowColor,
          (part) => _selectPart(part),
          _portKey,
        ),
        IconButton(
          onPressed: () {
            if (_part1Key.currentState!.isValid() &&
                _part2Key.currentState!.isValid() &&
                _part3Key.currentState!.isValid() &&
                _part4Key.currentState!.isValid() &&
                _portKey.currentState!.isValid()) {
              _ipAddressBloc.setIpAddress(
                  '${_part1Key.currentState!.content}.${_part2Key.currentState!.content}.${_part3Key.currentState!.content}.${_part4Key.currentState!.content}:${_portKey.currentState!.content}');
            }
          },
          icon: Icon(Icons.check),
          color: Colors.greenAccent,
        ),
      ],
    );
  }

  void _selectPart(IpPart part) {
    setState(() {
      _selected = part;
    });
  }

  void typeNumber(String number) {
    switch (_selected) {
      case IpPart.PART1:
        _part1Key.currentState!.addNumber(number);
        String content = _part1Key.currentState!.content;
        int? ipPartNumber = int.tryParse(content);
        if (ipPartNumber != null && content.length == 3 && ipPartNumber < 256) {
          _selectPart(IpPart.PART2);
        }
        break;
      case IpPart.PART2:
        _part2Key.currentState!.addNumber(number);
        String content = _part2Key.currentState!.content;
        int? ipPartNumber = int.tryParse(content);
        if (ipPartNumber != null && content.length == 3 && ipPartNumber < 256) {
          _selectPart(IpPart.PART3);
        }
        break;
      case IpPart.PART3:
        _part3Key.currentState!.addNumber(number);
        String content = _part3Key.currentState!.content;
        int? ipPartNumber = int.tryParse(content);
        if (ipPartNumber != null && content.length == 3 && ipPartNumber < 256) {
          _selectPart(IpPart.PART4);
        }
        break;
      case IpPart.PART4:
        _part4Key.currentState!.addNumber(number);
        String content = _part4Key.currentState!.content;
        int? ipPartNumber = int.tryParse(content);
        if (ipPartNumber != null && content.length == 3 && ipPartNumber < 256) {
          _selectPart(IpPart.PORT);
        }
        break;
      case IpPart.PORT:
        _portKey.currentState!.addNumber(number);
        String content = _portKey.currentState!.content;
        int? ipPartNumber = int.tryParse(content);
        if (ipPartNumber != null &&
            content.length == 5 &&
            ipPartNumber < 65535) {
          _selectPart(IpPart.NONE);
        }
        break;
      case IpPart.NONE:
        break;
    }
  }

  void backSpace() {
    switch (_selected) {
      case IpPart.PART1:
        String content = _part1Key.currentState!.content;
        _part1Key.currentState!.backSpace();
        break;
      case IpPart.PART2:
        String content = _part2Key.currentState!.content;
        if (content.length == 0) {
          _selectPart(IpPart.PART1);
          break;
        }
        _part2Key.currentState!.backSpace();
        break;
      case IpPart.PART3:
        String content = _part3Key.currentState!.content;
        if (content.length == 0) {
          _selectPart(IpPart.PART2);
          break;
        }
        _part3Key.currentState!.backSpace();
        break;
      case IpPart.PART4:
        String content = _part4Key.currentState!.content;
        if (content.length == 0) {
          _selectPart(IpPart.PART3);
          break;
        }
        _part4Key.currentState!.backSpace();
        break;
      case IpPart.PORT:
        String content = _portKey.currentState!.content;
        if (content.length == 0) {
          _selectPart(IpPart.PART4);
          break;
        }
        _portKey.currentState!.backSpace();
        break;
      case IpPart.NONE:
        break;
    }
  }
}
