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
}
