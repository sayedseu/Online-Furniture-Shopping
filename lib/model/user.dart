class User {
  String _address;
  String _contactNumber;
  String _email;
  String _fullName;
  String _role;
  String _userName;
  String _userPassword;

  User(
      {String address,
      String contactNumber,
      String email,
      String fullName,
      String role,
      String userName,
      String userPassword}) {
    this._address = address;
    this._contactNumber = contactNumber;
    this._email = email;
    this._fullName = fullName;
    this._role = role;
    this._userName = userName;
    this._userPassword = userPassword;
  }

  String get address => _address;

  set address(String address) => _address = address;

  String get contactNumber => _contactNumber;

  set contactNumber(String contactNumber) => _contactNumber = contactNumber;

  String get email => _email;

  set email(String email) => _email = email;

  String get fullName => _fullName;

  set fullName(String fullName) => _fullName = fullName;

  String get role => _role;

  set role(String role) => _role = role;

  String get userName => _userName;

  set userName(String userName) => _userName = userName;

  String get userPassword => _userPassword;

  set userPassword(String userPassword) => _userPassword = userPassword;

  User.fromJson(Map<String, dynamic> json) {
    _address = json['address'];
    _contactNumber = json['contactNumber'];
    _email = json['email'];
    _fullName = json['fullName'];
    _role = json['role'];
    _userName = json['userName'];
    _userPassword = json['userPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this._address;
    data['contactNumber'] = this._contactNumber;
    data['email'] = this._email;
    data['fullName'] = this._fullName;
    data['role'] = this._role;
    data['userName'] = this._userName;
    data['userPassword'] = this._userPassword;
    return data;
  }
}
