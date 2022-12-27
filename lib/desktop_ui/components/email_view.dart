import 'package:dmail/models/email_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DesktopViewEmail extends StatelessWidget {
  const DesktopViewEmail({
    Key? key,
    required this.selectedEmail,
    required this.senderEmail,
    required this.completeEmailData,
    required this.attachments,
    required this.isLoading,
  }) : super(key: key);

  final Email selectedEmail;
  final String senderEmail;
  final Email completeEmailData;
  final List<Widget> attachments;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                selectedEmail.subject,
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'From: ',
                    style: TextStyle(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  SelectableText(selectedEmail.from),
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
                  SelectableText(senderEmail),
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
                  Text(selectedEmail.date),
                ],
              ),
              const SizedBox(height: 12),
              if (isLoading)
                CircularProgressIndicator(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                )
              else if (completeEmailData.htmlBody.isEmpty)
                SelectableText(completeEmailData.body)
              else
                SelectableHtml(data: completeEmailData.body),
              const SizedBox(height: 12),
              Row(children: attachments),
            ],
          ),
        ],
      ),
    );
  }
}
