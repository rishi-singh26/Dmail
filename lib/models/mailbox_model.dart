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
}
