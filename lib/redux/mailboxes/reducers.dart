import 'package:dmail/models/mailbox_model.dart';
import 'package:dmail/redux/mailboxes/mailbox_action.dart';
import 'package:dmail/redux/mailboxes/mailbox_state.dart';
import 'package:redux/redux.dart';

Reducer<MailBoxState> mailBoxReducers = combineReducers([
  addMailBoxReducer,
  removeMailBoxReducer,
]);

// Add Mail Box
MailBoxState addMailBoxReducer(MailBoxState prevState, dynamic action) {
  if (action is AddMailBoxAction) {
    // print('Login or signup action ${action.newUser.fullName}');
    List<MailBox> newMailBox = prevState.mailBox;
    newMailBox.add(action.newMailBox);
    return MailBoxState.addMailBox(prevState, newMailBox);
  }
  return prevState;
}

// Remove Mail Box
MailBoxState removeMailBoxReducer(MailBoxState prevState, dynamic action) {
  if (action is RemoveMailBoxAction) {
    List<MailBox> newMailBox = prevState.mailBox;
    newMailBox.removeAt(action.index);
    return MailBoxState.removeMailBox(prevState, newMailBox);
  }
  return prevState;
}
