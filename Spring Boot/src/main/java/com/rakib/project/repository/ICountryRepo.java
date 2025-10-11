package com.rakib.project.repository;

import com.rakib.project.entity.Country;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ICountryRepo extends JpaRepository<Country,Long> {
}
