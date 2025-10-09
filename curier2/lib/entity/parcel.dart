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

  final int sendCountry;
  final int sendDivision;
  final int sendDistrict;
  final int sendPoliceStation;

  final int receiveCountry;
  final int receiveDivision;
  final int receiveDistrict;
  final int receivePoliceStation;

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
    required this.sendCountry,
    required this.sendDivision,
    required this.sendDistrict,
    required this.sendPoliceStation,
    required this.receiveCountry,
    required this.receiveDivision,
    required this.receiveDistrict,
    required this.receivePoliceStation,
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

      "countrySender": {"id": sendCountry},
      "divisionSender": {"id": sendDivision},
      "districtSender": {"id": sendDistrict},
      "policeStationSender": {"id": sendPoliceStation},

      "countryReceiver": {"id": receiveCountry},
      "divisionReceiver": {"id": receiveDivision},
      "districtReceiver": {"id": receiveDistrict},
      "policeStationReceiver": {"id": receivePoliceStation},
      "size": size,
      "fee": fee,
    };
  }



  @override
  String toString() {
    return '''
Parcel:
  Sender: $senderName, Phone: $senderPhone
  Receiver: $receiverName, Phone: $receiverPhone
  Sender Address: $addressLineForSender1, $addressLineForSender2
  Receiver Address: $addressLineForReceiver1, $addressLineForReceiver2
  Sender Location IDs: Country $sendCountry, Division $sendDivision, District $sendDistrict, PoliceStation $sendPoliceStation
  Receiver Location IDs: Country $receiveCountry, Division $receiveDivision, District $receiveDistrict, PoliceStation $receivePoliceStation
  Tracking ID: $trackingId
}
  Size: $size
  Fee: $fee
''';
  }


}
