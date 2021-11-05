// To parse this JSON data, do
//
//     final responsePayment = responsePaymentFromJson(jsonString);

import 'dart:convert';

ResponsePayment responsePaymentFromJson(String str) => ResponsePayment.fromJson(json.decode(str));

String responsePaymentToJson(ResponsePayment data) => json.encode(data.toJson());

class ResponsePayment {
  ResponsePayment({
    this.id,
    this.dateCreated,
    this.dateApproved,
    this.dateLastUpdated,
    this.moneyReleaseDate,
    this.issuerId,
    this.paymentMethodId,
    this.paymentTypeId,
    this.status,
    this.statusDetail,
    this.currencyId,
    this.description,
    this.taxesAmount,
    this.shippingAmount,
    this.collectorId,
    this.payer,
    this.metadata,
    this.additionalInfo,
    this.order,
    this.externalReference,
    this.transactionAmount,
    this.transactionAmountRefunded,
    this.couponAmount,
    this.transactionDetails,
    this.feeDetails,
    this.statementDescriptor,
    this.installments,
    this.card,
    this.notificationUrl,
    this.processingMode,
    this.pointOfInteraction,
  });

  int? id;
  DateTime? dateCreated;
  DateTime? dateApproved;
  DateTime? dateLastUpdated;
  DateTime? moneyReleaseDate;
  String? issuerId;
  String? paymentMethodId;
  String? paymentTypeId;
  String? status;
  String? statusDetail;
  String? currencyId;
  String? description;
  int? taxesAmount;
  int? shippingAmount;
  int? collectorId;
  ResponsePaymentPayer? payer;
  Metadata? metadata;
  AdditionalInfo? additionalInfo;
  Metadata? order;
  String? externalReference;
  double? transactionAmount;
  int? transactionAmountRefunded;
  int? couponAmount;
  TransactionDetails? transactionDetails;
  List<FeeDetail>? feeDetails;
  String? statementDescriptor;
  int? installments;
  Card? card;
  String? notificationUrl;
  String? processingMode;
  PointOfInteraction? pointOfInteraction;

  factory ResponsePayment.fromJson(Map<String, dynamic> json) => ResponsePayment(
    id: json["id"],
    dateCreated: DateTime.parse(json["date_created"]),
    dateApproved: DateTime.parse(json["date_approved"]),
    dateLastUpdated: DateTime.parse(json["date_last_updated"]),
    moneyReleaseDate: DateTime.parse(json["money_release_date"]),
    issuerId: json["issuer_id"],
    paymentMethodId: json["payment_method_id"],
    paymentTypeId: json["payment_type_id"],
    status: json["status"],
    statusDetail: json["status_detail"],
    currencyId: json["currency_id"],
    description: json["description"],
    taxesAmount: json["taxes_amount"],
    shippingAmount: json["shipping_amount"],
    collectorId: json["collector_id"],
    payer: ResponsePaymentPayer.fromJson(json["payer"]),
    metadata: Metadata.fromJson(json["metadata"]),
    additionalInfo: AdditionalInfo.fromJson(json["additional_info"]),
    order: Metadata.fromJson(json["order"]),
    externalReference: json["external_reference"],
    transactionAmount: json["transaction_amount"].toDouble(),
    transactionAmountRefunded: json["transaction_amount_refunded"],
    couponAmount: json["coupon_amount"],
    transactionDetails: TransactionDetails.fromJson(json["transaction_details"]),
    feeDetails: List<FeeDetail>.from(json["fee_details"].map((x) => FeeDetail.fromJson(x))),
    statementDescriptor: json["statement_descriptor"],
    installments: json["installments"],
    card: Card.fromJson(json["card"]),
    notificationUrl: json["notification_url"],
    processingMode: json["processing_mode"],
    pointOfInteraction: PointOfInteraction.fromJson(json["point_of_interaction"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date_created": dateCreated.toString(),
    "date_approved": dateApproved.toString(),
    "date_last_updated": dateLastUpdated.toString(),
    "money_release_date": moneyReleaseDate.toString(),
    "issuer_id": issuerId,
    "payment_method_id": paymentMethodId,
    "payment_type_id": paymentTypeId,
    "status": status,
    "status_detail": statusDetail,
    "currency_id": currencyId,
    "description": description,
    "taxes_amount": taxesAmount,
    "shipping_amount": shippingAmount,
    "collector_id": collectorId,
    "payer": payer!.toJson(),
    "metadata": metadata!.toJson(),
    "additional_info": additionalInfo!.toJson(),
    "order": order!.toJson(),
    "external_reference": externalReference,
    "transaction_amount": transactionAmount,
    "transaction_amount_refunded": transactionAmountRefunded,
    "coupon_amount": couponAmount,
    "transaction_details": transactionDetails!.toJson(),
    "fee_details": List<dynamic>.from(feeDetails!.map((x) => x.toJson())),
    "statement_descriptor": statementDescriptor,
    "installments": installments,
    "card": card!.toJson(),
    "notification_url": notificationUrl,
    "processing_mode": processingMode,
    "point_of_interaction": pointOfInteraction!.toJson(),
  };
}

class AdditionalInfo {
  AdditionalInfo({
    this.items,
    this.payer,
    this.shipments,
  });

  List<Item>? items;
  AdditionalInfoPayer? payer;
  Shipments? shipments;

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    payer: AdditionalInfoPayer.fromJson(json["payer"]),
    shipments: Shipments.fromJson(json["shipments"]),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items!.map((x) => x.toJson())),
    "payer": payer!.toJson(),
    "shipments": shipments!.toJson(),
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
    this.registrationDate,
  });

  DateTime? registrationDate;

  factory AdditionalInfoPayer.fromJson(Map<String, dynamic> json) => AdditionalInfoPayer(
    registrationDate: DateTime.parse(json["registration_date"]),
  );

  Map<String, dynamic> toJson() => {
    "registration_date": registrationDate.toString(),
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
    this.streetName,
    this.streetNumber,
    this.zipCode,
    this.cityName,
    this.stateName,
  });

  String? streetName;
  int? streetNumber;
  int? zipCode;
  String? cityName;
  String? stateName;

  factory ReceiverAddress.fromJson(Map<String, dynamic> json) => ReceiverAddress(
    streetName: json["street_name"],
    streetNumber: json["street_number"],
    zipCode: json["zip_code"],
    cityName: json["city_name"],
    stateName: json["state_name"],
  );

  Map<String, dynamic> toJson() => {
    "street_name": streetName,
    "street_number": streetNumber,
    "zip_code": zipCode,
    "city_name": cityName,
    "state_name": stateName,
  };
}

class Card {
  Card({
    this.firstSixDigits,
    this.lastFourDigits,
    this.expirationMonth,
    this.expirationYear,
    this.dateCreated,
    this.dateLastUpdated,
    this.cardholder,
  });

  int? firstSixDigits;
  int? lastFourDigits;
  int? expirationMonth;
  int? expirationYear;
  DateTime? dateCreated;
  DateTime? dateLastUpdated;
  Cardholder? cardholder;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    firstSixDigits: json["first_six_digits"],
    lastFourDigits: json["last_four_digits"],
    expirationMonth: json["expiration_month"],
    expirationYear: json["expiration_year"],
    dateCreated: DateTime.parse(json["date_created"]),
    dateLastUpdated: DateTime.parse(json["date_last_updated"]),
    cardholder: Cardholder.fromJson(json["cardholder"]),
  );

  Map<String, dynamic> toJson() => {
    "first_six_digits": firstSixDigits,
    "last_four_digits": lastFourDigits,
    "expiration_month": expirationMonth,
    "expiration_year": expirationYear,
    "date_created": dateCreated.toString(),
    "date_last_updated": dateLastUpdated.toString(),
    "cardholder": cardholder!.toJson(),
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

class FeeDetail {
  FeeDetail({
    this.type,
    this.amount,
    this.feePayer,
  });

  String? type;
  double? amount;
  String? feePayer;

  factory FeeDetail.fromJson(Map<String, dynamic> json) => FeeDetail(
    type: json["type"],
    amount: json["amount"].toDouble(),
    feePayer: json["fee_payer"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "amount": amount,
    "fee_payer": feePayer,
  };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
  );

  Map<String, dynamic> toJson() => {
  };
}

class ResponsePaymentPayer {
  ResponsePaymentPayer({
    this.id,
    this.email,
    this.identification,
    this.type,
  });

  int? id;
  String? email;
  Identification? identification;
  String? type;

  factory ResponsePaymentPayer.fromJson(Map<String, dynamic> json) => ResponsePaymentPayer(
    id: json["id"],
    email: json["email"],
    identification: Identification.fromJson(json["identification"]),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "identification": identification!.toJson(),
    "type": type,
  };
}

class PointOfInteraction {
  PointOfInteraction({
    this.type,
    this.applicationData,
    this.transactionData,
  });

  String? type;
  ApplicationData? applicationData;
  TransactionData? transactionData;

  factory PointOfInteraction.fromJson(Map<String, dynamic> json) => PointOfInteraction(
    type: json["type"],
    applicationData: ApplicationData.fromJson(json["application_data"]),
    transactionData: TransactionData.fromJson(json["transaction_data"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "application_data": applicationData!.toJson(),
    "transaction_data": transactionData!.toJson(),
  };
}

class ApplicationData {
  ApplicationData({
    this.name,
    this.version,
  });

  String? name;
  String? version;

  factory ApplicationData.fromJson(Map<String, dynamic> json) => ApplicationData(
    name: json["name"],
    version: json["version"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "version": version,
  };
}

class TransactionData {
  TransactionData({
    this.qrCodeBase64,
    this.qrCode,
  });

  String? qrCodeBase64;
  String? qrCode;

  factory TransactionData.fromJson(Map<String, dynamic> json) => TransactionData(
    qrCodeBase64: json["qr_code_base64"],
    qrCode: json["qr_code"],
  );

  Map<String, dynamic> toJson() => {
    "qr_code_base64": qrCodeBase64,
    "qr_code": qrCode,
  };
}

class TransactionDetails {
  TransactionDetails({
    this.netReceivedAmount,
    this.totalPaidAmount,
    this.overpaidAmount,
    this.installmentAmount,
  });

  double? netReceivedAmount;
  double? totalPaidAmount;
  int? overpaidAmount;
  double? installmentAmount;

  factory TransactionDetails.fromJson(Map<String, dynamic> json) => TransactionDetails(
    netReceivedAmount: json["net_received_amount"].toDouble(),
    totalPaidAmount: json["total_paid_amount"].toDouble(),
    overpaidAmount: json["overpaid_amount"],
    installmentAmount: json["installment_amount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "net_received_amount": netReceivedAmount,
    "total_paid_amount": totalPaidAmount,
    "overpaid_amount": overpaidAmount,
    "installment_amount": installmentAmount,
  };
}
