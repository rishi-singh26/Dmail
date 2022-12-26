// import 'package:farmers/redux/auth/auth_state.dart';

import 'package:dmail/redux/mailboxes/mailbox_state.dart';

class AppState {
  final MailBoxState mailBox;

  AppState({required this.mailBox});

  factory AppState.initial() => AppState(
        mailBox: MailBoxState.initialState(),
      );

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is AppState && runtimeType == other.runtimeType;

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return 'AppState:{\n\tmailBox: $mailBox\n}';
  }

  static AppState fromJson(dynamic json) {
    return AppState(
      mailBox: json == null
          ? MailBoxState.initialState()
          : MailBoxState.fromJson(json['mailBox']),
    );
  }

  // AppState.fromJson(json)
  //     : user = UserState.fromJson(json['user']);

  Map<String, dynamic> toJson() => {
        'mailBox': mailBox.toJson(),
      };
}
