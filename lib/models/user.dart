enum Type { graduation, undergrad, teacher, admin }

class User {
  late String _id;
  late String _password;
  late String _name;
  late Type _type;

  User(this._id, this._password, this._name, this._type);

  User.fromMap(dynamic obj) {
    _id = obj['id'];
    _password = obj['password'];
    _name = obj['name'];
    _type = obj['type'];
  }
  String get id => _id;
  String get password => _password;
  String get name => _name;
  String get type => _type.toString();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['id'] = _id;
    map['password'] = _password;
    map['name'] = _name;
    map['type'] = _type;
    return map;
  }
}
