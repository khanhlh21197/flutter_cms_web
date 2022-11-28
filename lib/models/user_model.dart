class UserModel {
  String? userId;
  String? user;
  String? pass;
  String? passmoi;
  String? name;
  String? gender;
  String? phone;
  String? address;
  String? birthDate;
  String? playerId;
  String? adminId;

  UserModel({
    this.user,
    this.pass,
    this.gender,
    this.passmoi,
    this.name,
    this.phone,
    this.address,
    this.birthDate,
    this.playerId,
    this.adminId,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : user = json['user'],
        pass = json['pass'],
        gender = json['gender'],
        userId = json['_id'],
        passmoi = json['passmoi'],
        name = json['name'],
        phone = json['phone'],
        address = json['address'],
        birthDate = json['birthDate'],
        adminId = json['_id'],
        playerId = json['playerId'];

  Map<String, dynamic> toJson() => {
        'user': user,
        'pass': pass,
        'gender': gender,
        'passmoi': passmoi,
        'name': name,
        'phone': phone,
        'address': address,
        'birthDate': birthDate,
        'playerId': playerId,
        'adminId': adminId,
      };
}
