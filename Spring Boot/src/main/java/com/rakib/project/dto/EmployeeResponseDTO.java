package com.rakib.project.dto;

import com.rakib.project.entity.Employee;

import java.util.Date;

public class EmployeeResponseDTO {
    private Long id;
    private String name;
    private String email;
    private String gender;
    private String nid;
    private String address;
    private String designation;
    private Date joindate;
    private String phone;
    private float salary;
    private String photo;
    private String empOnHub;

    // Instead of returning full objects, we will return only their IDs


    private CountryResponseDTO countryId;
    private DivisionResponseDTO divisionId;
    private DistrictResponseDTO districtId;
    private PoliceStationResponseDTO policeStationId;
    private UserDto userId;


    public EmployeeResponseDTO() {
    }

    public EmployeeResponseDTO(Long id, String name, String email, String gender, String nid, String address, String designation, Date joindate, String phone, float salary, String photo, String empOnHub, CountryResponseDTO countryId, DivisionResponseDTO divisionId, DistrictResponseDTO districtId, PoliceStationResponseDTO policeStationId, UserDto userId) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.gender = gender;
        this.nid = nid;
        this.address = address;
        this.designation = designation;
        this.joindate = joindate;
        this.phone = phone;
        this.salary = salary;
        this.photo = photo;
        this.empOnHub = empOnHub;
        this.countryId = countryId;
        this.divisionId = divisionId;
        this.districtId = districtId;
        this.policeStationId = policeStationId;
        this.userId = userId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getNid() {
        return nid;
    }

    public void setNid(String nid) {
        this.nid = nid;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public Date getJoindate() {
        return joindate;
    }

    public void setJoindate(Date joindate) {
        this.joindate = joindate;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public float getSalary() {
        return salary;
    }

    public void setSalary(float salary) {
        this.salary = salary;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String getEmpOnHub() {
        return empOnHub;
    }

    public void setEmpOnHub(String empOnHub) {
        this.empOnHub = empOnHub;
    }

    public CountryResponseDTO getCountryId() {
        return countryId;
    }

    public void setCountryId(CountryResponseDTO countryId) {
        this.countryId = countryId;
    }

    public DivisionResponseDTO getDivisionId() {
        return divisionId;
    }

    public void setDivisionId(DivisionResponseDTO divisionId) {
        this.divisionId = divisionId;
    }

    public DistrictResponseDTO getDistrictId() {
        return districtId;
    }

    public void setDistrictId(DistrictResponseDTO districtId) {
        this.districtId = districtId;
    }

    public PoliceStationResponseDTO getPoliceStationId() {
        return policeStationId;
    }

    public void setPoliceStationId(PoliceStationResponseDTO policeStationId) {
        this.policeStationId = policeStationId;
    }

    public UserDto getUserId() {
        return userId;
    }

    public void setUserId(UserDto userId) {
        this.userId = userId;
    }
}