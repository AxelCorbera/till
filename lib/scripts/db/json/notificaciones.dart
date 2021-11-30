import 'dart:convert';

List<NotiFirestore> notiFirestoreFromJson(String str) => List<NotiFirestore>.from(json.decode(str).map((x) => NotiFirestore.fromJson(x)));

String notiFirestoreToJson(List<NotiFirestore> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotiFirestore {
  NotiFirestore({
    required this.id,
    required this.titulo,
    required this.mensaje,
  });

  String id;
  String titulo;
  String mensaje;

  factory NotiFirestore.fromJson(Map<String, dynamic> json) => NotiFirestore(
    id: json["id"],
    titulo: json["titulo"],
    mensaje: json["mensaje"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "titulo": titulo,
    "mensaje": mensaje,
  };
}