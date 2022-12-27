import 'dart:convert';

import 'package:dmail/models/mailbox_model.dart';
import 'package:dmail/redux/mailboxes/mailbox_action.dart';
import 'package:dmail/redux/store/app.state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';

class MailBoxes extends StatefulWidget {
  final Function(MailBox) setSelectedMailBox;
  final MailBox selectedMailBox;
  const MailBoxes({
    Key? key,
    required this.setSelectedMailBox,
    required this.selectedMailBox,
  }) : super(key: key);

  @override
  State<MailBoxes> createState() => _MailBoxesState();
}

class _MailBoxesState extends State<MailBoxes> {
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

  _deleteMail(int mailBoxLength, bool isSelected, int index) {
    if (mailBoxLength == 1 || isSelected) {
      widget.setSelectedMailBox(MailBox.initialState());
    }
    StoreProvider.of<AppState>(context).dispatch(
      RemoveMailBoxAction(index: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          width: 250,
          child: Column(
            children: [
              // HEADER
              ListTile(
                title: const Text('Mail Boxes'),
                trailing: IconButton(
                  onPressed: _addEmail,
                  icon: const Icon(CupertinoIcons.add, size: 15),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: state.mailBox.mailBox.length,
                  itemBuilder: (context, index) {
                    MailBox mailBox = state.mailBox.mailBox[index];
                    bool isSelected =
                        widget.selectedMailBox.email == mailBox.email;
                    return ListTile(
                      title: Text(mailBox.email),
                      dense: true,
                      onTap: (() {
                        widget.setSelectedMailBox(mailBox);
                      }),
                      selected: isSelected,
                      trailing: isSelected
                          ? IconButton(
                              onPressed: () => _deleteMail(
                                state.mailBox.mailBox.length,
                                isSelected,
                                index,
                              ),
                              icon: const Icon(CupertinoIcons.trash, size: 15),
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
