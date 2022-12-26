import 'package:dmail/components/emails.dart';
import 'package:dmail/components/mail_boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(800, 650);
    const minimumSize = Size(600, 450);
    appWindow.minSize = minimumSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = 'Dmail';
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dmail',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF3161FF),
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dmail'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 40),
        child: Container(
          color: Theme.of(context).bottomAppBarColor,
          child: Row(
            children: [
              const IconButton(
                onPressed: null,
                icon: Icon(CupertinoIcons.mail_solid),
              ),
              const Text('Dmail'),
              Expanded(child: MoveWindow()),
              const WindowButtons(),
            ],
          ),
        ),
      ),
      body: Row(
        children: const [
          MailBoxes(),
          Emails(),
        ],
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WindowButtonColors iconColor = WindowButtonColors(
      iconNormal: Theme.of(context).textTheme.bodyLarge?.color,
    );

    WindowButtonColors closeButtonColors = WindowButtonColors(
      iconNormal: Theme.of(context).textTheme.bodyLarge?.color,
      mouseOver: Colors.red,
      mouseDown: Colors.red,
    );
    return Row(
      children: [
        MinimizeWindowButton(colors: iconColor),
        MaximizeWindowButton(colors: iconColor),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
