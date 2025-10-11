package com.rakib.project.service;

import com.rakib.project.dto.*;
import com.rakib.project.entity.*;
import com.rakib.project.repository.IConsumerRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ConsumerService {

    @Autowired
    private IConsumerRepo consumerRepository;

    public List<Consumer> getAll() {
        return consumerRepository.findAll();
    }

    public Optional<Consumer> getById(Long id) {
        return consumerRepository.findById(id);
    }


    public Consumer save(Consumer consumer) {
        return consumerRepository.save(consumer);
    }

    public void delete(Long id) {
        consumerRepository.deleteById(id);
    }


    public Consumer getProfileByUserId(int userId) {
        return consumerRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Consumer not found"));
    }

    public Long getConsumerIdByEmail(String email) {
        return consumerRepository.findByUserEmail(email)
                .map(Consumer::getId)
                .orElse(null);
    }

    public Consumer getConsumerWithParcels(Long consumerId) {
        return consumerRepository.findByIdWithParcels(consumerId)
                .orElseThrow(() -> new RuntimeException("Consumer not found"));
    }


    public ConsumerResponseDTO getProfileByConsumerId(long consumerId) {


        Consumer consumer = consumerRepository.findById(consumerId)
                .orElseThrow(() -> new RuntimeException("Consumer not found"));

        // Convert Employee entity to EmployeeResponseDTO using setter style
        ConsumerResponseDTO dto = new ConsumerResponseDTO();
        dto.setId(consumer.getId());
        dto.setName(consumer.getName());
        dto.setEmail(consumer.getEmail());
        dto.setGender(consumer.getGender());
        dto.setNid(consumer.getNid());
        dto.setPhone(consumer.getPhone());
        dto.setPhoto(consumer.getPhoto());
        dto.setAddress(consumer.getAddress());
        return dto;
    }




    public List<ConsumerResponseDTO> getAllAttendanceResponseDTOS() {
        return consumerRepository.findAll().stream().map(atten -> {
            ConsumerResponseDTO dto = new ConsumerResponseDTO();
            dto.setId(atten.getId());
            dto.setName(atten.getName());
            dto.setEmail(atten.getEmail());
            dto.setPhone(atten.getPhone());
            dto.setGender(atten.getGender());
            dto.setNid(atten.getNid());
            dto.setAddress(atten.getAddress());
            dto.setPhoto(atten.getPhoto());

            return dto;
        }).toList();
    }

    public Consumer findByEmail(String email) {
        return consumerRepository.findByEmail(email);
    }

}