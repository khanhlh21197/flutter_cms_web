class UserStationModel {
  String? userId;
  String? stationId;
  String? adminId;
  String? playerId;
  String? username;

  UserStationModel({
    this.userId,
    this.stationId,
    this.adminId,
    this.playerId,
    this.username,
  });

  UserStationModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        stationId = json['stationId'],
        adminId = json['adminId'],
        playerId = json['playerId'],
        username = json['username'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'stationId': stationId,
        'adminId': adminId,
        'playerId': playerId,
        'username': username,
      };
}
