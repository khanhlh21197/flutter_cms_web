class StationModel {
  String stationId;
  String adminId;
  String name;
  String description;
  String location;

  StationModel(
    this.stationId,
    this.adminId,
    this.name,
    this.description,
    this.location,
  );

  StationModel.fromJson(Map<String, dynamic> json)
      : adminId = json['adminId'] ?? '',
        stationId = json['stationId'] ?? '',
        name = json['name'] ?? '',
        description = json['description'] ?? '',
        location = json['location'] ?? '';

  Map<String, dynamic> toJson() => {
        'stationId': stationId,
        'adminID': adminId,
        'name': name,
        'description': description,
        'location': location,
      };
}
