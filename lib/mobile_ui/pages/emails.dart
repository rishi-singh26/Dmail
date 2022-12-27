import 'package:dmail/mobile_ui/components/loading_indicator.dart';
import 'package:dmail/mobile_ui/pages/view_email.dart';
import 'package:dmail/models/email_model.dart';
import 'package:dmail/models/mailbox_model.dart';
import 'package:flutter/material.dart';

class MobileEmailsList extends StatefulWidget {
  final MailBox selectedMailBox;
  const MobileEmailsList({
    Key? key,
    required this.selectedMailBox,
  }) : super(key: key);

  @override
  State<MobileEmailsList> createState() => _MobileEmailsListState();
}

class _MobileEmailsListState extends State<MobileEmailsList> {
  List<Email> emailsList = [];
  Email selectedEmail = Email.initialState();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getEmails(widget.selectedMailBox);
  }

  _getEmails(MailBox selectedMailBox) async {
    // print('Getting emails');
    setState(() => isLoading = true);
    GetEmailsResp emailsResponse = await selectedMailBox.getEmails();
    // print(emailsResponse.message);
    setState(() {
      emailsList = !emailsResponse.status ? [] : emailsResponse.emails;
      isLoading = false;
    });
  }

  navigateToViewEmail(Email selectedEmail, BuildContext context) async {
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        // fullscreenDialog: true,
        builder: (context) => MobileEmailView(
          selectedEmail: selectedEmail,
          selectedMailBox: widget.selectedMailBox,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.selectedMailBox.toJson());
    bool isMailBoxSelected = widget.selectedMailBox.email != '';
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              isMailBoxSelected
                  ? widget.selectedMailBox.email
                  : 'Select a Mailbox to view email',
            ),
          ),
          body: ListView.builder(
            itemCount: emailsList.length,
            itemBuilder: ((context, index) {
              Email currentEmail = emailsList[index];
              return ListTile(
                title: Text(currentEmail.subject),
                subtitle: Text('From: ${currentEmail.from}'),
                onTap: () => navigateToViewEmail(currentEmail, context),
              );
            }),
          ),
        ),
        isLoading ? const LoadingIndicator() : const SizedBox()
      ],
    );
  }
}
