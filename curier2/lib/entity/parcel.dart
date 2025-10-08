class Parcel {
  String? senderName;
  String? receiverName;
  String? senderPhone;
  String? receiverPhone;
  String? addressLineForSender1;
  String? addressLineForReceiver1;
  String? size;
  int? fee;

  Parcel({
    this.senderName,
    this.receiverName,
    this.senderPhone,
    this.receiverPhone,
    this.addressLineForSender1,
    this.addressLineForReceiver1,
    this.size,
    this.fee,
  });

  Map<String, dynamic> toJson() {
    return {
      "senderName": senderName,
      "receiverName": receiverName,
      "senderPhone": senderPhone,
      "receiverPhone": receiverPhone,
      "addressLineForSender1": addressLineForSender1,
      "addressLineForReceiver1": addressLineForReceiver1,
      "size": size,
      "fee": fee,
    };
  }
}
