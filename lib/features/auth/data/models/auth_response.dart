class AuthResponse {
  final String expirationDate;
  final String token;
  final int userId;
  final String uuid;
  final int idIndividu;
  final int etablissementId;
  final String userName;

  AuthResponse({
    required this.expirationDate,
    required this.token,
    required this.userId,
    required this.uuid,
    required this.idIndividu,
    required this.etablissementId,
    required this.userName,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      expirationDate: json['expirationDate'] as String,
      token: json['token'] as String,
      userId: json['userId'] as int,
      uuid: json['uuid'] as String,
      idIndividu: json['idIndividu'] as int,
      etablissementId: json['etablissementId'] as int,
      userName: json['userName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expirationDate': expirationDate,
      'token': token,
      'userId': userId,
      'uuid': uuid,
      'idIndividu': idIndividu,
      'etablissementId': etablissementId,
      'userName': userName,
    };
  }
} 