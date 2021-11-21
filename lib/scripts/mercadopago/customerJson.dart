// To parse this JSON data, do
//
//     final createCustomer = createCustomerFromJson(jsonString);

import 'dart:convert';

import 'package:till/scripts/mercadopago/cardCustomer.dart';

CreateCustomer createCustomerFromJson(String str) => CreateCustomer.fromJson(json.decode(str));

String createCustomerToJson(CreateCustomer data) => json.encode(data.toJson());

class CreateCustomer {
  CreateCustomer({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.identification,
    this.address,
    this.description,
    this.dateCreated,
    this.metadata,
    this.defaultAddress,
    this.cards,
    this.addresses,
    this.liveMode,
  });

  String? id;
  String? email;
  String? firstName;
  String? lastName;
  Phone? phone;
  Identification? identification;
  PurpleAddress? address;
  String? description;
  DateTime? dateCreated;
  Metadata? metadata;
  String? defaultAddress;
  List<AddressElement>? cards;
  List<AddressElement>? addresses;
  bool? liveMode;

  factory CreateCustomer.fromJson(Map<String, dynamic> json) => CreateCustomer(
    id: json["id"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: Phone.fromJson(json["phone"]),
    identification: Identification.fromJson(json["identification"]),
    address: PurpleAddress.fromJson(json["address"]),
    description: json["description"],
    dateCreated: DateTime.parse(json["date_created"]),
    metadata: Metadata.fromJson(json["metadata"]),
    defaultAddress: json["default_address"],
    cards: List<AddressElement>.from(json["cards"].map((x) => AddressElement.fromJson(x))),
    addresses: List<AddressElement>.from(json["addresses"].map((x) => AddressElement.fromJson(x))),
    liveMode: json["live_mode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone!.toJson(),
    "identification": identification!.toJson(),
    "address": address!.toJson(),
    "description": description,
    "date_created": dateCreated.toString(),
    "metadata": metadata!.toJson(),
    "default_address": defaultAddress,
    "cards": List<dynamic>.from(cards!.map((x) => x.toJson())),
    "addresses": List<dynamic>.from(addresses!.map((x) => x.toJson())),
    "live_mode": liveMode,
  };
}

class PurpleAddress {
  PurpleAddress({
    this.id,
    this.zipCode,
    this.streetName,
  });

  String? id;
  String? zipCode;
  String? streetName;

  factory PurpleAddress.fromJson(Map<String, dynamic> json) => PurpleAddress(
    id: json["id"],
    zipCode: json["zip_code"],
    streetName: json["street_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "zip_code": zipCode,
    "street_name": streetName,
  };
}

class AddressElement {
  AddressElement();

  factory AddressElement.fromJson(Map<String, dynamic> json) => AddressElement(
  );

  Map<String, dynamic> toJson() => {
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

class Metadata {
  Metadata({
    this.sourceSync,
  });

  String? sourceSync;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    sourceSync: json["source_sync"],
  );

  Map<String, dynamic> toJson() => {
    "source_sync": sourceSync,
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

FindCustomer findCustomerFromJson(String str) => FindCustomer.fromJson(json.decode(str));

String findCustomerToJson(FindCustomer data) => json.encode(data.toJson());

class FindCustomer {
  FindCustomer({
    this.paging,
    this.results,
  });

  Paging? paging;
  List<Result>? results;

  factory FindCustomer.fromJson(Map<String, dynamic> json) => FindCustomer(
    paging: Paging.fromJson(json["paging"]),
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "paging": paging!.toJson(),
    "results": List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Paging {
  Paging({
    this.limit,
    this.offset,
    this.total,
  });

  int? limit;
  int? offset;
  int? total;

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
    limit: json["limit"],
    offset: json["offset"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "offset": offset,
    "total": total,
  };
}

class Result {
  Result({
    this.address,
    this.addresses,
    this.cards,
    this.dateCreated,
    this.dateLastUpdated,
    this.defaultAddress,
    this.defaultCard,
    this.email,
    this.firstName,
    this.id,
    this.identification,
    this.lastName,
    this.liveMode,
    this.metadata,
    this.phone,
   // this.dateRegistered,
    this.description
  });

  Address? address;
  List<Metadata>? addresses;
  List<CardCustomer>? cards;
  DateTime? dateCreated;
  DateTime? dateLastUpdated;
  //DateTime? dateRegistered;
  String? defaultAddress;
  String? defaultCard;
  String? email;
  String? firstName;
  String? id;
  Identification? identification;
  String? lastName;
  bool? liveMode;
  Metadata? metadata;
  Phone? phone;
  String? description;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    address: Address.fromJson(json["address"]),
    addresses: List<Metadata>.from(json["addresses"].map((x) => Metadata.fromJson(x))),
    cards: List<CardCustomer>.from(json["cards"].map((x) => CardCustomer.fromJson(x))),
    dateCreated: DateTime.parse(json["date_created"]),
    dateLastUpdated: DateTime.parse(json["date_last_updated"]),
    //dateRegistered: DateTime.parse(json["date_registered"]),
    defaultAddress: json["default_address"],
    defaultCard: json["default_card"],
    email: json["email"],
    firstName: json["first_name"],
    id: json["id"],
    identification: Identification.fromJson(json["identification"]),
    lastName: json["last_name"],
    description: json["description"],
    liveMode: json["live_mode"],
    metadata: Metadata.fromJson(json["metadata"]),
    phone: Phone.fromJson(json["phone"]),
  );

  Map<String, dynamic> toJson() => {
    "address": address!.toJson(),
    "addresses": List<dynamic>.from(addresses!.map((x) => x.toJson())),
    "cards": List<dynamic>.from(cards!.map((x) => x.toJson())),
    "date_created": dateCreated!.toString(),
    "date_last_updated": dateLastUpdated!.toString(),
    //"date_registered" : dateRegistered!.toString(),
    "default_address": defaultAddress,
    "default_card": defaultCard,
    "email": email,
    "description": description,
    "first_name": firstName,
    "id": id,
    "identification": identification!.toJson(),
    "last_name": lastName,
    "live_mode": liveMode,
    "metadata": metadata!.toJson(),
    "phone": phone!.toJson(),
  };
}

class Address {
  Address({
    this.id,
    this.streetName,
    this.zipCode,
    this.streetNumber,
    this.city
  });

  String? id;
  String? streetName;
  String? zipCode;
  int? streetNumber;
  String? city;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    streetName: json["street_name"],
    zipCode: json["zip_code"],
    streetNumber: json["street_number"],
    city: json["city"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "street_name": streetName,
    "zip_code": zipCode,
    "street_number": streetNumber,
    "city": city,
  };
}

