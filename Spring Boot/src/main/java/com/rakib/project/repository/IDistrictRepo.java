package com.rakib.project.repository;

import com.rakib.project.entity.District;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface IDistrictRepo extends JpaRepository<District,Integer> {

    public District findByName(String name);


    // IDistrictRepo
    List<District> findByDivisionId(int divisionId);
}
