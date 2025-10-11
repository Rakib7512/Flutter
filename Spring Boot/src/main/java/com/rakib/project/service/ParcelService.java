package com.rakib.project.service;

import com.rakib.project.dto.LocationResponseDTO;
import com.rakib.project.dto.ParcelDto;
import com.rakib.project.dto.ParcelResponseDTO;
import com.rakib.project.entity.Employee;
import com.rakib.project.entity.Parcel;
import com.rakib.project.entity.ParcelTracking;
import com.rakib.project.repository.IEmployeeRepo;
import com.rakib.project.repository.IParcelRepository;
import com.rakib.project.repository.IParcelTrackingRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ParcelService {

    @Autowired
    private IParcelRepository parcelRepository;
    @Autowired
    private IParcelTrackingRepository trackingRepository;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private IEmployeeRepo employeeRepo;


    // ---------- Save Parcel  ----------
//    @Transactional
//    public Parcel saveParcel(Parcel parcel ) {
//        if (parcel.getTrackingHistory() != null) {
//            for (ParcelTracking t : parcel.getTrackingHistory()) {
//                t.setParcel(parcel);
//            }
//        }
//
//        Parcel savedParcel = parcelRepository.save(parcel);
//

    /// /        // Employer কে notification পাঠানো
    /// /        notificationService.createNotification(
    /// /                "New Parcel booked: Tracking ID = " + savedParcel.getTrackingId(),
    /// /                employerId
    /// /        );
//
//        return savedParcel;
//    }
    public Parcel saveParcel(Parcel parcel) {
        Parcel saved = parcelRepository.save(parcel);

        // 🔹 Find employees in the same location as sender
        List<Employee> employees = employeeRepo.findByCountryAndDivisionAndDistrictAndPoliceStation(
                saved.getSendCountry(),
                saved.getSendDivision(),
                saved.getSendDistrict(),
                saved.getSendPoliceStation()
        );


        // 🔹 Send notification
        if (!employees.isEmpty()) {
            notificationService.notifyEmployees(
                    employees,
                    "New parcel booked in your area with tracking ID: " + saved.getTrackingId()
            );
        }

        return saved;
    }


//    public List<Parcel> getAllParcels() {
//        return parcelRepository.findAll();
//    }

    public Parcel getParcelById(Long id) {
        return parcelRepository.findById(id).orElse(null);
    }

    public Optional<Parcel> getParcelByTrackingId(String trackingId) {
        return parcelRepository.findByTrackingId(trackingId);
    }

    public void deleteParcel(Long id) {
        parcelRepository.deleteById(id);
    }

    // ---------- Tracking specific methods ----------

    @Transactional
    public ParcelTracking addTrackingToParcel(Long parcelId, ParcelTracking tracking) {
        Parcel parcel = parcelRepository.findById(parcelId)
                .orElseThrow(() -> new IllegalArgumentException("Parcel not found with id: " + parcelId));

        // set bi-directional link
        tracking.setParcel(parcel);

        // save tracking
        ParcelTracking saved = trackingRepository.save(tracking);

        // also ensure parcel's list contains it (optional but keeps entity state consistent)
        if (parcel.getTrackingHistory() == null) {
            parcel.setTrackingHistory(new ArrayList<>());
        }
        parcel.getTrackingHistory().add(saved);

        parcelRepository.save(parcel);

        return saved;
    }

    public List<ParcelTracking> getTrackingForParcel(Long parcelId) {
        Parcel parcel = parcelRepository.findById(parcelId)
                .orElseThrow(() -> new IllegalArgumentException("Parcel not found with id: " + parcelId));
        return parcel.getTrackingHistory() == null ? List.of() : parcel.getTrackingHistory();
    }


    @Transactional
    public void removeTracking(Long parcelId, Long trackingId) {
        Parcel parcel = parcelRepository.findById(parcelId)
                .orElseThrow(() -> new IllegalArgumentException("Parcel not found with id: " + parcelId));

        Optional<ParcelTracking> opt = trackingRepository.findById(trackingId);
        if (opt.isEmpty()) {
            throw new IllegalArgumentException("Tracking not found with id: " + trackingId);
        }
        ParcelTracking t = opt.get();

        if (!t.getParcel().getId().equals(parcel.getId())) {
            throw new IllegalArgumentException("Tracking does not belong to the given parcel");
        }

        // remove from parcel list
        if (parcel.getTrackingHistory() != null) {
            parcel.getTrackingHistory().removeIf(x -> x.getId().equals(trackingId));
            parcelRepository.save(parcel);
        }

        trackingRepository.deleteById(trackingId);
    }

//    @Transactional
//    public Parcel receiveParcel(Long parcelId, Long employeeId, String employeeName, String currentHub) {
//        Parcel parcel = parcelRepository.findById(parcelId)
//                .orElseThrow(() -> new IllegalArgumentException("Parcel not found"));
//
//        parcel.setReceivedByEmployeeId(employeeId);
//        parcel.setReceivedByEmployeeName(employeeName);
//        parcel.setCurrentHub(currentHub);
//
//        return parcelRepository.save(parcel);
//    }


    // বিদ্যমান DTO ব্যবহার করব

    public List<ParcelDto> getAllParcelsByTrackingId(String trackingId) {
        List<ParcelDto> newParcels = parcelRepository.findParcelByTrackingId(trackingId).stream().map(parcel -> {
            ParcelDto dto = new ParcelDto();
            dto.setId(parcel.getId());
            dto.setTrackingId(parcel.getTrackingId());
            dto.setSenderName(parcel.getSenderName());
            dto.setReceiverName(parcel.getReceiverName());
            dto.setSenderPhone(parcel.getSenderPhone());
            dto.setReceiverPhone(parcel.getReceiverPhone());
            dto.setAddressLineForSender1(parcel.getAddressLineForSender1());
            dto.setAddressLineForSender2(parcel.getAddressLineForSender2());
            dto.setSendCountryId(parcel.getSendCountry().getId());
            dto.setSendDivisionId(parcel.getSendDivision().getId());
            dto.setSendDistrictId(parcel.getSendDistrict().getId());
            dto.setSendPoliceStationId(parcel.getSendPoliceStation().getId());
            dto.setReceiveCountryId(parcel.getReceiveCountry().getId());
            dto.setReceiveDivisionId(parcel.getReceiveDivision().getId());
            dto.setReceiveDistrictId(parcel.getReceiveDistrict().getId());
            dto.setReceivePoliceStationId(parcel.getReceivePoliceStation().getId());
            dto.setSize(parcel.getSize());
            dto.setFee(parcel.getFee());
            dto.setStatus(dto.getStatus());
            dto.setCreatedAt(parcel.getCreatedAt());
            dto.setBookingDate(parcel.getBookingDate());
            dto.setCurrentHub(parcel.getCurrentHub());
            dto.setPreviousHub(parcel.getPreviousHub());
            dto.setToHub(parcel.getToHub());
            return dto;
        }).toList();

        return newParcels;
    }


//    public ParcelResponseDTO getParcelByParcelId(String trackingId) {
//        Parcel parcel = parcelRepository.findByTrackingId(trackingId)
//                .orElseThrow(() -> new RuntimeException("Parcel not found"));
//
//        ParcelResponseDTO dto = new ParcelResponseDTO();
//        dto.setId(parcel.getId());
//        dto.setTrackingId(parcel.getTrackingId());
//        dto.setSenderName(parcel.getSenderName());
//        dto.setSenderPhone(parcel.getSenderPhone());
//        dto.setReceiverName(parcel.getReceiverName());
//        dto.setReceiverPhone(parcel.getReceiverPhone());
//
//        dto.setAddressLineForSender1(parcel.getAddressLineForSender1());
//        dto.setAddressLineForSender2(parcel.getAddressLineForSender2());
//        dto.setAddressLineForReceiver1(parcel.getAddressLineForReceiver1());
//        dto.setAddressLineForReceiver2(parcel.getAddressLineForReceiver2());
//
//        dto.setFee(parcel.getFee());
//        dto.setStatus(parcel.getStatus().toString());
//
//        // 🔥 Country/Division/District mapping with name
//        if (parcel.getSendCountry() != null) {
//            dto.setSendCountry(new LocationResponseDTO(
//                    parcel.getSendCountry().getId(),
//                    parcel.getSendCountry().getName()
//            ));
//        }
//        if (parcel.getSendDivision() != null) {
//            dto.setSendDivision(new LocationResponseDTO(
//                    parcel.getSendDivision().getId(),
//                    parcel.getSendDivision().getName()
//            ));
//        }
//        if (parcel.getSendDistrict() != null) {
//            dto.setSendDistrict(new LocationResponseDTO(
//                    parcel.getSendDistrict().getId(),
//                    parcel.getSendDistrict().getName()
//            ));
//        }
//        if (parcel.getSendPoliceStation() != null) {
//            dto.setSendPoliceStation(new LocationResponseDTO(
//                    parcel.getSendPoliceStation().getId(),
//                    parcel.getSendPoliceStation().getName()
//            ));
//        }
//
//        if (parcel.getReceiveCountry() != null) {
//            dto.setReceiveCountry(new LocationResponseDTO(
//                    parcel.getReceiveCountry().getId(),
//                    parcel.getReceiveCountry().getName()
//            ));
//        }
//        if (parcel.getReceiveDivision() != null) {
//            dto.setReceiveDivision(new LocationResponseDTO(
//                    parcel.getReceiveDivision().getId(),
//                    parcel.getReceiveDivision().getName()
//            ));
//        }
//        if (parcel.getReceiveDistrict() != null) {
//            dto.setReceiveDistrict(new LocationResponseDTO(
//                    parcel.getReceiveDistrict().getId(),
//                    parcel.getReceiveDistrict().getName()
//            ));
//        }
//        if (parcel.getReceivePoliceStation() != null) {
//            dto.setReceivePoliceStation(new LocationResponseDTO(
//                    parcel.getReceivePoliceStation().getId(),
//                    parcel.getReceivePoliceStation().getName()
//            ));
//        }
//
//        return dto;
//    }




    public List<ParcelResponseDTO> getAllParcelResponseDTOS() {
        return parcelRepository.findAll().stream().map(parcel -> {
            ParcelResponseDTO dto = new ParcelResponseDTO();
            dto.setId(parcel.getId());
            dto.setTrackingId(parcel.getTrackingId());
            dto.setSenderName(parcel.getSenderName());
            dto.setSenderPhone(parcel.getSenderPhone());
            dto.setAddressLineForSender1(parcel.getAddressLineForSender1());
            dto.setAddressLineForSender2(parcel.getAddressLineForSender2());
            dto.setReceiverName(parcel.getReceiverName());
            dto.setReceiverPhone(parcel.getReceiverPhone());
            dto.setAddressLineForReceiver1(parcel.getAddressLineForReceiver1());
            dto.setAddressLineForReceiver2(parcel.getAddressLineForReceiver2());
            dto.setFee(parcel.getFee());
            dto.setStatus(parcel.getStatus().toString());

            if (parcel.getDeliveryMan() != null) {
                dto.setDeliveryManId(parcel.getDeliveryMan().getId());
                dto.setDelevaryManName(parcel.getDeliveryMan().getName());
            } else {
                dto.setDeliveryManId(0); // or 0, depending on your DTO type
                dto.setDelevaryManName(null);
            }





            // 🔥 Send side mapping
            if (parcel.getSendCountry() != null) {
                dto.setSendCountry(new LocationResponseDTO(
                        parcel.getSendCountry().getId(),
                        parcel.getSendCountry().getName()
                ));
            }
            if (parcel.getSendDivision() != null) {
                dto.setSendDivision(new LocationResponseDTO(
                        parcel.getSendDivision().getId(),
                        parcel.getSendDivision().getName()
                ));
            }
            if (parcel.getSendDistrict() != null) {
                dto.setSendDistrict(new LocationResponseDTO(
                        parcel.getSendDistrict().getId(),
                        parcel.getSendDistrict().getName()
                ));
            }
            if (parcel.getSendPoliceStation() != null) {
                dto.setSendPoliceStation(new LocationResponseDTO(
                        parcel.getSendPoliceStation().getId(),
                        parcel.getSendPoliceStation().getName()
                ));
            }

            // 🔥 Receive side mapping
            if (parcel.getReceiveCountry() != null) {
                dto.setReceiveCountry(new LocationResponseDTO(
                        parcel.getReceiveCountry().getId(),
                        parcel.getReceiveCountry().getName()
                ));
            }
            if (parcel.getReceiveDivision() != null) {
                dto.setReceiveDivision(new LocationResponseDTO(
                        parcel.getReceiveDivision().getId(),
                        parcel.getReceiveDivision().getName()
                ));
            }
            if (parcel.getReceiveDistrict() != null) {
                dto.setReceiveDistrict(new LocationResponseDTO(
                        parcel.getReceiveDistrict().getId(),
                        parcel.getReceiveDistrict().getName()
                ));
            }
            if (parcel.getReceivePoliceStation() != null) {
                dto.setReceivePoliceStation(new LocationResponseDTO(
                        parcel.getReceivePoliceStation().getId(),
                        parcel.getReceivePoliceStation().getName()
                ));
            }

            return dto;
        }).collect(Collectors.toList());
    }






    public Parcel updateParcel(Parcel parcel) {
        return parcelRepository.save(parcel);
    }


    // ✅ Get history of parcels booked by a consumer
    public List<ParcelResponseDTO> getParcelHistoryByConsumer(Long consumerId) {
        return parcelRepository.findByConsumerId(consumerId)
                .stream()
                .map(this::mapToResponseDTO) // নিচের helper method use করব
                .collect(Collectors.toList());
    }


//    private ParcelResponseDTO mapToResponseDTO(Parcel parcel) {
//        ParcelResponseDTO dto = new ParcelResponseDTO();
//        dto.setId(parcel.getId());
//        dto.setTrackingId(parcel.getTrackingId());
//        dto.setSenderName(parcel.getSenderName());
//        dto.setReceiverName(parcel.getReceiverName());
//        dto.setSenderPhone(parcel.getSenderPhone());
//        dto.setReceiverPhone(parcel.getReceiverPhone());
//        dto.setFee(parcel.getFee());
//        dto.setStatus(parcel.getStatus().toString());
//        dto.setCurrentHub(parcel.getCurrentHub());
//        dto.setBookingDate(parcel.getBookingDate());
//        dto.setSendCountry();
//
//        return dto;
//    }



    private ParcelResponseDTO mapToResponseDTO(Parcel parcel) {
        ParcelResponseDTO dto = new ParcelResponseDTO();
        dto.setId(parcel.getId());
        dto.setTrackingId(parcel.getTrackingId());
        dto.setSenderName(parcel.getSenderName());
        dto.setReceiverName(parcel.getReceiverName());
        dto.setSenderPhone(parcel.getSenderPhone());
        dto.setReceiverPhone(parcel.getReceiverPhone());
        dto.setFee(parcel.getFee());
        dto.setStatus(parcel.getStatus().toString());
        dto.setCurrentHub(parcel.getCurrentHub());
        dto.setBookingDate(parcel.getBookingDate());
        if (parcel.getDeliveryMan() != null) {
            dto.setDeliveryManId(parcel.getDeliveryMan().getId());
            dto.setDelevaryManName(parcel.getDeliveryMan().getName());
        } else {
            dto.setDeliveryManId(0); // or 0, depending on your DTO type
            dto.setDelevaryManName(null);
        }

        // Mapping sender country
        if(parcel.getSendCountry() != null){
            LocationResponseDTO sendCountryDTO = new LocationResponseDTO();
            sendCountryDTO.setId(parcel.getSendCountry().getId());
            sendCountryDTO.setName(parcel.getSendCountry().getName());
            dto.setSendCountry(sendCountryDTO);
        }

        // Mapping receiver country
        if(parcel.getReceiveCountry() != null){
            LocationResponseDTO receiveCountryDTO = new LocationResponseDTO();
            receiveCountryDTO.setId(parcel.getReceiveCountry().getId());
            receiveCountryDTO.setName(parcel.getReceiveCountry().getName());
            dto.setReceiveCountry(receiveCountryDTO);
        }

        return dto;
    }


}






