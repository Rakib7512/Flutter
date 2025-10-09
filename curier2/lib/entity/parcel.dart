import 'package:uuid/uuid.dart';

class Parcel {
  String? trackingId;
  String? senderName;
  String? receiverName;
  String? senderPhone;
  String? receiverPhone;
  String? addressLineForSender1;
  String? addressLineForSender2;
  String? addressLineForReceiver1;
  String? addressLineForReceiver2;

  final int senderCountryId;
  final int senderDivisionId;
  final int senderDistrictId;
  final int senderPoliceStationId;
  final int receiverCountryId;
  final int receiverDivisionId;
  final int receiverDistrictId;
  final int receiverPoliceStationId;

  String? size;
  int? fee;

  Parcel({
    this.trackingId,
    this.senderName,
    this.receiverName,
    this.senderPhone,
    this.receiverPhone,
    this.addressLineForSender1,
    this.addressLineForSender2,
    this.addressLineForReceiver1,
    this.addressLineForReceiver2,
    required this.senderCountryId,
    required this.senderDivisionId,
    required this.senderDistrictId,
    required this.senderPoliceStationId,
    required this.receiverCountryId,
    required this.receiverDivisionId,
    required this.receiverDistrictId,
    required this.receiverPoliceStationId,
    this.size,
    this.fee,
  }) {
    // Generate a tracking ID automatically if not provided
    trackingId ??= const Uuid().v4();
  }

  Map<String, dynamic> toJson() {
    return {
      "trackingId": trackingId,
      "senderName": senderName,
      "receiverName": receiverName,
      "senderPhone": senderPhone,
      "receiverPhone": receiverPhone,
      "addressLineForSender1": addressLineForSender1,
      "addressLineForSender2": addressLineForSender2,
      "addressLineForReceiver1": addressLineForReceiver1,
      "addressLineForReceiver2": addressLineForReceiver2,
      "countrySender": {"id": senderCountryId},
      "divisionSender": {"id": senderDivisionId},
      "districtSender": {"id": senderDistrictId},
      "policeStationSender": {"id": senderPoliceStationId},
      "countryReceiver": {"id": receiverCountryId},
      "divisionReceiver": {"id": receiverDivisionId},
      "districtReceiver": {"id": receiverDistrictId},
      "policeStationReceiver": {"id": receiverPoliceStationId},
      "size": size,
      "fee": fee,
    };
  }
}
