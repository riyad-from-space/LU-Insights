class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final int studentId;
  final String password;

  //constructor

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.studentId,
    required this.password,
  });

  //usermodel to map

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'studentId': studentId,
      'password': password,
    };
  }

  //map to usermodel

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      userName: map['userName'],
      email: map['email'],
      studentId: map['studentId'].toInt(),
      password: map['password'],
    );
  }
}
