// To parse this JSON data, do
//
//     final datos = datosFromJson(jsonString);

import 'dart:convert';

Datos datosFromJson(String str) => Datos.fromJson(json.decode(str));

String datosToJson(Datos data) => json.encode(data.toJson());

class Datos {
  Datos({
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.identification,
    this.defaultAddress,
    this.address,
    this.dateRegistered,
    this.description,
    this.defaultCard,
  });

  String? email;
  String? firstName;
  String? lastName;
  Phone? phone;
  Identification? identification;
  String? defaultAddress;
  Address? address;
  String? dateRegistered;
  String? description;
  String? defaultCard;

  factory Datos.fromJson(Map<String, dynamic> json) => Datos(
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: Phone.fromJson(json["phone"]),
    identification: Identification.fromJson(json["identification"]),
    defaultAddress: json["default_address"],
    address: Address.fromJson(json["address"]),
    dateRegistered: json["date_registered"],
    description: json["description"],
    defaultCard: json["default_card"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone!.toJson(),
    "identification": identification!.toJson(),
    "default_address": defaultAddress,
    "address": address!.toJson(),
    "date_registered": dateRegistered,
    "description": description,
    "default_card": defaultCard,
  };
}

class Address {
  Address({
    this.id,
    this.zipCode,
    this.streetName,
    this.streetNumber,
  });

  String? id;
  String? zipCode;
  String? streetName;
  int? streetNumber;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    zipCode: json["zip_code"],
    streetName: json["street_name"],
    streetNumber: json["street_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "zip_code": zipCode,
    "street_name": streetName,
    "street_number": streetNumber,
  };
}

class Identification {
  Identification({
    this.type,
    this.number,
  });

  String? type;
  String? number;

  factory Identification.fromJson(Map<String, dynamic> json) => Identification(
    type: json["type"],
    number: json["number"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "number": number,
  };
}

class Phone {
  Phone({
    this.areaCode,
    this.number,
  });

  String? areaCode;
  String? number;

  factory Phone.fromJson(Map<String, dynamic> json) => Phone(
    areaCode: json["area_code"],
    number: json["number"],
  );

  Map<String, dynamic> toJson() => {
    "area_code": areaCode,
    "number": number,
  };
}
