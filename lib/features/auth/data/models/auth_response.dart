class AuthResponse {
  final String userName;
  final String uuid;
  final int userId;
  final int individualId;
  final int establishmentId;
  final String token;
  final String expirationDate;

  AuthResponse({
    required this.userName,
    required this.uuid,
    required this.userId,
    required this.individualId,
    required this.establishmentId,
    required this.token,
    required this.expirationDate,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      userName: json['userName'] as String,
      uuid: json['uuid'] as String,
      userId: json['userId'] as int,
      individualId: json['idIndividu'] as int,
      establishmentId: json['etablissementId'] as int,
      token: json['token'] as String,
      expirationDate: json['expirationDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'uuid': uuid,
      'userId': userId,
      'idIndividu': individualId,
      'etablissementId': establishmentId,
      'token': token,
      'expirationDate': expirationDate,
    };
  }
}
