package com.rakib.project.service;

import com.rakib.project.entity.Employee;
import com.rakib.project.entity.Notification;
import com.rakib.project.repository.INotificationRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotificationService {

    @Autowired
    private  INotificationRepo notificationRepository;



//    public List<Notification> getUnreadNotifications(Long recipientId) {
//        return notificationRepository.findByRecipientIdAndReadStatusFalse(recipientId);
//    }

//    public void markAsRead(Long id) {
//        Notification n = notificationRepository.findById(id).orElseThrow();
//        n.setReadStatus(true);
//        notificationRepository.save(n);
//    }

    public void notifyEmployees(List<Employee> employees, String message) {
        for (Employee emp : employees) {
            Notification n = new Notification();
            n.setEmployee(emp);
            n.setMessage(message);
            n.setReceived(false);
            notificationRepository.save(n);

            // 🔹 Here you could also send real-time notification via WebSocket/email
            System.out.println("Notified " + emp.getName() + ": " + message);
        }
    }


}
