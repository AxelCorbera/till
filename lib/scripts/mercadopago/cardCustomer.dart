// To parse this JSON data, do
//
//     final cardCustomer = cardCustomerFromJson(jsonString);

import 'dart:convert';

CardCustomer cardCustomerFromJson(String str) => CardCustomer.fromJson(json.decode(str));

String cardCustomerToJson(CardCustomer data) => json.encode(data.toJson());

class CardCustomer {
  CardCustomer({
    this.cardholder,
    this.customerId,
    this.dateCreated,
    this.dateLastUpdated,
    this.expirationMonth,
    this.expirationYear,
    this.firstSixDigits,
    this.id,
    this.issuer,
    this.lastFourDigits,
    this.paymentMethod,
    this.securityCode,
    this.userId,
  });

  Cardholder? cardholder;
  String? customerId;
  DateTime? dateCreated;
  DateTime? dateLastUpdated;
  int? expirationMonth;
  int? expirationYear;
  String? firstSixDigits;
  String? id;
  Issuer? issuer;
  String? lastFourDigits;
  PaymentMethod? paymentMethod;
  SecurityCode? securityCode;
  String? userId;

  factory CardCustomer.fromJson(Map<String, dynamic> json) => CardCustomer(
    cardholder: Cardholder.fromJson(json["cardholder"]),
    customerId: json["customer_id"],
    dateCreated: DateTime.parse(json["date_created"]),
    dateLastUpdated: DateTime.parse(json["date_last_updated"]),
    expirationMonth: json["expiration_month"],
    expirationYear: json["expiration_year"],
    firstSixDigits: json["first_six_digits"],
    id: json["id"],
    issuer: Issuer.fromJson(json["issuer"]),
    lastFourDigits: json["last_four_digits"],
    paymentMethod: PaymentMethod.fromJson(json["payment_method"]),
    securityCode: SecurityCode.fromJson(json["security_code"]),
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "cardholder": cardholder!.toJson(),
    "customer_id": customerId,
    "date_created": dateCreated.toString(),
    "date_last_updated": dateLastUpdated.toString(),
    "expiration_month": expirationMonth,
    "expiration_year": expirationYear,
    "first_six_digits": firstSixDigits,
    "id": id,
    "issuer": issuer!.toJson(),
    "last_four_digits": lastFourDigits,
    "payment_method": paymentMethod!.toJson(),
    "security_code": securityCode!.toJson(),
    "user_id": userId,
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

  String? number;
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
