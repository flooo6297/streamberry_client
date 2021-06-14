import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_client/src/ui/views/button_view/button_view.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  static ButtonPanelState buttonPanelStateOf(BuildContext context) =>
      buttonPanelCubitOf(context).state;

  static ButtonPanelCubit buttonPanelCubitOf(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>()!.buttonPanelCubit!;

  static IO.Socket socketOf(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>()!.socket;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late IO.Socket socket;
  late Stream<Uint8List> broadcast;

  StreamController<ConnectionState> connection = StreamController();

  ButtonPanelCubit? buttonPanelCubit;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: StreamBuilder<ConnectionState>(
        stream: connection.stream,
        builder: (context, connectionState) {
          if (connectionState.hasData) {
            if (connectionState.data! == ConnectionState.active) {
              return ButtonView(buttonPanelCubit: buttonPanelCubit!);
            } else if (connectionState.data! == ConnectionState.none) {
              return Center(
                child: TextButton(
                  onPressed: () {
                    initialize();
                  },
                  child: const Text('Retry'),
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<Socket> handleConnection() async {
    connection.sink.add(ConnectionState.waiting);

    Future<Socket> newSocketFuture =
        Socket.connect('192.168.2.126', 4567, timeout: const Duration(hours: 5));

    return newSocketFuture.onError((error, stackTrace) {
      print('try reconnect');
      return handleConnection();
    }).then((value) {
      print('connected');
      return value;
    });
  }
  
  
  
  void initialize() {
    buttonPanelCubit = null;
    connection.sink.add(ConnectionState.waiting);
    
    socket = IO.io('http://192.168.2.126:3000', <String, dynamic>{
    'transports': ['websocket']
    });
    socket.onConnect((_) {
      print('connected');
    });
    socket.onError((data) {
      buttonPanelCubit = null;
      connection.sink.add(ConnectionState.waiting);
    });
    socket.onDisconnect((data) {
      buttonPanelCubit = null;
      connection.sink.add(ConnectionState.waiting);
    });
    socket.on('panelData', (data) {

      Map<String, dynamic> contentMap = jsonDecode(data);

      if (buttonPanelCubit == null) {
        buttonPanelCubit = ButtonPanelCubit(ButtonPanelState.fromJson(
            contentMap['state'] as Map<String, dynamic>));
        buttonPanelCubit!.path =
            (contentMap['path'] as List<dynamic>).cast();
        buttonPanelCubit!.state.name = (contentMap['pathNames'] as List<dynamic>).cast().join(' ❯ ');
        connection.sink.add(ConnectionState.active);
      } else {
        connection.sink.add(ConnectionState.active);
        buttonPanelCubit!.setState(ButtonPanelState.fromJson(
            contentMap['state']
            as Map<String, dynamic>));
        buttonPanelCubit!.path =
            (contentMap['path'] as List<dynamic>).cast();
        buttonPanelCubit!.state.name = (contentMap['pathNames'] as List<dynamic>).cast().join(' ❯ ');
      }
    });

    socket.on('updateAvailable', (data) {
      socket.emit('requestState', jsonEncode({'path': (buttonPanelCubit == null ? [] : buttonPanelCubit!.path)}));
    });
    
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }
}
