package com.rakib.project.restcontroller;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.rakib.project.dto.AuthenticationResponse;
import com.rakib.project.dto.ConsumerResponseDTO;
import com.rakib.project.dto.EmployeeResponseDTO;
import com.rakib.project.dto.ParcelResponseDTO;
import com.rakib.project.entity.Consumer;
import com.rakib.project.entity.Employee;
import com.rakib.project.entity.User;
import com.rakib.project.repository.IUserRepo;
import com.rakib.project.service.ConsumerService;
import com.rakib.project.service.ParcelService;
import com.rakib.project.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/consumer/")

public class ConsumerRestController {

    @Autowired
    private IUserRepo  userRepo;

    @Autowired
    private UserService userService;

    @Autowired
    private ConsumerService consumerService;
    @Autowired
    private ParcelService parcelService;

    @PostMapping("")
    public ResponseEntity<Map<String, String>> registerJobSeeker(
            @RequestPart(value = "user") String userJson,
            @RequestPart(value = "consumer") String consumerJson,
            @RequestParam(value = "photo") MultipartFile file
    ) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        User user = objectMapper.readValue(userJson, User.class);
        Consumer consumer = objectMapper.readValue(consumerJson, Consumer.class);

        try {
            userService.registerConsumer(user, file, consumer);
            Map<String, String> response = new HashMap<>();
            response.put("Message", "User Added Successfully ");

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {

            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("Message", "User Add Faild " + e);
            return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
        }


    }


    @GetMapping("all")
    public ResponseEntity<List<Consumer>> getAllUsers() {
        List<Consumer> consumerList = consumerService.getAll();
        return ResponseEntity.ok(consumerList);

    }


    @GetMapping("/profile")
    public ResponseEntity<ConsumerResponseDTO> getProfile(Authentication authentication) {
        System.out.println("Authenticated User: " + authentication.getName());
        System.out.println("Authorities: " + authentication.getAuthorities());
        String email = authentication.getName();
        ConsumerResponseDTO consumer = mapToDTO(consumerService.findByEmail(email));
        return new ResponseEntity<>(consumer, HttpStatus.OK);

    }

    public ConsumerResponseDTO mapToDTO(Consumer consumer) {
        ConsumerResponseDTO dto = new ConsumerResponseDTO();
        dto.setId(consumer.getId());
        dto.setName(consumer.getName());
        dto.setEmail(consumer.getEmail());
        dto.setPhone(consumer.getPhone());
        dto.setGender(consumer.getGender());
        dto.setAddress(consumer.getAddress());
        dto.setNid(consumer.getNid());
        dto.setPhoto(consumer.getPhoto());
        return dto;
    }



    @GetMapping("my-id")
    public ResponseEntity<Long> getLoggedInConsumerId(Authentication authentication) {
        String email = authentication.getName(); // Spring Security sets this to username (your email)
        Long consumerId = consumerService.getConsumerIdByEmail(email);
        System.out.println(consumerId);
        if (consumerId != null) {
            return ResponseEntity.ok(consumerId);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // ✅ Consumer's parcel history


    @GetMapping("/{consumerId}/parcels")
    public ResponseEntity<List<ParcelResponseDTO>> getConsumerParcelHistory(@PathVariable Long consumerId) {
        List<ParcelResponseDTO> parcels = parcelService.getParcelHistoryByConsumer(consumerId);
        return ResponseEntity.ok(parcels);
    }

    // Consumer profile + তার সব parcel history

    //http://localhost:8085/api/consumer/3/parcels


    @GetMapping("/{id}/profile")
    public ResponseEntity<ConsumerResponseDTO> getConsumerProfile(@PathVariable int id) {
        ConsumerResponseDTO consumer = consumerService.getProfileByConsumerId(id);
        return ResponseEntity.ok(consumer);
    }




}