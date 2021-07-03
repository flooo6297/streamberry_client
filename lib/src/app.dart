import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_client/src/blocs/data_update/data_update_bloc.dart';
import 'package:streamberry_client/src/blocs/ip_address/ip_address_bloc.dart';
import 'package:streamberry_client/src/ui/views/button_view/button_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:streamberry_client/src/ui/views/button_view/pointer_view.dart';
import 'package:streamberry_client/src/ui/views/ip_address_view/ip_address_view.dart';

import 'blocs/ip_address/ip_address.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  static ButtonPanelState buttonPanelStateOf(BuildContext context) =>
      buttonPanelCubitOf(context).state;

  static ButtonPanelCubit buttonPanelCubitOf(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>()!.buttonPanelCubit!;

  static IO.Socket socketOf(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>()!.socket!;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  IO.Socket? socket;

  StreamController<ConnectionState> connection = StreamController.broadcast();
  DataUpdateBloc _dataUpdateBloc = DataUpdateBloc();

  ButtonPanelCubit? buttonPanelCubit;
  late IpAddressBloc ipAddressBloc;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: PointerView(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<IpAddressBloc>(create: (context) => ipAddressBloc),
            BlocProvider<DataUpdateBloc>(
                create: (context) => _dataUpdateBloc),
          ],
          child: BlocBuilder<IpAddressBloc, IpAddress>(
            builder: (context, state) {
              if (!state.hasAddress) {
                return Material(child: IpAddressView());
              }
              if (state.toString() != ipAddressBloc.lastConnectedIp) {
                initialize(state);
              }
              return StreamBuilder<ConnectionState>(
                stream: connection.stream,
                builder: (context, connectionState) {
                  if (connectionState.hasData) {
                    if (connectionState.data! == ConnectionState.active) {
                      return ButtonView(
                          buttonPanelCubit: buttonPanelCubit!);
                    } else if (connectionState.data! ==
                        ConnectionState.none) {
                      return Center(
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                initialize(state);
                              },
                              child: const Text('Retry'),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            TextButton(
                              onPressed: () {
                                ipAddressBloc.invalidate();
                              },
                              child: const Text('change IP-Address'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextButton(
                          onPressed: () {
                            ipAddressBloc.invalidate();
                          },
                          child: const Text('change IP-Address'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void initialize(IpAddress ipAddress) {
    connection = StreamController.broadcast();
    buttonPanelCubit = null;
    connection.sink.add(ConnectionState.waiting);

    bool manualConnect = false;
    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
      socket!.close();
      socket = null;
      manualConnect = true;
    }

    socket = IO.io('http://${ipAddress.toString()}', <String, dynamic>{
      'transports': ['websocket']
    });
    socket!.onConnect((_) {
      ipAddressBloc.lastConnectedIp = ipAddress.toString();
      print('connected');
    });
    socket!.onError((data) {
      buttonPanelCubit = null;
      connection.sink.add(ConnectionState.waiting);
    });
    socket!.onDisconnect((data) {
      buttonPanelCubit = null;
      connection.sink.add(ConnectionState.waiting);
    });
    socket!.on('panelData', (data) {
      Map<String, dynamic> contentMap = jsonDecode(data);

      if (buttonPanelCubit == null) {
        buttonPanelCubit = ButtonPanelCubit(ButtonPanelState.fromJson(
            contentMap['state'] as Map<String, dynamic>));
        buttonPanelCubit!.path = (contentMap['path'] as List<dynamic>).cast();
        buttonPanelCubit!.state.name =
            (contentMap['pathNames'] as List<dynamic>).cast().join(' ❯ ');
        connection.sink.add(ConnectionState.active);
      } else {
        connection.sink.add(ConnectionState.active);
        buttonPanelCubit!.setState(ButtonPanelState.fromJson(
            contentMap['state'] as Map<String, dynamic>));
        buttonPanelCubit!.path = (contentMap['path'] as List<dynamic>).cast();
        buttonPanelCubit!.state.name =
            (contentMap['pathNames'] as List<dynamic>).cast().join(' ❯ ');
      }
      socket!.emit('requestUpdate', '');
    });

    socket!.on('dataUpdate', (data) {
      Map<String, dynamic> content = jsonDecode(data);
      _dataUpdateBloc.newUpdate(
          content.map((key, value) => MapEntry(key, value as String)));
    });

    socket!.on('updateAvailable', (data) {
      socket!.emit(
          'requestState',
          jsonEncode({
            'path': (buttonPanelCubit == null ? [] : buttonPanelCubit!.path)
          }));
    });

    if (manualConnect) {
      socket!.connect();
    }
  }

  @override
  void initState() {
    Box<String> box = Hive.box('ip_address');

    ipAddressBloc =
        IpAddressBloc.fromString(box.get('ip_address', defaultValue: '')!);

    super.initState();
  }
}
