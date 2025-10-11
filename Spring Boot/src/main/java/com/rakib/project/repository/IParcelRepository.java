package com.rakib.project.repository;

import com.rakib.project.dto.ParcelResponseDTO;
import com.rakib.project.entity.Parcel;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface IParcelRepository extends JpaRepository<Parcel, Long> {


    Optional<Parcel> findByTrackingId(String trackingId);

    List<Parcel> findParcelByTrackingId(String trackingId);

    List<Parcel> findByConsumerId(Long consumerId);

    // consumerId দিয়ে সব parcel বের করবে
    @Query("SELECT p FROM Parcel p WHERE p.consumer.id = :consumerId")
    List<Parcel> findAllByConsumerId(@Param("consumerId") Long consumerId);





}
