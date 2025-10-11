package com.rakib.project.dto;


import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class ParcelDto {

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
    private int pickupDeliveryManId;
    private int deliveryManId;
    private int bookingAgentId;
    private int sendCountryId;
    private int sendDivisionId;
    private int sendDistrictId;
    private int sendPoliceStationId;
    private int receiveCountryId;
    private int receiveDivisionId;
    private int receiveDistrictId;
    private int receivePoliceStationId;

    public ParcelDto() {
    }

    public ParcelDto(Long id, String trackingId, String senderName, String senderPhone, String receiverName, String receiverPhone, String addressLineForSender1, String addressLineForSender2, String addressLineForReceiver1, String addressLineForReceiver2, String previousHub, String currentHub, String toHub, String size, int fee, String verificationCode, Date createdAt, Date bookingDate, String status, int pickupDeliveryManId, int deliveryManId, int bookingAgentId, int sendCountryId, int sendDivisionId, int sendDistrictId, int sendPoliceStationId, int receiveCountryId, int receiveDivisionId, int receiveDistrictId, int receivePoliceStationId) {
        this.id = id;
        this.trackingId = trackingId;
        this.senderName = senderName;
        this.senderPhone = senderPhone;
        this.receiverName = receiverName;
        this.receiverPhone = receiverPhone;
        this.addressLineForSender1 = addressLineForSender1;
        this.addressLineForSender2 = addressLineForSender2;
        this.addressLineForReceiver1 = addressLineForReceiver1;
        this.addressLineForReceiver2 = addressLineForReceiver2;
        this.previousHub = previousHub;
        this.currentHub = currentHub;
        this.toHub = toHub;
        this.size = size;
        this.fee = fee;
        this.verificationCode = verificationCode;
        this.createdAt = createdAt;
        this.bookingDate = bookingDate;
        this.status = status;
        this.pickupDeliveryManId = pickupDeliveryManId;
        this.deliveryManId = deliveryManId;
        this.bookingAgentId = bookingAgentId;
        this.sendCountryId = sendCountryId;
        this.sendDivisionId = sendDivisionId;
        this.sendDistrictId = sendDistrictId;
        this.sendPoliceStationId = sendPoliceStationId;
        this.receiveCountryId = receiveCountryId;
        this.receiveDivisionId = receiveDivisionId;
        this.receiveDistrictId = receiveDistrictId;
        this.receivePoliceStationId = receivePoliceStationId;
    }

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

    public int getPickupDeliveryManId() {
        return pickupDeliveryManId;
    }

    public void setPickupDeliveryManId(int pickupDeliveryManId) {
        this.pickupDeliveryManId = pickupDeliveryManId;
    }

    public int getDeliveryManId() {
        return deliveryManId;
    }

    public void setDeliveryManId(int deliveryManId) {
        this.deliveryManId = deliveryManId;
    }

    public int getBookingAgentId() {
        return bookingAgentId;
    }

    public void setBookingAgentId(int bookingAgentId) {
        this.bookingAgentId = bookingAgentId;
    }

    public int getSendCountryId() {
        return sendCountryId;
    }

    public void setSendCountryId(int sendCountryId) {
        this.sendCountryId = sendCountryId;
    }

    public int getSendDivisionId() {
        return sendDivisionId;
    }

    public void setSendDivisionId(int sendDivisionId) {
        this.sendDivisionId = sendDivisionId;
    }

    public int getSendDistrictId() {
        return sendDistrictId;
    }

    public void setSendDistrictId(int sendDistrictId) {
        this.sendDistrictId = sendDistrictId;
    }

    public int getSendPoliceStationId() {
        return sendPoliceStationId;
    }

    public void setSendPoliceStationId(int sendPoliceStationId) {
        this.sendPoliceStationId = sendPoliceStationId;
    }

    public int getReceiveCountryId() {
        return receiveCountryId;
    }

    public void setReceiveCountryId(int receiveCountryId) {
        this.receiveCountryId = receiveCountryId;
    }

    public int getReceiveDivisionId() {
        return receiveDivisionId;
    }

    public void setReceiveDivisionId(int receiveDivisionId) {
        this.receiveDivisionId = receiveDivisionId;
    }

    public int getReceiveDistrictId() {
        return receiveDistrictId;
    }

    public void setReceiveDistrictId(int receiveDistrictId) {
        this.receiveDistrictId = receiveDistrictId;
    }

    public int getReceivePoliceStationId() {
        return receivePoliceStationId;
    }

    public void setReceivePoliceStationId(int receivePoliceStationId) {
        this.receivePoliceStationId = receivePoliceStationId;
    }


}
