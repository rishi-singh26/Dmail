// import 'package:farmers/redux/auth/reducers.dart';

import 'package:dmail/redux/mailboxes/reducers.dart';

import './app.state.dart';

AppState appReducer(
  AppState state,
  action,
) =>
    AppState(
      mailBox: mailBoxReducers(
        state.mailBox,
        action,
      ),
    );
