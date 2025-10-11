package com.rakib.project.service;




import com.rakib.project.dto.*;
import com.rakib.project.entity.*;
import com.rakib.project.repository.IEmployeeRepo;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;
@Service
public class EmployeeService {
    @Autowired
    private IEmployeeRepo employeeRepository;

    public List<Employee> getAll() {
        return employeeRepository.findAll();
    }

    public Optional<Employee> getById(Long id) {
        return employeeRepository.findById(id);
    }

    public Employee save(Employee employee) {
        return employeeRepository.save(employee);
    }

    public void delete(Long id) {
        employeeRepository.deleteById(id);
    }

    // public Employee getProfileByUserId(int userId) {
    //     return employeeRepository.findByUserId(userId)
    //             .orElseThrow(() -> new RuntimeException("Job Seeker not found"));
    // }



    public EmployeeResponseDTO getProfileByUserId(int userId) {
        Employee employee = employeeRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Employee not found"));

        // Convert Employee entity to EmployeeResponseDTO using setter style
        EmployeeResponseDTO dto = new EmployeeResponseDTO();
        dto.setId(employee.getId());
        dto.setName(employee.getName());
        dto.setEmail(employee.getEmail());
        dto.setGender(employee.getGender());
        dto.setNid(employee.getNid());
        dto.setAddress(employee.getAddress());
        dto.setDesignation(employee.getDesignation());
        dto.setJoindate(employee.getJoindate());
        dto.setPhone(employee.getPhone());
        dto.setSalary(employee.getSalary());
        dto.setPhoto(employee.getPhoto());
        dto.setEmpOnHub(employee.getEmpOnHub());

        if (employee.getCountry() != null) {
            CountryResponseDTO country = new CountryResponseDTO();
            country.setId(employee.getCountry().getId());
            country.setName(employee.getCountry().getName());
            dto.setCountryId(country);
        }

        if (employee.getDivision() != null) {
            DivisionResponseDTO division = new DivisionResponseDTO();
            division.setId(employee.getDivision().getId());
            division.setName(employee.getDivision().getName());
            dto.setDivisionId(division);
        }

        if (employee.getDistrict() != null) {
            DistrictResponseDTO district = new DistrictResponseDTO();
            district.setId(employee.getDistrict().getId());
            district.setName(employee.getDistrict().getName());
            dto.setDistrictId(district);
        }

        if (employee.getPoliceStation() != null) {
            PoliceStationResponseDTO ps = new PoliceStationResponseDTO();
            ps.setId(employee.getPoliceStation().getId());
            ps.setName(employee.getPoliceStation().getName());
            dto.setPoliceStationId(ps);
        }

        if (employee.getUser() != null) {
            UserDto userDto = new UserDto();
            userDto.setId(employee.getUser().getId());
            userDto.setName(employee.getUser().getName());
            userDto.setEmail(employee.getUser().getEmail());
            dto.setUserId(userDto);
        }

        return dto;
    }





    public List<EmployeeResponseDTO> getAllAttendanceResponseDTOS() {
        return employeeRepository.findAll().stream().map(atten -> {
            EmployeeResponseDTO dto = new EmployeeResponseDTO();
            dto.setId(atten.getId());
            dto.setName(atten.getName());
            dto.setEmail(atten.getEmail());
            dto.setPhone(atten.getPhone());
            dto.setGender(atten.getGender());
            dto.setNid(atten.getNid());
            dto.setAddress(atten.getAddress());
            dto.setDesignation(atten.getDesignation());
            dto.setJoindate(atten.getJoindate());
            dto.setSalary(atten.getSalary());
            dto.setPhoto(atten.getPhoto());
            dto.setEmpOnHub(atten.getEmpOnHub());

            Country country = atten.getCountry();
            if (country != null) {
                System.out.println("Country Name: " + country.getName()); // Add this line
                CountryResponseDTO countryResponseDTO = new CountryResponseDTO();
                countryResponseDTO.setId(country.getId());
                countryResponseDTO.setName(country.getName());
                dto.setCountryId(countryResponseDTO);
            }

            Division division = atten.getDivision();
            if (division != null) {
                DivisionResponseDTO divisionResponseDTO = new DivisionResponseDTO();
                divisionResponseDTO.setId(division.getId());
                divisionResponseDTO.setName(division.getName()); // ✅ Fix here
                dto.setDivisionId(divisionResponseDTO);
            }


            District district = atten.getDistrict();
            if (district != null) {
                DistrictResponseDTO districtResponseDTO = new DistrictResponseDTO();
                districtResponseDTO.setId(district.getId()); // ✅ Fix here (was using division.getId())
                districtResponseDTO.setName(district.getName()); // ✅ Fix here
                dto.setDistrictId(districtResponseDTO);
            }

            PoliceStation policeStation = atten.getPoliceStation();
            if (policeStation != null) {
                PoliceStationResponseDTO policeDTO = new PoliceStationResponseDTO();
                policeDTO.setId(policeStation.getId());
                policeDTO.setName(policeStation.getName()); // ✅ Fix here
                dto.setPoliceStationId(policeDTO);
            }



            return dto;
        }).toList();
    }


    public Long getEmployeeIdByEmail(String email) {
        return employeeRepository.findByUserEmail(email)
                .map(Employee::getId)
                .orElse(null);
    }



}