package com.rakib.project.restcontroller;


import com.rakib.project.dto.NotificationResponseDTO;
import com.rakib.project.entity.Notification;
import com.rakib.project.repository.INotificationRepo;
import com.rakib.project.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
public class NotificationRestController {
    @Autowired
    private NotificationService notificationService;

    @Autowired
    private INotificationRepo notificationRepo;


    @GetMapping("/employee/{id}")
    public List<NotificationResponseDTO> getEmployeeNotifications(@PathVariable Long id) {
        List<Notification> notifications = notificationRepo.findByEmployeeIdOrderByCreatedAtDesc((id));

        // Map to DTO
        return notifications.stream()
                .map(n -> new NotificationResponseDTO(
                        n.getId(),
                        n.getMessage(),
                        n.getCreatedAt(),
                        n.isReceived(),
                        n.getEmployee() != null ? n.getEmployee().getId() : null,
                        n.getEmployee() != null ? n.getEmployee().getName() : null
                ))
                .toList();
    }



    @PutMapping("/{id}/receive")
    public ResponseEntity<String> receiveNotification(@PathVariable Long id) {
        Notification notification = notificationRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Notification not found"));

        if (!notification.isReceived()) {
            notification.setReceived(true);
            notificationRepo.save(notification);
        }
        return ResponseEntity.ok("Notification marked as received");
    }





}
