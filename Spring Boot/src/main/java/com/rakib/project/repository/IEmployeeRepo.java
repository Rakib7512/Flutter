package com.rakib.project.repository;

import com.rakib.project.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface IEmployeeRepo extends JpaRepository<Employee, Long> {
    Optional<Employee> findByUserId(int userId);

    @Query("SELECT js FROM Employee js WHERE js.user.email = :email")
    Optional<Employee> findByUserEmail(@Param("email") String email);


    List<Employee> findByCountryAndDivisionAndDistrictAndPoliceStation(
            Country country, Division division, District district, PoliceStation policeStation
    );



    @Query("SELECT e.id FROM Employee e WHERE e.user.email = :email")
    Optional<Long> findEmployeeIdByUserEmail(@Param("email") String email);





}
