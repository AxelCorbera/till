class tokenIngreso {
  final String id;
  final String token;

  tokenIngreso({required this.id, required this.token});

  factory tokenIngreso.fromJson(Map<String, dynamic> json) {
    return tokenIngreso(
      id: json['id'],
      token: json['token'],
    );
  }
}
