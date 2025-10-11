package com.rakib.project.service;

import com.rakib.project.entity.Parcel;
import com.rakib.project.entity.ParcelTracking;
import com.rakib.project.repository.IParcelRepository;
import com.rakib.project.repository.IParcelTrackingRepository;

import java.util.List;

public class ParcelTrackingService {
    private final IParcelRepository parcelRepository;
    private final IParcelTrackingRepository trackingRepository;

    public ParcelTrackingService(IParcelRepository parcelRepository, IParcelTrackingRepository trackingRepository) {
        this.parcelRepository = parcelRepository;
        this.trackingRepository = trackingRepository;
    }

    public ParcelTracking addTrackingToParcel(Long parcelId, ParcelTracking tracking) {
        Parcel parcel = parcelRepository.findById(parcelId)
                .orElseThrow(() -> new RuntimeException("Parcel not found"));
        tracking.setParcel(parcel);
        return trackingRepository.save(tracking);
    }

    public List<ParcelTracking> getTrackingForParcel(Long parcelId) {
        Parcel parcel = parcelRepository.findById(parcelId)
                .orElseThrow(() -> new RuntimeException("Parcel not found"));
        return parcel.getTrackingHistory();
    }

    public void removeTracking(Long parcelId, Long trackingId) {
        ParcelTracking tracking = trackingRepository.findById(trackingId)
                .orElseThrow(() -> new RuntimeException("Tracking not found"));

        if (!tracking.getParcel().getId().equals(parcelId)) {
            throw new RuntimeException("Tracking does not belong to this parcel");
        }
        trackingRepository.delete(tracking);
    }
}
