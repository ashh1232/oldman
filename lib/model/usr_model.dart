class UserModel {
  final int? id;
  final int? usrCat;
  final int? usrUser;
  final double? locationLat;
  final double? locationLong;

  UserModel({
    this.id,
    this.usrCat,
    this.usrUser,
    this.locationLat,
    this.locationLong,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      usrCat: json['usr_cat'],
      usrUser: json['usr_user'],
      locationLat: json['location_lat']?.toDouble(),
      locationLong: json['location_long']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usr_cat': usrCat,
      'usr_user': usrUser,
      'location_lat': locationLat,
      'location_long': locationLong,
    };
  }
}
