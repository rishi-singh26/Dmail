import 'package:flutter/material.dart';

class MailBoxes extends StatefulWidget {
  const MailBoxes({Key? key}) : super(key: key);

  @override
  State<MailBoxes> createState() => _MailBoxesState();
}

class _MailBoxesState extends State<MailBoxes> {
  @override
  Widget build(BuildContext context) {
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
        children: const [Text('Mail Boxes')],
      ),
    );
  }
}
