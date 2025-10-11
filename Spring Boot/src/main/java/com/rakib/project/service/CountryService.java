package com.rakib.project.service;

import com.rakib.project.dto.CountryResponseDTO;
import com.rakib.project.entity.Consumer;
import com.rakib.project.entity.Country;
import com.rakib.project.entity.Employee;
import com.rakib.project.repository.IConsumerRepo;
import com.rakib.project.repository.ICountryRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CountryService {
    @Autowired
    private IConsumerRepo consumerRepo;

    @Autowired
    private ICountryRepo countryRepository;

    public List<Country> getAllCountries() {
        return countryRepository.findAll();
    }

    public List<CountryResponseDTO> getAllCountryDTOs() {
        return getAllCountries().stream().map(c -> {
            CountryResponseDTO dto = new CountryResponseDTO();
            dto.setId(c.getId());
            dto.setName(c.getName());

            List<Integer> divisionIds = c.getDivisions().stream()
                    .map(d -> d.getId())
                    .toList();
            return dto;
        }).toList();
    }


    public Country saveCountry(Country country) {
        return countryRepository.save(country);
    }

    public void deleteById(Long id) {
        countryRepository.deleteById(id);
    }



}