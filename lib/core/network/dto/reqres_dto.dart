/// DTO для ответов ReqRes API

/// DTO для ответа регистрации
class ReqResRegisterResponseDto {
  final String? token;
  final int? id;
  final String? error;

  ReqResRegisterResponseDto({
    this.token,
    this.id,
    this.error,
  });

  factory ReqResRegisterResponseDto.fromJson(Map<String, dynamic> json) {
    return ReqResRegisterResponseDto(
      token: json['token'] as String?,
      id: json['id'] as int?,
      error: json['error'] as String?,
    );
  }
}

/// DTO для ответа входа
class ReqResLoginResponseDto {
  final String? token;
  final String? error;

  ReqResLoginResponseDto({
    this.token,
    this.error,
  });

  factory ReqResLoginResponseDto.fromJson(Map<String, dynamic> json) {
    return ReqResLoginResponseDto(
      token: json['token'] as String?,
      error: json['error'] as String?,
    );
  }
}

/// DTO для запроса регистрации
class ReqResRegisterRequestDto {
  final String email;
  final String password;

  ReqResRegisterRequestDto({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

/// DTO для запроса входа
class ReqResLoginRequestDto {
  final String email;
  final String password;

  ReqResLoginRequestDto({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

