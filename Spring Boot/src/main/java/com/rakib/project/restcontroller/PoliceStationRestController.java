package com.rakib.project.restcontroller;


import com.rakib.project.dto.PoliceStationResponseDTO;
import com.rakib.project.entity.PoliceStation;
import com.rakib.project.service.PoliceStationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/policestation/")
public class PoliceStationRestController {

    @Autowired
    private PoliceStationService policeStationService;

    @GetMapping("")
    public List<PoliceStationResponseDTO> getAll() {
        return policeStationService.getAllPoliceStationsDTOs();
    }

    @PostMapping("")
    public PoliceStation save(@RequestBody PoliceStation ps) {
        return policeStationService.saveOrUpdate(ps);
    }

    @GetMapping("/{id}")
    public List<PoliceStationResponseDTO> getOne(@PathVariable Integer id) {
        return policeStationService.findById(id);
    }

    @DeleteMapping("/{id}")
    public void deleteById(@PathVariable Integer id) {
        policeStationService.deleteById(id);
    }

    @PutMapping("{id}")
    public PoliceStation update(@PathVariable Integer id, @RequestBody PoliceStation ps) {
        return policeStationService.update(id, ps);
    }


    // PoliceStationRestController
    @GetMapping("/by-district/{districtId}")
    public List<PoliceStationResponseDTO> getByDistrict(@PathVariable int districtId) {
        return policeStationService.getByDistrictId(districtId);
    }


}