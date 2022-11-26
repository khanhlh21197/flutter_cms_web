class DeviceModel {
  String? deviceId;
  String? stationId;
  String? adminId;
  String? name;
  String? description;
  String? location;
  String? threshold1;
  String? threshold2;
  String? threshold3;
  String? status;
  String? time;
  String? notifi;
  int? ozone;
  int? solanvuot;

  DeviceModel({
    this.deviceId,
    this.stationId,
    this.adminId,
    this.name,
    this.description,
    this.location,
    this.threshold1,
    this.threshold2,
    this.threshold3,
    this.status,
    this.notifi,
    this.ozone,
  });

  DeviceModel.fromJson(Map<String, dynamic> json)
      : deviceId = json['deviceId'] ?? '',
        stationId = json['stationId'] ?? '',
        adminId = json['adminId'] ?? '',
        name = json['name'] ?? '',
        time = json['time'] ?? '',
        description = json['description'] ?? '',
        location = json['location'] ?? '',
        threshold1 = json['threshold1'] ?? '',
        threshold2 = json['threshold2'] ?? '',
        threshold3 = json['threshold3'] ?? '',
        notifi = json['notifi'] ?? '',
        ozone = json['ozone'] ?? 0,
        solanvuot = json['solanvuot'] ?? 0,
        status = json['status'] ?? '';

  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'stationId': stationId,
        'adminId': adminId,
        'name': name,
        'time': time,
        'description': description,
        'location': location,
        'threshold1': threshold1,
        'threshold2': threshold2,
        'threshold3': threshold3,
        'notifi': notifi,
        'status': status,
      };
}
