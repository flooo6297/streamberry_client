import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:streamberry_client/src/blocs/ip_address/ip_address.dart';

class IpAddressBloc extends Cubit<IpAddress> {
  IpAddressBloc(IpAddress ipAddress) : super(ipAddress);
  factory IpAddressBloc.fromString(String ipAddress) => IpAddressBloc(IpAddress.fromString(ipAddress));


  String lastConnectedIp = '';


  invalidate() {
    lastConnectedIp = '';
    emit(IpAddress.fromString(state.toString())..hasAddress = false);
  }

  void setIpAddress(String ipAddress) {
    emit(IpAddress.fromString(ipAddress));
    Box<String> box = Hive.box('ip_address');
    box.put('ip_address', state.toString());
  }

}
