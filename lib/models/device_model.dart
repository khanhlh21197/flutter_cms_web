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
  });

  DeviceModel.fromJson(Map<String, dynamic> json)
      : deviceId = json['deviceId'],
        stationId = json['stationId'],
        adminId = json['adminId'],
        name = json['name'],
        description = json['description'],
        location = json['location'],
        threshold1 = json['threshold1'],
        threshold2 = json['threshold2'],
        threshold3 = json['threshold3'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'stationId': stationId,
        'adminId': adminId,
        'name': name,
        'description': description,
        'location': location,
        'threshold1': threshold1,
        'threshold2': threshold2,
        'threshold3': threshold3,
        'status': status,
      };
}
