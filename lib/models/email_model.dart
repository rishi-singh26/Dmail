import 'dart:convert';
import 'package:http/http.dart';

class Email {
  final int id;
  final String from;
  final String subject;
  final String date;
  final List<Attachment> attachments;
  final String body;
  final String textBody;
  final String htmlBody;

  Email({
    required this.attachments,
    required this.body,
    required this.date,
    required this.from,
    required this.htmlBody,
    required this.id,
    required this.subject,
    required this.textBody,
  });

  Email.initialState()
      : attachments = [],
        body = '',
        date = '',
        from = '',
        htmlBody = '',
        id = -1,
        subject = '',
        textBody = '';

  static List<Attachment> _formArrayStringJsonToList(json) {
    try {
      List<Attachment> list = [];
      for (var item in json) {
        Attachment attachment = Attachment.fromJson(item);
        list.add(attachment);
      }
      return list;
    } catch (e) {
      // print(
      //   'Error in convertion json to list in farmer modal: ${e.toString()}',
      // );
      return [];
    }
  }

  Email.fromJson(Map<String, dynamic> json)
      : attachments = json.containsKey('attachments')
            ? _formArrayStringJsonToList(json['attachments'])
            : [],
        body = json.containsKey('body') ? json['body'] : '',
        date = json.containsKey('date') ? json['date'] : '',
        from = json.containsKey('from') ? json['from'] : '',
        htmlBody = json.containsKey('htmlBody') ? json['htmlBody'] : '',
        id = json.containsKey('id') ? json['id'] : -1,
        subject = json.containsKey('subject') ? json['subject'] : '',
        textBody = json.containsKey('textBody') ? json['textBody'] : '';

  Map<String, dynamic> toJson() => {
        'attachments': attachments,
        'body': body,
        'date': date,
        'from': from,
        'htmlBody': htmlBody,
        'id': id,
        'subject': subject,
        'textBody': textBody,
      };

  Future<GetEmailResp> getEmail(String reciverEmail) async {
    try {
      if (id == -1) {
        return GetEmailResp(
          email: Email.initialState(),
          message: 'Email id not available',
          status: false,
        );
      }
      List<String> emailComponents = reciverEmail.split('@');
      if (emailComponents.length < 2) {
        return GetEmailResp(
          email: Email.initialState(),
          message: 'Error in getting email components',
          status: false,
        );
      }
      String userName = emailComponents[0];
      String domian = emailComponents[1];
      // String url =
      //     'https://www.1secmail.com/api/v1/?action=readMessage&login=demo&domain=1secmail.com&id=639';
      var httpsUri = Uri(
        scheme: 'https',
        host: 'www.1secmail.com',
        path: '/api/v1/',
        queryParameters: {
          'action': 'readMessage',
          'login': userName,
          'domain': domian,
          'id': id.toString(),
        },
      );
      Response res = await get(httpsUri);
      if (res.statusCode == 200) {
        dynamic email = jsonDecode(res.body);
        Email emailData = Email.fromJson(email);
        return GetEmailResp(
          email: emailData,
          message: 'Success',
          status: true,
        );
      } else {
        return GetEmailResp(
          email: Email.initialState(),
          message: 'Response code is not 200',
          status: false,
        );
      }
    } catch (e) {
      return GetEmailResp(
        email: Email.initialState(),
        message: e.toString(),
        status: false,
      );
    }
  }
}

class Attachment {
  final String fileName;
  final String contentType;
  final int size;

  Attachment({
    required this.size,
    required this.contentType,
    required this.fileName,
  });

  Attachment.initialState()
      : fileName = '',
        contentType = '',
        size = 0;

  Attachment.fromJson(Map<String, dynamic> json)
      : fileName = json.containsKey('fileName') ? json['fileName'] : '',
        contentType =
            json.containsKey('contentType') ? json['contentType'] : '',
        size = json.containsKey('size') ? json['size'] : 0;

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'contentType': contentType,
        'size': size,
      };
}

class GetEmailResp {
  final bool status;
  final String message;
  final Email email;

  GetEmailResp({
    required this.email,
    required this.message,
    required this.status,
  });
}
