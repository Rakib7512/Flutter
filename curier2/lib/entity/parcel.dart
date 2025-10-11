class Parcel {
  final String senderName;
  final String senderPhone;
  final String receiverName;
  final String receiverPhone;
  final String addressLineForSender1;
  final String addressLineForSender2;
  final String addressLineForReceiver1;
  final String addressLineForReceiver2;
  final Map<String, dynamic> sendCountry;
  final Map<String, dynamic> sendDivision;
  final Map<String, dynamic> sendDistrict;
  final Map<String, dynamic> sendPoliceStation;
  final Map<String, dynamic> receiveCountry;
  final Map<String, dynamic> receiveDivision;
  final Map<String, dynamic> receiveDistrict;
  final Map<String, dynamic> receivePoliceStation;
  final Map<String, dynamic>? consumer;
  final String trackingId;
  final String size;
  final int fee;

  Parcel({
    required this.senderName,
    required this.senderPhone,
    required this.receiverName,
    required this.receiverPhone,
    required this.addressLineForSender1,
    required this.addressLineForSender2,
    required this.addressLineForReceiver1,
    required this.addressLineForReceiver2,
    required this.sendCountry,
    required this.sendDivision,
    required this.sendDistrict,
    required this.sendPoliceStation,
    required this.receiveCountry,
    required this.receiveDivision,
    required this.receiveDistrict,
    required this.receivePoliceStation,
    this.consumer,
    required this.trackingId,
    required this.size,
    required this.fee,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderName': senderName,
      'senderPhone': senderPhone,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'addressLineForSender1': addressLineForSender1,
      'addressLineForSender2': addressLineForSender2,
      'addressLineForReceiver1': addressLineForReceiver1,
      'addressLineForReceiver2': addressLineForReceiver2,
      'sendCountry': sendCountry,
      'sendDivision': sendDivision,
      'sendDistrict': sendDistrict,
      'sendPoliceStation': sendPoliceStation,
      'receiveCountry': receiveCountry,
      'receiveDivision': receiveDivision,
      'receiveDistrict': receiveDistrict,
      'receivePoliceStation': receivePoliceStation,
      'trackingId': trackingId,
      'size': size,
      'fee': fee,
      'consumer': consumer,
    };
  }
}
