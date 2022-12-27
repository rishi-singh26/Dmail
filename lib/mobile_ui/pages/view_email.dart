import 'package:dmail/mobile_ui/components/loading_indicator.dart';
import 'package:dmail/models/email_model.dart';
import 'package:dmail/models/mailbox_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class MobileEmailView extends StatefulWidget {
  final MailBox selectedMailBox;
  final Email selectedEmail;
  const MobileEmailView({
    Key? key,
    required this.selectedEmail,
    required this.selectedMailBox,
  }) : super(key: key);

  @override
  State<MobileEmailView> createState() => MobileEmailViewState();
}

class MobileEmailViewState extends State<MobileEmailView> {
  Email completeEmailData = Email.initialState();
  bool isLoading = true;

  _getEmail() async {
    // print('Getting email');
    setState(() => isLoading = true);
    GetEmailResp emailRespData = await widget.selectedEmail.getEmail(
      widget.selectedMailBox.email,
    );
    // print(emailRespData.message);
    setState(() {
      !emailRespData.status ? null : completeEmailData = emailRespData.email;
      isLoading = false;
    });
  }

  @override
  void initState() {
    _getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> attachments = [];
    for (var element in completeEmailData.attachments) {
      attachments.add(Card(
        child: Text(element.fileName),
      ));
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(widget.selectedEmail.subject),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Text(
                      'From: ',
                      style: TextStyle(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    SelectableText(
                      widget.selectedEmail.from,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'To: ',
                      style: TextStyle(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    SelectableText(
                      widget.selectedMailBox.email,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Date: ',
                      style: TextStyle(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    Text(
                      widget.selectedEmail.date,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: completeEmailData.htmlBody.isEmpty
                      ? SelectableText(completeEmailData.body)
                      : SelectableHtml(data: completeEmailData.body),
                ),
                Row(children: attachments),
              ],
            ),
          ),
        ),
        isLoading ? const LoadingIndicator() : const SizedBox()
      ],
    );
  }
}
