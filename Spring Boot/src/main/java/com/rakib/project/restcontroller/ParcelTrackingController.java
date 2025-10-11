package com.rakib.project.restcontroller;

import com.rakib.project.entity.ParcelTracking;
import com.rakib.project.service.ParcelTrackingService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

public class ParcelTrackingController {
    private final ParcelTrackingService trackingService;

    public ParcelTrackingController(ParcelTrackingService trackingService) {
        this.trackingService = trackingService;
    }

    @PostMapping("/{parcelId}")
    public ParcelTracking addTracking(@PathVariable Long parcelId, @RequestBody ParcelTracking tracking) {
        return trackingService.addTrackingToParcel(parcelId, tracking);
    }

    @GetMapping("/{parcelId}")
    public List<ParcelTracking> getTracking(@PathVariable Long parcelId) {
        return trackingService.getTrackingForParcel(parcelId);
    }

    @DeleteMapping("/{parcelId}/{trackingId}")
    public void deleteTracking(@PathVariable Long parcelId, @PathVariable Long trackingId) {
        trackingService.removeTracking(parcelId, trackingId);
    }
}

