
import 'dart:convert';

List<TarjetasFirestore> tarjetasFirestoreFromJson(String str) => List<TarjetasFirestore>.from(json.decode(str).map((x) => TarjetasFirestore.fromJson(x)));

String tarjetasFirestoreToJson(List<TarjetasFirestore> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TarjetasFirestore {
  TarjetasFirestore({
    required this.id,
    required this.numeros,
  });

  String id;
  String numeros;

  factory TarjetasFirestore.fromJson(Map<String, dynamic> json) => TarjetasFirestore(
    id: json["id"],
    numeros: json["numeros"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "numeros": numeros,
  };
}