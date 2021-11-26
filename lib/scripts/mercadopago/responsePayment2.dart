// To parse this JSON data, do
//
//     final responsePayment = responsePaymentFromJson(jsonString);

import 'dart:convert';

ResponsePayment2 responsePaymentFromJson(String str) => ResponsePayment2.fromJson(json.decode(str));

String? responsePaymentToJson(ResponsePayment2 data) => json.encode(data.toJson());

class ResponsePayment2 {
  ResponsePayment2({
    this.id,
    this.dateCreated,
    this.dateApproved,
    this.dateLastUpdated,
    this.dateOfExpiration,
    this.moneyReleaseDate,
    this.operationType,
    this.issuerId,
    this.paymentMethodId,
    this.paymentTypeId,
    this.status,
    this.statusDetail,
    this.currencyId,
    this.description,
    this.liveMode,
    this.sponsorId,
    this.authorizationCode,
    this.moneyReleaseSchema,
    this.taxesAmount,
    this.counterCurrency,
    this.brandId,
    this.shippingAmount,
    this.posId,
    this.storeId,
    this.integratorId,
    this.platformId,
    this.corporationId,
    this.collectorId,
    this.payer,
    this.marketplaceOwner,
    this.metadata,
    this.additionalInfo,
    this.order,
    this.externalReference,
    this.transactionAmount,
    this.transactionAmountRefunded,
    this.couponAmount,
    this.differentialPricingId,
    this.deductionSchema,
    this.installments,
    this.transactionDetails,
    this.feeDetails,
    this.chargesDetails,
    this.captured,
    this.binaryMode,
    this.callForAuthorizeId,
    this.statementDescriptor,
    this.card,
    this.notificationUrl,
    this.refunds,
    this.processingMode,
    this.merchantAccountId,
    this.merchantNumber,
    this.acquirerReconciliation,
    this.pointOfInteraction,
  });

  int? id;
  DateTime? dateCreated;
  DateTime? dateApproved;
  DateTime? dateLastUpdated;
  dynamic dateOfExpiration;
  DateTime? moneyReleaseDate;
  String? operationType;
  String? issuerId;
  String? paymentMethodId;
  String? paymentTypeId;
  String? status;
  String? statusDetail;
  String? currencyId;
  String? description;
  bool? liveMode;
  dynamic sponsorId;
  dynamic authorizationCode;
  dynamic moneyReleaseSchema;
  int? taxesAmount;
  dynamic counterCurrency;
  dynamic brandId;
  int? shippingAmount;
  dynamic posId;
  dynamic storeId;
  dynamic integratorId;
  dynamic platformId;
  dynamic corporationId;
  int? collectorId;
  ResponsePaymentPayer? payer;
  dynamic marketplaceOwner;
  Metadata? metadata;
  AdditionalInfo? additionalInfo;
  Order? order;
  String? externalReference;
  double? transactionAmount;
  int? transactionAmountRefunded;
  int? couponAmount;
  dynamic differentialPricingId;
  dynamic deductionSchema;
  int? installments;
  TransactionDetails? transactionDetails;
  List<dynamic>? feeDetails;
  List<dynamic>? chargesDetails;
  bool? captured;
  bool? binaryMode;
  dynamic callForAuthorizeId;
  String? statementDescriptor;
  Card? card;
  dynamic notificationUrl;
  List<dynamic>? refunds;
  String? processingMode;
  dynamic merchantAccountId;
  dynamic merchantNumber;
  List<dynamic>? acquirerReconciliation;
  Metadata? pointOfInteraction;

  factory ResponsePayment2.fromJson(Map<String, dynamic> json) => ResponsePayment2(
    id: json["id"],
    dateCreated: DateTime.parse(json["date_created"]),
    dateApproved: json["date_approved"] == null ? null : DateTime.parse(json["date_approved"]),
    dateLastUpdated: DateTime.parse(json["date_last_updated"]),
    dateOfExpiration: json["date_of_expiration"] == null ? null : DateTime.parse(json["date_of_expiration"]),
    moneyReleaseDate: json["money_release_date"] == null ? null : DateTime.parse(json["money_release_date"]),
    operationType: json["operation_type"],
    issuerId: json["issuer_id"],
    paymentMethodId: json["payment_method_id"],
    paymentTypeId: json["payment_type_id"],
    status: json["status"],
    statusDetail: json["status_detail"],
    currencyId: json["currency_id"],
    description: json["description"],
    liveMode: json["live_mode"],
    sponsorId: json["sponsor_id"],
    authorizationCode: json["authorization_code"],
    moneyReleaseSchema: json["money_release_schema"],
    taxesAmount: json["taxes_amount"],
    counterCurrency: json["counter_currency"],
    brandId: json["brand_id"],
    shippingAmount: json["shipping_amount"],
    posId: json["pos_id"],
    storeId: json["store_id"],
    integratorId: json["integrator_id"],
    platformId: json["platform_id"],
    corporationId: json["corporation_id"],
    collectorId: json["collector_id"],
    payer: ResponsePaymentPayer.fromJson(json["payer"]),
    marketplaceOwner: json["marketplace_owner"],
    metadata: Metadata.fromJson(json["metadata"]),
    additionalInfo: AdditionalInfo.fromJson(json["additional_info"]),
    order: Order.fromJson(json["order"]),
    externalReference: json["external_reference"],
    transactionAmount: json["transaction_amount"],
    transactionAmountRefunded: json["transaction_amount_refunded"],
    couponAmount: json["coupon_amount"],
    differentialPricingId: json["differential_pricing_id"],
    deductionSchema: json["deduction_schema"],
    installments: json["installments"],
    transactionDetails: TransactionDetails.fromJson(json["transaction_details"]),
    feeDetails: List<FeeDetail>.from(json["fee_details"].map((x) => FeeDetail.fromJson(x))),
    chargesDetails: List<dynamic>.from(json["charges_details"].map((x) => x)),
    captured: json["captured"],
    binaryMode: json["binary_mode"],
    callForAuthorizeId: json["call_for_authorize_id"],
    statementDescriptor: json["statement_descriptor"],
    card: Card.fromJson(json["card"]),
    notificationUrl: json["notification_url"],
    refunds: List<dynamic>.from(json["refunds"].map((x) => x)),
    processingMode: json["processing_mode"],
    merchantAccountId: json["merchant_account_id"],
    merchantNumber: json["merchant_number"],
    acquirerReconciliation: List<dynamic>.from(json["acquirer_reconciliation"].map((x) => x)),
    pointOfInteraction: Metadata.fromJson(json["point_of_interaction"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date_created": dateCreated.toString(),
    "date_approved": dateApproved.toString(),
    "date_last_updated": dateLastUpdated.toString(),
    "date_of_expiration": dateOfExpiration,
    "money_release_date": moneyReleaseDate.toString(),
    "operation_type": operationType,
    "issuer_id": issuerId,
    "payment_method_id": paymentMethodId,
    "payment_type_id": paymentTypeId,
    "status": status,
    "status_detail": statusDetail,
    "currency_id": currencyId,
    "description": description,
    "live_mode": liveMode,
    "sponsor_id": sponsorId,
    "authorization_code": authorizationCode,
    "money_release_schema": moneyReleaseSchema,
    "taxes_amount": taxesAmount,
    "counter_currency": counterCurrency,
    "brand_id": brandId,
    "shipping_amount": shippingAmount,
    "pos_id": posId,
    "store_id": storeId,
    "integrator_id": integratorId,
    "platform_id": platformId,
    "corporation_id": corporationId,
    "collector_id": collectorId,
    "payer": payer!.toJson(),
    "marketplace_owner": marketplaceOwner,
    "metadata": metadata!.toJson(),
    "additional_info": additionalInfo!.toJson(),
    "order": order!.toJson(),
    "external_reference": externalReference,
    "transaction_amount": transactionAmount,
    "transaction_amount_refunded": transactionAmountRefunded,
    "coupon_amount": couponAmount,
    "differential_pricing_id": differentialPricingId,
    "deduction_schema": deductionSchema,
    "installments": installments,
    "transaction_details": transactionDetails!.toJson(),
    "fee_details": List<dynamic>.from(feeDetails!.map((x) => x.toJson())),
    "charges_details": List<dynamic>.from(chargesDetails!.map((x) => x)),
    "captured": captured,
    "binary_mode": binaryMode,
    "call_for_authorize_id": callForAuthorizeId,
    "statement_descriptor": statementDescriptor,
    "card": card!.toJson(),
    "notification_url": notificationUrl,
    "refunds": List<dynamic>.from(refunds!.map((x) => x)),
    "processing_mode": processingMode,
    "merchant_account_id": merchantAccountId,
    "merchant_number": merchantNumber,
    "acquirer_reconciliation": List<dynamic>.from(acquirerReconciliation!.map((x) => x)),
    "point_of_interaction": pointOfInteraction!.toJson(),
  };
}

class AdditionalInfo {
  AdditionalInfo({
    this.items,
    this.payer,
    this.shipments,
    this.availableBalance,
    this.nsuProcessadora,
    this.authenticationCode,
  });

  List<Item>? items;
  AdditionalInfoPayer? payer;
  Shipments? shipments;
  dynamic availableBalance;
  dynamic nsuProcessadora;
  dynamic authenticationCode;

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    payer: AdditionalInfoPayer.fromJson(json["payer"]),
    shipments: Shipments.fromJson(json["shipments"]),
    availableBalance: json["available_balance"],
    nsuProcessadora: json["nsu_processadora"],
    authenticationCode: json["authentication_code"],
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items!.map((x) => x.toJson())),
    "payer": payer!.toJson(),
    "shipments": shipments!.toJson(),
    "available_balance": availableBalance,
    "nsu_processadora": nsuProcessadora,
    "authentication_code": authenticationCode,
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
  dynamic description;
  dynamic pictureUrl;
  String? categoryId;
  String? quantity;
  String? unitPrice;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    pictureUrl: json["picture_url"],
    categoryId: json["category_id"],
    quantity: json["quantity"],
    unitPrice: json["unit_price"],
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
    this.phone,
    this.firstName,
  });

  PurplePhone? phone;
  String? firstName;

  factory AdditionalInfoPayer.fromJson(Map<String, dynamic> json) => AdditionalInfoPayer(
    phone: PurplePhone.fromJson(json["phone"]),
    firstName: json["first_name"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone!.toJson(),
    "first_name": firstName,
  };
}

class PurplePhone {
  PurplePhone({
    this.areaCode,
    this.number,
  });

  String? areaCode;
  String? number;

  factory PurplePhone.fromJson(Map<String, dynamic> json) => PurplePhone(
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
    this.stateName,
    this.cityName,
    this.streetName,
    this.streetNumber,
  });

  String? stateName;
  String? cityName;
  String? streetName;
  String? streetNumber;

  factory ReceiverAddress.fromJson(Map<String, dynamic> json) => ReceiverAddress(
    stateName: json["state_name"],
    cityName: json["city_name"],
    streetName: json["street_name"],
    streetNumber: json["street_number"],
  );

  Map<String, dynamic> toJson() => {
    "state_name": stateName,
    "city_name": cityName,
    "street_name": streetName,
    "street_number": streetNumber,
  };
}

class Card {
  Card({
    this.id,
    this.firstSixDigits,
    this.lastFourDigits,
    this.expirationMonth,
    this.expirationYear,
    this.dateCreated,
    this.dateLastUpdated,
    this.cardholder,
  });

  dynamic id;
  String? firstSixDigits;
  String? lastFourDigits;
  int? expirationMonth;
  int? expirationYear;
  DateTime? dateCreated;
  DateTime? dateLastUpdated;
  Cardholder? cardholder;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    id: json["id"],
    firstSixDigits: json["first_six_digits"],
    lastFourDigits: json["last_four_digits"],
    expirationMonth: json["expiration_month"],
    expirationYear: json["expiration_year"],
    dateCreated: DateTime.parse(json["date_created"]),
    dateLastUpdated: DateTime.parse(json["date_last_updated"]),
    cardholder: Cardholder.fromJson(json["cardholder"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
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

  String?number;
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
    this.feePayer,
    this.amount,
  });

  String? type;
  String? feePayer;
  double? amount;

  factory FeeDetail.fromJson(Map<String, dynamic> json) => FeeDetail(
    type: json["type"],
    feePayer: json["fee_payer"],
    amount: json["amount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "fee_payer": feePayer,
    "amount": amount,
  };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Order {
  Order({
    this.type,
    this.id,
  });

  String? type;
  String? id;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    type: json["type"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
  };
}

class ResponsePaymentPayer {
  ResponsePaymentPayer({
    this.firstName,
    this.lastName,
    this.email,
    this.identification,
    this.phone,
    this.type,
    this.entityType,
    this.id,
  });

  dynamic firstName;
  dynamic lastName;
  String? email;
  Identification? identification;
  FluffyPhone? phone;
  dynamic type;
  dynamic entityType;
  String? id;

  factory ResponsePaymentPayer.fromJson(Map<String, dynamic> json) => ResponsePaymentPayer(
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    identification: Identification.fromJson(json["identification"]),
    phone: FluffyPhone.fromJson(json["phone"]),
    type: json["type"],
    entityType: json["entity_type"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "identification": identification!.toJson(),
    "phone": phone!.toJson(),
    "type": type,
    "entity_type": entityType,
    "id": id,
  };
}

class FluffyPhone {
  FluffyPhone({
    this.areaCode,
    this.number,
    this.extension,
  });

  dynamic areaCode;
  dynamic number;
  dynamic extension;

  factory FluffyPhone.fromJson(Map<String, dynamic> json) => FluffyPhone(
    areaCode: json["area_code"],
    number: json["number"],
    extension: json["extension"],
  );

  Map<String, dynamic> toJson() => {
    "area_code": areaCode,
    "number": number,
    "extension": extension,
  };
}

class TransactionDetails {
  TransactionDetails({
    this.paymentMethodReferenceId,
    this.netReceivedAmount,
    this.totalPaidAmount,
    this.overpaidAmount,
    this.externalResourceUrl,
    this.installmentAmount,
    this.financialInstitution,
    this.payableDeferralPeriod,
    this.acquirerReference,
  });

  dynamic paymentMethodReferenceId;
  double? netReceivedAmount;
  double? totalPaidAmount;
  int? overpaidAmount;
  dynamic externalResourceUrl;
  double? installmentAmount;
  dynamic financialInstitution;
  dynamic payableDeferralPeriod;
  dynamic acquirerReference;

  factory TransactionDetails.fromJson(Map<String, dynamic> json) => TransactionDetails(
    paymentMethodReferenceId: json["payment_method_reference_id"],
    netReceivedAmount: json["net_received_amount"].toDouble(),
    totalPaidAmount: json["total_paid_amount"].toDouble(),
    overpaidAmount: json["overpaid_amount"],
    externalResourceUrl: json["external_resource_url"],
    installmentAmount: json["installment_amount"].toDouble(),
    financialInstitution: json["financial_institution"],
    payableDeferralPeriod: json["payable_deferral_period"],
    acquirerReference: json["acquirer_reference"],
  );

  Map<String, dynamic> toJson() => {
    "payment_method_reference_id": paymentMethodReferenceId,
    "net_received_amount": netReceivedAmount,
    "total_paid_amount": totalPaidAmount,
    "overpaid_amount": overpaidAmount,
    "external_resource_url": externalResourceUrl,
    "installment_amount": installmentAmount,
    "financial_institution": financialInstitution,
    "payable_deferral_period": payableDeferralPeriod,
    "acquirer_reference": acquirerReference,
  };
}
