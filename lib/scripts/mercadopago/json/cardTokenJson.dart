// To parse this JSON data, do
//
//     final cardToken = cardTokenFromJson(jsonString);

import 'dart:convert';

CardTokenJson cardTokenFromJson(String str) => CardTokenJson.fromJson(json.decode(str));

String cardTokenToJson(CardTokenJson data) => json.encode(data.toJson());

class CardTokenJson {
  CardTokenJson({
    this.status,
    this.response,
  });

  int? status;
  Response? response;

  factory CardTokenJson.fromJson(Map<String, dynamic> json) => CardTokenJson(
    status: json["status"],
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": response!.toJson(),
  };
}

class Response {
  Response({
    this.id,
    this.publicKey,
    this.firstSixDigits,
    this.expirationMonth,
    this.expirationYear,
    this.lastFourDigits,
    this.cardholder,
    this.status,
    this.dateCreated,
    this.dateLastUpdated,
    this.dateDue,
    this.luhnValidation,
    this.liveMode,
    this.requireEsc,
    this.cardNumberLength,
    this.securityCodeLength,
  });

  String? id;
  String? publicKey;
  int? firstSixDigits;
  int? expirationMonth;
  int? expirationYear;
  int? lastFourDigits;
  Cardholder? cardholder;
  String? status;
  DateTime? dateCreated;
  DateTime? dateLastUpdated;
  DateTime? dateDue;
  bool? luhnValidation;
  bool? liveMode;
  bool? requireEsc;
  int? cardNumberLength;
  int? securityCodeLength;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["id"],
    publicKey: json["public_key"],
    firstSixDigits: json["first_six_digits"],
    expirationMonth: json["expiration_month"],
    expirationYear: json["expiration_year"],
    lastFourDigits: json["last_four_digits"],
    cardholder: Cardholder.fromJson(json["cardholder"]),
    status: json["status"],
    dateCreated: DateTime.parse(json["date_created"]),
    dateLastUpdated: DateTime.parse(json["date_last_updated"]),
    dateDue: DateTime.parse(json["date_due"]),
    luhnValidation: json["luhn_validation"],
    liveMode: json["live_mode"],
    requireEsc: json["require_esc"],
    cardNumberLength: json["card_number_length"],
    securityCodeLength: json["security_code_length"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "public_key": publicKey,
    "first_six_digits": firstSixDigits,
    "expiration_month": expirationMonth,
    "expiration_year": expirationYear,
    "last_four_digits": lastFourDigits,
    "cardholder": cardholder!.toJson(),
    "status": status,
    "date_created": dateCreated!.toIso8601String(),
    "date_last_updated": dateLastUpdated!.toIso8601String(),
    "date_due": dateDue!.toIso8601String(),
    "luhn_validation": luhnValidation,
    "live_mode": liveMode,
    "require_esc": requireEsc,
    "card_number_length": cardNumberLength,
    "security_code_length": securityCodeLength,
  };
}

class Cardholder {
  Cardholder({
    this.identification,
    this.name,
  });

  Identification? identification;
  String? name;

  factory Cardholder.fromJson(Map<String, dynamic> json) => Cardholder(
    identification: Identification.fromJson(json["identification"]),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "identification": identification!.toJson(),
    "name": name,
  };
}

class Identification {
  Identification({
    this.number,
    this.type,
  });

  int? number;
  String? type;

  factory Identification.fromJson(Map<String, dynamic> json) => Identification(
    number: json["number"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "type": type,
  };
}
