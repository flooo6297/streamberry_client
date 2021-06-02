import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_client/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_client/src/ui/views/button_view/button_view.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  static ButtonPanelState buttonPanelStateOf(BuildContext context) =>
      buttonPanelCubitOf(context).state;

  static ButtonPanelCubit buttonPanelCubitOf(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>()!.buttonPanelCubit!;

  static Socket socketOf(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>()!.socket;

  static Stream<Uint8List> broadcastOf(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>()!.broadcast;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late Socket socket;
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
        Socket.connect('localhost', 4567, timeout: const Duration(hours: 5));

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
    handleConnection().then((newSocket) {
      socket = newSocket;

      broadcast = socket.asBroadcastStream();
      broadcast.listen((data) {
        final serverMessage = String.fromCharCodes(data);
        print('$serverMessage');
        List<dynamic> serverMessageContentMapList = jsonDecode('[${serverMessage.replaceAll('}{', '},{')}]');

        for (var serverMessageContentMap in serverMessageContentMapList) {
          if (serverMessageContentMap is Map<String, dynamic>) {
            if (serverMessageContentMap.containsKey('panelData')) {
              if (buttonPanelCubit == null) {
                buttonPanelCubit = ButtonPanelCubit(ButtonPanelState.fromJson(
                    serverMessageContentMap['panelData'] as Map<String, dynamic>));
                connection.sink.add(ConnectionState.active);
              } else {
                connection.sink.add(ConnectionState.active);
                buttonPanelCubit!.setState(ButtonPanelState.fromJson(
                    serverMessageContentMap['panelData'] as Map<String, dynamic>));
              }
            }
          }
        }

      }, onError: (error) {
        print(error);
        socket.destroy();
        connection.sink.add(ConnectionState.none);
      }, onDone: () {
        print('Server left.');
        socket.destroy();
        connection.sink.add(ConnectionState.none);
      });
    });
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }
}
