import 'dart:io';
import 'package:dmail/desktop_ui/home.dart';
import 'package:dmail/mobile_ui/home.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

// Redux
import 'package:dmail/redux/combined_store.dart';
import 'package:dmail/redux/store/app.state.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(store: await AppStore.getAppStore()));

  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    doWhenWindowReady(() {
      const initialSize = Size(1200, 650);
      const minimumSize = Size(1150, 450);
      appWindow.minSize = minimumSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.title = 'Dmail';
      appWindow.show();
    });
  }
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  const MyApp({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Dmail',
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: const Color(0xFF3161FF),
        ),
        darkTheme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: Builder(builder: (context) {
          if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
            return const MyDesktopHomePage();
          }
          return const MyMobileUiHomePage();
        }),
      ),
    );
  }
}
