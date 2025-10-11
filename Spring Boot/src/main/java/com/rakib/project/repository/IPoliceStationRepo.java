package com.rakib.project.repository;

import com.rakib.project.entity.PoliceStation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IPoliceStationRepo extends JpaRepository<PoliceStation,Integer> {
    // IPoliceStationRepo
    List<PoliceStation> findByDistrictId(Integer districtId);

}
