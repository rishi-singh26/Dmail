import 'package:dmail/desktop_ui/components/email_view.dart';
import 'package:dmail/models/email_model.dart';
import 'package:dmail/models/mailbox_model.dart';
import 'package:flutter/material.dart';

class Emails extends StatefulWidget {
  final MailBox selectedMailBox;
  final List<Email> selectedMailBoxEmails;
  final bool isLoading;
  const Emails({
    Key? key,
    required this.selectedMailBox,
    required this.selectedMailBoxEmails,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<Emails> createState() => _EmailsState();
}

class _EmailsState extends State<Emails> {
  Email selectedEmail = Email.initialState();
  Email completeEmailData = Email.initialState();
  bool isLoading = false;

  getCompleteEmailData(Email selectedMail) async {
    setState(() {
      selectedEmail = selectedMail;
      completeEmailData = Email.initialState();
      isLoading = true;
    });
    GetEmailResp emailRespData = await selectedMail.getEmail(
      widget.selectedMailBox.email,
    );
    setState(() {
      !emailRespData.status ? null : completeEmailData = emailRespData.email;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> attachments = [];
    for (var element in completeEmailData.attachments) {
      attachments.add(Card(
        child: Text(element.fileName),
      ));
    }
    bool isMailBoxSelected = widget.selectedMailBox.email != '';
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          width: 300,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  isMailBoxSelected
                      ? widget.selectedMailBox.email
                      : 'Select a Mailbox to view email',
                ),
                trailing: widget.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          strokeWidth: 2,
                        ),
                      )
                    : const SizedBox(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.selectedMailBoxEmails.length,
                  itemBuilder: ((context, index) {
                    Email currentEmail = widget.selectedMailBoxEmails[index];
                    return ListTile(
                      title: Text(currentEmail.subject),
                      subtitle: Text('From: ${currentEmail.from}'),
                      onTap: () => getCompleteEmailData(currentEmail),
                      // dense: true,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        selectedEmail.id == -1
            ? const SizedBox()
            : DesktopViewEmail(
                selectedEmail: selectedEmail,
                senderEmail: widget.selectedMailBox.email,
                completeEmailData: completeEmailData,
                attachments: attachments,
                isLoading: isLoading,
              ),
      ],
    );
  }
}
