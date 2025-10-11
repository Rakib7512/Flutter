package com.rakib.project.dto;

import java.util.Date;

public class NotificationResponseDTO {

    private Long id;
    private String message;
    private Date createdAt;
    private boolean received;

    // Employee Basic Info (only what frontend needs)
    private Long employeeId;
    private String employeeName;

    public NotificationResponseDTO() {
    }

    public NotificationResponseDTO(Long id, String message, Date createdAt, boolean received, Long employeeId, String employeeName) {
        this.id = id;
        this.message = message;
        this.createdAt = createdAt;
        this.received = received;
        this.employeeId = employeeId;
        this.employeeName = employeeName;
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isReceived() {
        return received;
    }

    public void setReceived(boolean received) {
        this.received = received;
    }

    public Long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(Long employeeId) {
        this.employeeId = employeeId;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }


}
