package com.rakib.project.repository;

import com.rakib.project.entity.ParcelTracking;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IParcelTrackingRepository extends JpaRepository<ParcelTracking, Long> {




    List<ParcelTracking> findByParcelIdOrderByTimestampAsc(Long parcelId);


}
