package com.rakib.project.dto;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class ParcelResponseDTO {


    private Long id;
    private String trackingId;
    private String senderName;
    private String senderPhone;
    private String receiverName;
    private String receiverPhone;

    private String addressLineForSender1;
    private String addressLineForSender2;
    private String addressLineForReceiver1;
    private String addressLineForReceiver2;

    private String previousHub;
    private String currentHub;
    private String toHub;

    private String size;
    private int fee;
    private String verificationCode;

    private Date createdAt;
    private Date bookingDate;
    private String status;

    private long pickupDeliveryManId;
    private long deliveryManId;
    private  String delevaryManName;
    private int bookingAgentId;

    //  এখন nested DTO
    private LocationResponseDTO sendCountry;
    private LocationResponseDTO sendDivision;
    private LocationResponseDTO sendDistrict;
    private LocationResponseDTO sendPoliceStation;

    private LocationResponseDTO receiveCountry;
    private LocationResponseDTO receiveDivision;
    private LocationResponseDTO receiveDistrict;
    private LocationResponseDTO receivePoliceStation;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTrackingId() {
        return trackingId;
    }

    public void setTrackingId(String trackingId) {
        this.trackingId = trackingId;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getSenderPhone() {
        return senderPhone;
    }

    public void setSenderPhone(String senderPhone) {
        this.senderPhone = senderPhone;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getReceiverPhone() {
        return receiverPhone;
    }

    public void setReceiverPhone(String receiverPhone) {
        this.receiverPhone = receiverPhone;
    }

    public String getAddressLineForSender1() {
        return addressLineForSender1;
    }

    public void setAddressLineForSender1(String addressLineForSender1) {
        this.addressLineForSender1 = addressLineForSender1;
    }

    public String getAddressLineForSender2() {
        return addressLineForSender2;
    }

    public void setAddressLineForSender2(String addressLineForSender2) {
        this.addressLineForSender2 = addressLineForSender2;
    }

    public String getAddressLineForReceiver1() {
        return addressLineForReceiver1;
    }

    public void setAddressLineForReceiver1(String addressLineForReceiver1) {
        this.addressLineForReceiver1 = addressLineForReceiver1;
    }

    public String getAddressLineForReceiver2() {
        return addressLineForReceiver2;
    }

    public void setAddressLineForReceiver2(String addressLineForReceiver2) {
        this.addressLineForReceiver2 = addressLineForReceiver2;
    }

    public String getPreviousHub() {
        return previousHub;
    }

    public void setPreviousHub(String previousHub) {
        this.previousHub = previousHub;
    }

    public String getCurrentHub() {
        return currentHub;
    }

    public void setCurrentHub(String currentHub) {
        this.currentHub = currentHub;
    }

    public String getToHub() {
        return toHub;
    }

    public void setToHub(String toHub) {
        this.toHub = toHub;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public int getFee() {
        return fee;
    }

    public void setFee(int fee) {
        this.fee = fee;
    }

    public String getVerificationCode() {
        return verificationCode;
    }

    public void setVerificationCode(String verificationCode) {
        this.verificationCode = verificationCode;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public long getPickupDeliveryManId() {
        return pickupDeliveryManId;
    }

    public void setPickupDeliveryManId(long pickupDeliveryManId) {
        this.pickupDeliveryManId = pickupDeliveryManId;
    }

    public long getDeliveryManId() {
        return deliveryManId;
    }

    public void setDeliveryManId(long deliveryManId) {
        this.deliveryManId = deliveryManId;
    }

    public int getBookingAgentId() {
        return bookingAgentId;
    }

    public void setBookingAgentId(int bookingAgentId) {
        this.bookingAgentId = bookingAgentId;
    }

    public LocationResponseDTO getSendCountry() {
        return sendCountry;
    }

    public void setSendCountry(LocationResponseDTO sendCountry) {
        this.sendCountry = sendCountry;
    }

    public LocationResponseDTO getSendDivision() {
        return sendDivision;
    }

    public void setSendDivision(LocationResponseDTO sendDivision) {
        this.sendDivision = sendDivision;
    }

    public LocationResponseDTO getSendDistrict() {
        return sendDistrict;
    }

    public void setSendDistrict(LocationResponseDTO sendDistrict) {
        this.sendDistrict = sendDistrict;
    }

    public LocationResponseDTO getSendPoliceStation() {
        return sendPoliceStation;
    }

    public void setSendPoliceStation(LocationResponseDTO sendPoliceStation) {
        this.sendPoliceStation = sendPoliceStation;
    }

    public LocationResponseDTO getReceiveCountry() {
        return receiveCountry;
    }

    public void setReceiveCountry(LocationResponseDTO receiveCountry) {
        this.receiveCountry = receiveCountry;
    }

    public LocationResponseDTO getReceiveDivision() {
        return receiveDivision;
    }

    public void setReceiveDivision(LocationResponseDTO receiveDivision) {
        this.receiveDivision = receiveDivision;
    }

    public LocationResponseDTO getReceiveDistrict() {
        return receiveDistrict;
    }

    public void setReceiveDistrict(LocationResponseDTO receiveDistrict) {
        this.receiveDistrict = receiveDistrict;
    }

    public LocationResponseDTO getReceivePoliceStation() {
        return receivePoliceStation;
    }

    public void setReceivePoliceStation(LocationResponseDTO receivePoliceStation) {
        this.receivePoliceStation = receivePoliceStation;
    }


    public String getDelevaryManName() {
        return delevaryManName;
    }

    public void setDelevaryManName(String delevaryManName) {
        this.delevaryManName = delevaryManName;
    }
}