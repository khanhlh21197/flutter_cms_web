class StationModel {
  String? stationId;
  String? numberofdevice;
  String? adminId;
  String? name;
  String? description;
  String? location;
  bool? selected;

  StationModel({
    this.stationId,
    this.adminId,
    this.name,
    this.description,
    this.location,
  });

  StationModel.fromJson(Map<String, dynamic> json)
      : adminId = json['adminId'] ?? '',
        stationId = json['stationId'] ?? '',
        numberofdevice =
            (json['numberofdevice'] != null) ? '${json['numberofdevice']}' : '',
        name = json['name'] ?? '',
        description = json['description'] ?? '',
        location = json['location'] ?? '';

  Map<String, dynamic> toJson() => {
        'stationId': stationId,
        'adminId': adminId,
        'name': name,
        'description': description,
        'location': location,
      };
}
