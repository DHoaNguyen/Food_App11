class UserModel {
  String uid;
  String name;
  String email;
  String address;
  // ignore: non_constant_identifier_names
  String phone_number;

  // ignore: non_constant_identifier_names
  UserModel({this.uid, this.name, this.email, this.address, this.phone_number});

  //lay data tu firebase
  // ignore: non_constant_identifier_names
  factory UserModel.fromMap(Map) {
    return UserModel(
      uid: Map['uid'],
      name: Map['name'],
      email: Map['email'],
      address: Map['address'],
      phone_number: Map['phone_number'],
    );
  }

  //gui data den sever
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'address': address,
      'phone_number': phone_number
    };
  }
}
