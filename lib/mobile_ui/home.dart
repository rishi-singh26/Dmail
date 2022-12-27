import 'dart:convert';

import 'package:dmail/mobile_ui/pages/emails.dart';
import 'package:dmail/models/mailbox_model.dart';
import 'package:dmail/redux/mailboxes/mailbox_action.dart';
import 'package:dmail/redux/store/app.state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';

class MyMobileUiHomePage extends StatefulWidget {
  const MyMobileUiHomePage({Key? key}) : super(key: key);

  @override
  State<MyMobileUiHomePage> createState() => _MyMobileUiHomePageState();
}

class _MyMobileUiHomePageState extends State<MyMobileUiHomePage> {
  _addEmail() async {
    // https://www.1secmail.com/api/v1/?action=genRandomMailbox&count=10
    var httpsUri = Uri(
      scheme: 'https',
      host: 'www.1secmail.com',
      path: '/api/v1/',
      queryParameters: {
        'action': 'genRandomMailbox',
        'count': '1',
      },
    );
    String email = '';
    Response res = await get(httpsUri);
    if (res.statusCode == 200) {
      List<dynamic> emailData = jsonDecode(res.body);
      email = emailData[0];
    } else {
      return;
    }
    // ignore: use_build_context_synchronously
    StoreProvider.of<AppState>(context).dispatch(
      AddMailBoxAction(
        newMailBox: MailBox(
          addedOn: DateTime.now().toString(),
          email: email,
          lastRefreshOn: DateTime.now().toString(),
          name: email.split('@')[0],
        ),
      ),
    );
  }

  _deleteMail(int mailBoxLength, int index) {
    StoreProvider.of<AppState>(context).dispatch(
      RemoveMailBoxAction(index: index),
    );
  }

  viewEmails(MailBox selectedMailBox, BuildContext context) async {
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        // fullscreenDialog: true,
        builder: (context) => MobileEmailsList(
          selectedMailBox: selectedMailBox,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dmail'),
        // leading: const Icon(CupertinoIcons.mail_solid),
        actions: [
          IconButton(
            onPressed: _addEmail,
            icon: const Icon(CupertinoIcons.add),
          ),
        ],
      ),
      body: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: state.mailBox.mailBox.length,
            itemBuilder: (context, index) {
              MailBox mailBox = state.mailBox.mailBox[index];
              return ListTile(
                title: Text(mailBox.email),
                onTap: (() => viewEmails(mailBox, context)),
                trailing: IconButton(
                  onPressed: () => _deleteMail(
                    state.mailBox.mailBox.length,
                    index,
                  ),
                  icon: const Icon(CupertinoIcons.trash, size: 15),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
