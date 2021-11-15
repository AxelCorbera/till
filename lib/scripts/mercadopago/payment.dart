// To parse this JSON data, do
//
//     final payment = paymentFromJson(jsonString);

import 'dart:convert';

import 'package:till/pages/checkout.dart';
import 'package:till/scripts/mercadopago/cardsJson.dart';

Payment paymentFromJson(String str) => Payment.fromJson(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toJson());

class Payment {
  Payment({
    this.additionalInfo,
    this.application_fee,
    this.binary_mode,
    this.callback_url,
    this.campaign_id,
    this.capture,
    this.coupon_amount,
    this.coupon_code,
    this.date_of_expiration,
    this.description,
    this.differential_pricing_id,
    this.externalReference,
    this.installments,
    this.issuer_id,
    this.metadata,
    this.notification_url,
    this.order,
    this.payer,
    this.paymentMethodId,
    this.statement_descriptor,
    this.token,
    this.transactionAmount,
  });

  AdditionalInfo? additionalInfo;
  int? application_fee;
  bool? binary_mode;
  String? callback_url;
  int? campaign_id;
  bool? capture;
  int? coupon_amount;
  String? coupon_code;
  String? date_of_expiration;
  String? description;
  int? differential_pricing_id;
  String? externalReference;
  int? installments;
  String? issuer_id;
  Metadata? metadata;
  String? notification_url;
  Order? order;
  PaymentPayer? payer;
  String? paymentMethodId;
  String? statement_descriptor;
  String? token;
  double? transactionAmount;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    additionalInfo: AdditionalInfo.fromJson(json["additional_info"]),
    application_fee: json["application_fee"],
    binary_mode: json["binary_mode"],
    callback_url: json["callback_url"],
    campaign_id: json["campaign_id"],
    capture: json["capture"],
    coupon_amount: json["coupon_amount"],
    coupon_code: json["coupon_code"],
    date_of_expiration: json["date_of_expiration"],
    description: json["description"],
    differential_pricing_id: json["differential_pricing_id"],
    externalReference: json["external_reference"],
    installments: json["installments"],
    issuer_id: json["issuer_id"],
    metadata: Metadata.fromJson(json["metadata"]),
    notification_url: json["notification_url"],
    order: Order.fromJson(json["order"]),
    payer: PaymentPayer.fromJson(json["payer"]),
    paymentMethodId: json["payment_method_id"],
    statement_descriptor: json["statement_descriptor"],
    token: json["token"],
    transactionAmount: json["transaction_amount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "additional_info": additionalInfo!.toJson(),
    "application_fee": application_fee,
    "binary_mode": binary_mode,
    "callback_url": callback_url,
    "campaign_id": campaign_id,
    "capture": capture,
    "coupon_amount": coupon_amount,
    "coupon_code": coupon_code,
    "date_of_expiration": date_of_expiration,
    "description": description,
    "differential_pricing_id": differential_pricing_id,
    "external_reference": externalReference,
    "installments": installments,
    "issuer_id": issuer_id,
    "metadata": metadata!.toJson(),
    "notification_url": notification_url,
    "order": order!.toJson(),
    "payer": payer!.toJson(),
    "payment_method_id": paymentMethodId,
    "statement_descriptor": statement_descriptor,
    "token": token,
    "transaction_amount": transactionAmount,
  };
}

class AdditionalInfo {
  AdditionalInfo({
    this.ip_adress,
    this.items,
    this.payer,
    this.shipments,
    //this.barcode,
  });
  String? ip_adress;
  List<Item>? items;
  AdditionalInfoPayer? payer;
  Shipments? shipments;
  //Barcode? barcode;

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
    ip_adress: json["ip_adress"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    payer: AdditionalInfoPayer.fromJson(json["payer"]),
    shipments: Shipments.fromJson(json["shipments"]),
    //barcode: Barcode.fromJson(json["barcode"]),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items!.map((x) => x.toJson())),
    "payer": payer!.toJson(),
    "shipments": shipments!.toJson(),
    //"barcode": barcode!.toJson(),
  };
}

class Barcode {
  Barcode({this.type,
      this.content,
      this.width,
      this.height});

  String? type;
  String? content;
  int? width;
  int? height;

  factory Barcode.fromJson(Map<String, dynamic> json) => Barcode(
      type: json['type'],
      content: json['content'],
      width: json['width'],
      height: json['height']);

  Map<String, dynamic> toJson() => {
    "type":type,
  };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Item {
  Item({
    this.id,
    this.title,
    this.description,
    this.pictureUrl,
    this.categoryId,
    this.quantity,
    this.unitPrice,
  });

  String? id;
  String? title;
  String? description;
  String? pictureUrl;
  String? categoryId;
  int? quantity;
  double? unitPrice;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    pictureUrl: json["picture_url"],
    categoryId: json["category_id"],
    quantity: json["quantity"],
    unitPrice: json["unit_price"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "picture_url": pictureUrl,
    "category_id": categoryId,
    "quantity": quantity,
    "unit_price": unitPrice,
  };
}

class AdditionalInfoPayer {
  AdditionalInfoPayer({
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.registration_date,
  });

  String? firstName;
  String? lastName;
  Phone? phone;
  Address? address;
  String? registration_date;

  factory AdditionalInfoPayer.fromJson(Map<String, dynamic> json) => AdditionalInfoPayer(
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: Phone.fromJson(json["phone"]),
    address: Address.fromJson(json["address"]),
    registration_date: json["registration_date"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone!.toJson(),
    "address": address!.toJson(),
    "registration_date": registration_date,
  };
}

class Address {
  String? zip_code;
  String? street_name;
  int? street_number;

  Address({this.zip_code,this.street_name,this.street_number});

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    zip_code: json['zip_code'],
      street_name: json['street_name'],
      street_number: json['street_number']);

  Map<String, dynamic> toJson() => {
    "zip_code":zip_code,
    "street_name":street_name,
    "street_number":street_number
  };
}

class Phone {
  Phone({
    this.areaCode,
    this.number,
  });

  int? areaCode;
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

class Shipments {
  Shipments({
    this.receiverAddress,
  });

  ReceiverAddress? receiverAddress;

  factory Shipments.fromJson(Map<String, dynamic> json) => Shipments(
    receiverAddress: ReceiverAddress.fromJson(json["receiver_address"]),
  );

  Map<String, dynamic> toJson() => {
    "receiver_address": receiverAddress!.toJson(),
  };
}

class ReceiverAddress {
  ReceiverAddress({
    this.zipCode,
    this.stateName,
    this.cityName,
    this.streetName,
    this.streetNumber,
    this.floor,
    this.apartment
  });

  String? zipCode;
  String? stateName;
  String? cityName;
  String? streetName;
  int? streetNumber;
  String? floor;
  String? apartment;

  factory ReceiverAddress.fromJson(Map<String, dynamic> json) => ReceiverAddress(
    zipCode: json["zip_code"],
    stateName: json["state_name"],
    cityName: json["city_name"],
    streetName: json["street_name"],
    streetNumber: json["street_number"],
    floor: json["floor"],
    apartment: json["apartment"],
  );

  Map<String, dynamic> toJson() => {
    "zip_code": zipCode,
    "state_name": stateName,
    "city_name": cityName,
    "street_name": streetName,
    "street_number": streetNumber,
    "floor": floor,
    "apartment": apartment,
  };
}

class Order {
  Order({
    this.type,
    this.id
  });

  String? type;
  int? id;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    type: json["type"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
  };
}

class PaymentPayer {
  PaymentPayer({
    this.entityType,
    this.type,
    this.id,
    this.email,
    this.identification,
    this.first_name,
    this.last_name,
  });

  String? entityType;
  String? type;
  String? id;
  String? email;
  Identification? identification;
  String? first_name;
  String? last_name;

  factory PaymentPayer.fromJson(Map<String, dynamic> json) => PaymentPayer(
    entityType: json["entity_type"],
    type: json["type"],
    id: json["id"],
    email: json["email"],
    identification: Identification.fromJson(json["identification"]),
    first_name: json["first_name"],
    last_name: json["last_name"],

  );

  Map<String, dynamic> toJson() => {
    "entity_type": entityType,
    "type": type,
    "id": id,
    "email": email,
    "identification": identification!.toJson(),
    "first_name": first_name,
    "last_name": last_name,
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
