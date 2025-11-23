class UserData {
final String uid;
final String email;
final String name;
final String createdAt;

  UserData({required this.uid, required this.email, required this.name, required this.createdAt });



  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': createdAt,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

}
