class AdminModel {
  String? adminId;
  String? user;
  String? pass;
  String? passmoi;
  String? name;
  String? phone;
  String? address;
  String? birthDate;
  String? gender;
  String? playerId;

  AdminModel({
    this.user,
    this.pass,
    this.passmoi,
    this.gender,
    this.name,
    this.phone,
    this.address,
    this.birthDate,
    this.playerId,
  });

  AdminModel.fromJson(Map<String, dynamic> json)
      : user = json['user'],
        pass = json['pass'],
        gender = json['gender'],
        adminId = json['_id'],
        passmoi = json['passmoi'],
        name = json['name'],
        phone = json['phone'],
        address = json['address'],
        birthDate = json['birthDate'],
        playerId = json['playerId'];

  Map<String, dynamic> toJson() => {
        'user': user,
        'pass': pass,
        'passmoi': passmoi,
        'name': name,
        'gender': gender,
        'phone': phone,
        'address': address,
        'birthDate': birthDate,
        'playerId': playerId,
      };
}
