// To parse this JSON data, do
//
//     final saveCard = saveCardFromJson(jsonString);

import 'dart:convert';

SaveCard saveCardFromJson(String str) => SaveCard.fromJson(json.decode(str));

String saveCardToJson(SaveCard data) => json.encode(data.toJson());

class SaveCard {
  SaveCard({
    this.id,
    this.expirationMonth,
    this.expirationYear,
    this.firstSixDigits,
    this.lastFourDigits,
    this.paymentMethod,
    this.securityCode,
    this.issuer,
    this.cardholder,
    this.dateCreated,
    this.dateLastUpdated,
    this.customerId,
    this.userId,
    this.liveMode,
  });

  int? id;
  int? expirationMonth;
  int? expirationYear;
  int? firstSixDigits;
  int? lastFourDigits;
  PaymentMethod? paymentMethod;
  SecurityCode? securityCode;
  Issuer? issuer;
  Cardholder? cardholder;
  DateTime? dateCreated;
  DateTime? dateLastUpdated;
  String? customerId;
  int? userId;
  bool? liveMode;

  factory SaveCard.fromJson(Map<String, dynamic> json) => SaveCard(
    id: json["id"],
    expirationMonth: json["expiration_month"],
    expirationYear: json["expiration_year"],
    firstSixDigits: json["first_six_digits"],
    lastFourDigits: json["last_four_digits"],
    paymentMethod: PaymentMethod.fromJson(json["payment_method"]),
    securityCode: SecurityCode.fromJson(json["security_code"]),
    issuer: Issuer.fromJson(json["issuer"]),
    cardholder: Cardholder.fromJson(json["cardholder"]),
    dateCreated: DateTime.parse(json["date_created"]),
    dateLastUpdated: DateTime.parse(json["date_last_updated"]),
    customerId: json["customer_id"],
    userId: json["user_id"],
    liveMode: json["live_mode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "expiration_month": expirationMonth,
    "expiration_year": expirationYear,
    "first_six_digits": firstSixDigits,
    "last_four_digits": lastFourDigits,
    "payment_method": paymentMethod!.toJson(),
    "security_code": securityCode!.toJson(),
    "issuer": issuer!.toJson(),
    "cardholder": cardholder!.toJson(),
    "date_created": dateCreated!.toIso8601String(),
    "date_last_updated": dateLastUpdated!.toIso8601String(),
    "customer_id": customerId,
    "user_id": userId,
    "live_mode": liveMode,
  };
}

class Cardholder {
  Cardholder({
    this.name,
    this.identification,
  });

  String? name;
  Identification? identification;

  factory Cardholder.fromJson(Map<String, dynamic> json) => Cardholder(
    name: json["name"],
    identification: Identification.fromJson(json["identification"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "identification": identification!.toJson(),
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

class Issuer {
  Issuer({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Issuer.fromJson(Map<String, dynamic> json) => Issuer(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class PaymentMethod {
  PaymentMethod({
    this.id,
    this.name,
    this.paymentTypeId,
    this.thumbnail,
    this.secureThumbnail,
  });

  String? id;
  String? name;
  String? paymentTypeId;
  String? thumbnail;
  String? secureThumbnail;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json["id"],
    name: json["name"],
    paymentTypeId: json["payment_type_id"],
    thumbnail: json["thumbnail"],
    secureThumbnail: json["secure_thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "payment_type_id": paymentTypeId,
    "thumbnail": thumbnail,
    "secure_thumbnail": secureThumbnail,
  };
}

class SecurityCode {
  SecurityCode({
    this.length,
    this.cardLocation,
  });

  int? length;
  String? cardLocation;

  factory SecurityCode.fromJson(Map<String, dynamic> json) => SecurityCode(
    length: json["length"],
    cardLocation: json["card_location"],
  );

  Map<String, dynamic> toJson() => {
    "length": length,
    "card_location": cardLocation,
  };
}
