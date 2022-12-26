import 'package:flutter/material.dart';

class Emails extends StatefulWidget {
  const Emails({Key? key}) : super(key: key);

  @override
  State<Emails> createState() => _EmailsState();
}

class _EmailsState extends State<Emails> {
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
      width: 300,
      child: Column(
        children: const [Text('email@email.com')],
      ),
    );
  }
}
