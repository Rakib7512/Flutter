package com.rakib.project.repository;

import com.rakib.project.entity.Division;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IDivisionRepo extends JpaRepository<Division,Integer> {
    // IDivisionRepo
    List<Division> findByCountryId(Integer id);
}
