package com.rakib.project.repository;

import com.rakib.project.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface INotificationRepo extends JpaRepository<Notification, Long> {
    List<Notification> findByEmployeeIdOrderByCreatedAt(Long employeeId);

    List<Notification> findByEmployeeId(Long employeeId);

    List<Notification> findByEmployeeIdOrderByCreatedAtDesc(Long employeeId);

//    List<Notification> findByRecipientIdAndReadStatusFalse(Long recipientId);
}
