package com.rakib.project.dto;

import com.rakib.project.entity.ParcelStatus;
import com.rakib.project.entity.ParcelTracking;

import java.util.Date;

public class ParcelTrackingDTO {


    private Long id;
    private String hubName;
    private ParcelStatus status;
    private String handledBy; // employee name if needed
    private Date timestamp;

    public ParcelTrackingDTO(ParcelTracking t) {
        this.id = t.getId();
        this.hubName = t.getHubName();
        this.status = t.getStatus();
        this.handledBy = t.getHandledBy() != null ? t.getHandledBy().getName() : null;
        this.timestamp = t.getTimestamp();
    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getHubName() {
        return hubName;
    }

    public void setHubName(String hubName) {
        this.hubName = hubName;
    }

    public ParcelStatus getStatus() {
        return status;
    }

    public void setStatus(ParcelStatus status) {
        this.status = status;
    }

    public String getHandledBy() {
        return handledBy;
    }

    public void setHandledBy(String handledBy) {
        this.handledBy = handledBy;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }
}
