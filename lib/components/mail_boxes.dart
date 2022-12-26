import 'package:dmail/models/mailbox_model.dart';
import 'package:dmail/redux/mailboxes/mailbox_action.dart';
import 'package:dmail/redux/store/app.state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MailBoxes extends StatefulWidget {
  const MailBoxes({Key? key}) : super(key: key);

  @override
  State<MailBoxes> createState() => _MailBoxesState();
}

class _MailBoxesState extends State<MailBoxes> {
  final TextEditingController addMailBoxController = TextEditingController();

  @override
  void initState() {
    addMailBoxController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    addMailBoxController.dispose();
    super.dispose();
  }

  _addEmail() {
    String email = 'khankumar@1secmail.com';
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
                    return ListTile(
                      title: Text(mailBox.email),
                      dense: true,
                      onTap: (() {}),
                      trailing: IconButton(
                        onPressed: () {
                          StoreProvider.of<AppState>(context).dispatch(
                            RemoveMailBoxAction(index: index),
                          );
                        },
                        icon: const Icon(CupertinoIcons.trash, size: 15),
                      ),
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
