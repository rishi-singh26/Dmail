import 'dart:convert';
import 'package:dmail/models/email_model.dart';
import 'package:http/http.dart';

class MailBox {
  final String email;
  final String addedOn;
  final String lastRefreshOn;
  final String name;

  MailBox({
    required this.addedOn,
    required this.email,
    required this.lastRefreshOn,
    required this.name,
  });

  MailBox.initialState()
      : addedOn = '',
        email = '',
        lastRefreshOn = '',
        name = '';

  MailBox.fromJson(Map<String, dynamic> json)
      : email = json.containsKey('email') ? json['email'] : '',
        addedOn = json.containsKey('addedOn') ? json['addedOn'] : '',
        lastRefreshOn =
            json.containsKey('lastRefreshOn') ? json['lastRefreshOn'] : '',
        name = json.containsKey('name') ? json['name'] : '';

  Map<String, dynamic> toJson() => {
        'email': email,
        'addedOn': addedOn,
        'lastRefreshOn': lastRefreshOn,
        'name': name,
      };

  Future<GetEmailsResp> getEmails() async {
    try {
      if (email == '') {
        return GetEmailsResp(
          emails: [],
          message: 'Email is empty',
          status: false,
        );
      }
      List<String> emailComponents = email.split('@');
      if (emailComponents.length < 2) {
        return GetEmailsResp(
          emails: [],
          message: 'Error in getting email components',
          status: false,
        );
      }
      String userName = emailComponents[0];
      String domian = emailComponents[1];
      // String url =
      //     'https://www.1secmail.com/api/v1/?action=getMessages&login=$userName&domain=$domian';
      var httpsUri = Uri(
        scheme: 'https',
        host: 'www.1secmail.com',
        path: '/api/v1/',
        queryParameters: {
          'action': 'getMessages',
          'login': userName,
          'domain': domian,
        },
      );
      Response res = await get(httpsUri);
      if (res.statusCode == 200) {
        List<dynamic> body = jsonDecode(res.body);
        List<Email> emails =
            body.map((dynamic item) => Email.fromJson(item)).toList();
        return GetEmailsResp(
          emails: emails,
          message: 'Success',
          status: true,
        );
      } else {
        return GetEmailsResp(
          emails: [],
          message: 'Response code is not 200',
          status: false,
        );
      }
    } catch (e) {
      return GetEmailsResp(
        emails: [],
        message: e.toString(),
        status: false,
      );
    }
  }
}

class GetEmailsResp {
  final bool status;
  final String message;
  final List<Email> emails;

  GetEmailsResp({
    required this.emails,
    required this.message,
    required this.status,
  });
}
