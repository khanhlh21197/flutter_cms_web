class UserModel {
  String? user;
  String? pass;
  String? passmoi;
  String? name;
  String? phone;
  String? address;
  String? birthDate;
  String? playerId;
  String? adminId;

  UserModel({
    this.user,
    this.pass,
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
        passmoi = json['passmoi'],
        name = json['name'],
        phone = json['phone'],
        address = json['address'],
        birthDate = json['birthDate'],
        adminId = json['adminId'],
        playerId = json['playerId'];

  Map<String, dynamic> toJson() => {
        'user': user,
        'pass': pass,
        'passmoi': passmoi,
        'name': name,
        'phone': phone,
        'address': address,
        'birthDate': birthDate,
        'playerId': playerId,
        'adminId': adminId,
      };
}
