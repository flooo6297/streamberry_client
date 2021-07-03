import 'package:flutter/material.dart';
import 'package:streamberry_client/src/blocs/ip_address/ip_address_bloc.dart';
import 'package:streamberry_client/src/ui/views/ip_address_view/ip_address_selectable_entry.dart';
import 'package:streamberry_client/src/ui/views/ip_address_view/ip_part.dart';
import 'package:streamberry_client/src/ui/views/ip_address_view/number_entry_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IpAddressView extends StatefulWidget {

  IpAddressView({Key? key}) : super(key: key);

  @override
  _IpAddressViewState createState() => _IpAddressViewState();
}

class _IpAddressViewState extends State<IpAddressView> {
  GlobalKey<IpAddressSelectableEntryState> ipAddressKey = GlobalKey();

  late IpAddressBloc _ipAddressBloc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IpAddressSelectableEntry(key: ipAddressKey),
          SizedBox(height: 8.0,),
          NumberEntryView(
            (number) => ipAddressKey.currentState!.typeNumber(number),
            () => ipAddressKey.currentState!.backSpace(),
          ),
        ],
      ),
    );
  }
}
