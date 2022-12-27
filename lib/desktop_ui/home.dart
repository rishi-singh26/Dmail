import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dmail/desktop_ui/components/emails.dart';
import 'package:dmail/desktop_ui/components/mail_boxes.dart';
import 'package:dmail/models/email_model.dart';
import 'package:dmail/models/mailbox_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDesktopHomePage extends StatefulWidget {
  const MyDesktopHomePage({super.key});

  @override
  State<MyDesktopHomePage> createState() => _MyDesktopHomePageState();
}

class _MyDesktopHomePageState extends State<MyDesktopHomePage> {
  MailBox selectedMailBox = MailBox.initialState();
  List<Email> selectMailBoxEmails = [];
  bool isLoading = false;

  _getEmails() async {
    // print('Getting emails');
    setState(() => isLoading = true);
    GetEmailsResp emailsResponse = await selectedMailBox.getEmails();
    // print(emailsResponse.emails[0].toJson());
    setState(() {
      selectMailBoxEmails = !emailsResponse.status ? [] : emailsResponse.emails;
      isLoading = false;
    });
  }

  setSelectedMailBox(MailBox newMailBox) {
    setState(() {
      selectedMailBox = newMailBox;
    });
    _getEmails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 40),
        child: Container(
          color: Theme.of(context).bottomAppBarColor,
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(CupertinoIcons.mail_solid),
              ),
              const Text('Dmail'),
              Expanded(child: MoveWindow()),
              const WindowButtons(),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          MailBoxes(
            setSelectedMailBox: setSelectedMailBox,
            selectedMailBox: selectedMailBox,
          ),
          Emails(
            selectedMailBox: selectedMailBox,
            selectedMailBoxEmails: selectMailBoxEmails,
            isLoading: isLoading,
          ),
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
