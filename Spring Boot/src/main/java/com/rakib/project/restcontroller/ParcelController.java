package com.rakib.project.restcontroller;


import com.rakib.project.dto.ConsumerResponseDTO;
import com.rakib.project.dto.ParcelDto;
import com.rakib.project.dto.ParcelResponseDTO;
import com.rakib.project.dto.ParcelTrackingDTO;
import com.rakib.project.entity.*;
import com.rakib.project.repository.*;
import com.rakib.project.service.NotificationService;
import com.rakib.project.service.ParcelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/parcels")
@CrossOrigin("*")
public class ParcelController {



    @Autowired
    private IParcelRepository parcelRepo;

    @Autowired
    private IEmployeeRepo employeeRepo;

    @Autowired
    private  IConsumerRepo consumerRepo;


    @Autowired
    private INotificationRepo notificationRepo;
    @Autowired
    private IPoliceStationRepo policeStationRepo;

    @Autowired
    private IUserRepo  userRepo;


    @Autowired
    private IParcelTrackingRepository parcelTrackingRepo;

    private final ParcelService parcelService;
    private final NotificationService notificationService;

    public ParcelController(ParcelService parcelService, NotificationService notificationService) {
        this.parcelService = parcelService;
        this.notificationService = notificationService;
    }

    // ----------- Parcel CRUD ------------

    // এখন employerId সহ saveParcel হবে
    @PostMapping("/")
    public Parcel createParcel(@RequestBody Parcel parcel)
    { return parcelService.saveParcel(parcel );
    }

    // ✅ Get All Parcels (DTO-based)
    @GetMapping
    public ResponseEntity<List<ParcelResponseDTO>> getAllParcels() {
        List<ParcelResponseDTO> parcelDTOs = parcelService.getAllParcelResponseDTOS();
        return ResponseEntity.ok(parcelDTOs);
    }

    // ✅ Get Parcel By Id
    @GetMapping("/{id}")
    public ResponseEntity<Parcel> getParcelById(@PathVariable Long id) {
        Parcel parcel = parcelService.getParcelById(id);
        return ResponseEntity.ok(parcel);
    }

    // ✅ Get Parcel By Tracking Id
    @GetMapping("/track/{trackingId}")
    public ResponseEntity<Optional<Parcel>> getParcelByTrackingId(@PathVariable String trackingId) {
        Optional<Parcel> parcel = parcelService.getParcelByTrackingId(trackingId);
        return ResponseEntity.ok(parcel);
    }

    @DeleteMapping("/{id}")
    public void deleteParcel(@PathVariable Long id) {
        parcelService.deleteParcel(id);
    }

    // ----------- Notification APIs ------------

//    @GetMapping("/notifications/{employerId}")
//    public List<Notification> getEmployerNotifications(@PathVariable Long employerId) {
//        return notificationService.getUnreadNotifications(employerId);
//    }

//    @PutMapping("/notifications/{id}/read")
//    public void markNotificationAsRead(@PathVariable Long id) {
//        notificationService.markAsRead(id);
//    }


    @PutMapping("/parcel/{trackingId}/claimPickup/{employeeId}")
    public ResponseEntity<String> claimPickup(
            @PathVariable String trackingId,
            @PathVariable Long employeeId) {

        Parcel parcel = parcelRepo.findByTrackingId(trackingId)
                .orElseThrow(() -> new RuntimeException("Parcel not found"));

        if (parcel.getPickupDeliveryMan() != null) {
            return ResponseEntity.badRequest()
                    .body("Parcel pickup already assigned to " + parcel.getPickupDeliveryMan().getName());
        }

        Employee emp = employeeRepo.findById(employeeId)
                .orElseThrow(() -> new RuntimeException("Employee not found"));


        parcel.setCurrentHub(emp.getEmpOnHub());
        parcel.setPreviousHub(emp.getEmpOnHub());
        parcel.setPickupDeliveryMan(emp);
        parcelRepo.save(parcel);

        // Optional: notify other employees
        List<Employee> others = employeeRepo.findByCountryAndDivisionAndDistrictAndPoliceStation(
                        parcel.getSendCountry(),
                        parcel.getSendDivision(),
                        parcel.getSendDistrict(),
                        parcel.getSendPoliceStation()
                ).stream()
                .filter(e -> !e.getId().equals(emp.getId()))
                .toList();

        for (Employee o : others) {
            Notification n = new Notification();
            n.setEmployee(o);
            n.setMessage("Parcel #" + parcel.getTrackingId() + " pickup has been taken by " + emp.getName());
            notificationRepo.save(n);
        }

        return ResponseEntity.ok("Pickup assigned to " + emp.getName());
    }

// http://localhost:8085/api/parcels/parcel/53e6c9d0-cd0c-47ee-a6e9-7c9366d8d34e/claimPickup/1

//    {
//        "trackingId": "53e6c9d0-cd0c-47ee-a6e9-7c9366d8d34e",
//            "employeeId": 1
//    }



//    @PostMapping("/parcel/{trackingId}/transfer")
//    public ResponseEntity<String> transferParcel(
//            @PathVariable String trackingId,
//            @RequestParam String hubName,
//            @RequestParam Long employeeId) {
//
//        Parcel parcel = parcelRepo.findByTrackingId(trackingId)
//                .orElseThrow(() -> new RuntimeException("Parcel not found"));
//
//        Employee emp = employeeRepo.findById(employeeId)
//                .orElseThrow(() -> new RuntimeException("Employee not found"));
//
//        ParcelTracking tracking = new ParcelTracking();
//        tracking.setParcel(parcel);
//        tracking.setHubName(hubName);
//        tracking.setHandledBy(emp);
//        tracking.setStatus(ParcelStatus.IN_TRANSIT);
//        parcelTrackingRepo.save(tracking);
//
//        return ResponseEntity.ok("Parcel transferred to " + hubName);
//    }


    @PostMapping("/parcel/{trackingId}/transfer")
    public ResponseEntity<String> transferParcel(
            @PathVariable String trackingId,
            @RequestParam String hubName,
            @RequestParam Long employeeId) {

        // 1. Find the parcel
        Parcel parcel = parcelRepo.findByTrackingId(trackingId)
                .orElseThrow(() -> new RuntimeException("Parcel not found"));

        // 2. Find the employee handling this transfer
        Employee emp = employeeRepo.findById(employeeId)
                .orElseThrow(() -> new RuntimeException("Employee not found"));

        // 3. Update Parcel hubs
        parcel.setPreviousHub(parcel.getCurrentHub()); // current becomes previous
        System.out.println(parcel.getCurrentHub());


        parcel.setCurrentHub(hubName);
        System.out.println(parcel.getToHub());// toHub becomes current


        parcel.setToHub(hubName);                    // new hub to transfer to
        System.out.println(hubName);

        // 4. Save the updated parcel
        parcelRepo.save(parcel);

        // 5. Create a new tracking entry
        ParcelTracking tracking = new ParcelTracking();
        tracking.setParcel(parcel);
        tracking.setHubName(hubName);
        tracking.setHandledBy(emp);
        tracking.setStatus(ParcelStatus.IN_TRANSIT);
        parcelTrackingRepo.save(tracking);

        return ResponseEntity.ok("Parcel transferred to " + hubName);
    }


    // URL      http://localhost:8085/api/parcels/parcel/53e6c9d0-cd0c-47ee-a6e9-7c9366d8d34e/transfer?hubName=Central%20Hub%20Dhaka&employeeId=1
//   {
//       "hubName": "Central Hub - Dhaka",
//           "employeeId": 2
//   }



    @GetMapping("/parcel/{trackingId}/tracking")
    public ResponseEntity<List<ParcelTrackingDTO>> getParcelTracking(@PathVariable String trackingId) {

        Parcel parcel = parcelRepo.findByTrackingId(trackingId)
                .orElseThrow(() -> new RuntimeException("Parcel not found"));

        List<ParcelTracking> trackingList = parcelTrackingRepo.findByParcelIdOrderByTimestampAsc(parcel.getId());

        if (trackingList.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        // Convert hub ID to PoliceStation name
        List<ParcelTrackingDTO> dtoList = trackingList.stream().map(pt -> {
            ParcelTrackingDTO dto = new ParcelTrackingDTO(pt);
            if (pt.getHubName() != null) {
                try {
                    int hubId = Integer.parseInt(pt.getHubName());
                    PoliceStation station = policeStationRepo.findById(hubId)
                            .orElse(null);
                    if (station != null) {
                        dto.setHubName(station.getName());
                    }
                } catch (NumberFormatException e) {
                    // Already a name, keep as-is
                }
            }
            return dto;
        }).toList();

        return ResponseEntity.ok(dtoList);
    }




    //    http://localhost:8085/api/parcels/parcel/53e6c9d0-cd0c-47ee-a6e9-7c9366d8d34e/tracking

//    @GetMapping("tracking/{trackingId}")
//    public Optional<ParcelDto> getAllParcelsByTrackingId(@PathVariable String trackingId) {
//        return parcelService.getParcelByTrackingId(trackingId);
//
//
//    }


////for transfer

    @GetMapping("/tracking/{trackingId}")
    public List<ParcelDto> getAllParcelsByTrackingId(@PathVariable String trackingId) {
        return parcelService.getAllParcelsByTrackingId(trackingId);
    }


    // http://localhost:8085/api/parcels/tracking/9dc6d625-863c-470a-9c5e-9820b4ee17d8




    @PutMapping("/")
    public Parcel updateParcel(@RequestBody Parcel parcel){
        return parcelService.updateParcel(parcel);
    }




//    @GetMapping("/trackP/{trackingId}")
//    public ResponseEntity<ParcelResponseDTO> getParcelDetailsByTrackingId(@PathVariable String trackingId) {
//        ParcelResponseDTO dto = parcelService.getParcelByParcelId(trackingId);
//        return ResponseEntity.ok(dto);
//    }


    // Consumer এর Parcel history
    @GetMapping("/history")
    public ResponseEntity<List<ParcelResponseDTO>> getParcelHistory(Authentication authentication) {

        String email = authentication.getName();

        Consumer consumer = consumerRepo.findByUserEmail(email)
                .orElseThrow(()-> new RuntimeException("Consumer not found"));

        return ResponseEntity.ok(parcelService.getParcelHistoryByConsumer(consumer.getId()));
    }




    @PostMapping("/parcel/{trackingId}/delevery")
    public ResponseEntity<String> deleveryParcel(
            @PathVariable String trackingId,
            @RequestParam String hubName,
            @RequestParam Long employeeId) {

        // 1. Find the parcel
        Parcel parcel = parcelRepo.findByTrackingId(trackingId)
                .orElseThrow(() -> new RuntimeException("Parcel not found"));

        // 2. Find the employee handling this transfer
        Employee emp = employeeRepo.findById(employeeId)
                .orElseThrow(() -> new RuntimeException("Employee not found"));

        // 3. Update Parcel hubs
        parcel.setPreviousHub(parcel.getCurrentHub()); // current becomes previous
        System.out.println(parcel.getCurrentHub());


        parcel.setCurrentHub(hubName);
        System.out.println(parcel.getToHub());// toHub becomes current


        parcel.setToHub(hubName);                    // new hub to transfer to
        System.out.println(hubName);
        // 4. Assign DeliveryMan
        parcel.setDeliveryMan(emp);
        parcel.setStatus(ParcelStatus.DELIVERED);

        // 5. Save the updated parcel
        parcelRepo.save(parcel);



        // 6. Create a new tracking entry
        ParcelTracking tracking = new ParcelTracking();
        tracking.setParcel(parcel);
        tracking.setHubName(hubName);
        tracking.setHandledBy(emp);
        tracking.setStatus(ParcelStatus.DELIVERED);
        parcelTrackingRepo.save(tracking);
        parcel.setDeliveryMan(emp);
        return ResponseEntity.ok("Parcel transferred to " + hubName);
    }





}


