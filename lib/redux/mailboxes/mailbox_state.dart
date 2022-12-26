import 'package:dmail/models/mailbox_model.dart';

class MailBoxState {
  final List<MailBox> mailBox;

  MailBoxState({
    required this.mailBox,
  });
  static List<MailBox> _formArrayStringJsonToList(json) {
    try {
      List<MailBox> list = [];
      for (var item in json) {
        MailBox mail = MailBox.fromJson(item);
        list.add(mail);
      }
      return list;
    } catch (e) {
      // print(
      //   'Error in convertion json to list in farmer modal: ${e.toString()}',
      // );
      return [];
    }
  }

  MailBoxState.fromJson(json)
      : mailBox = _formArrayStringJsonToList(json['subUsers']);

  Map<String, dynamic> toJson() => {
        'mailBox': mailBox,
      };

  MailBoxState.initialState() : mailBox = [];

  MailBoxState.addMailBox(MailBoxState prev, List<MailBox> newMailBox)
      : mailBox = newMailBox;

  MailBoxState.removeMailBox(MailBoxState prev, List<MailBox> newMailBox)
      : mailBox = newMailBox;
}
