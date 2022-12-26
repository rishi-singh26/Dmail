import 'package:dmail/models/mailbox_model.dart';

abstract class MailBoxAction {}

class AddMailBoxAction extends MailBoxAction {
  final MailBox newMailBox;
  AddMailBoxAction({required this.newMailBox});
}

class RemoveMailBoxAction extends MailBoxAction {
  final int index;
  RemoveMailBoxAction({required this.index});
}
