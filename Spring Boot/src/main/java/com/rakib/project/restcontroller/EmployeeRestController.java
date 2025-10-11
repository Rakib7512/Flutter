package com.rakib.project.restcontroller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.rakib.project.dto.EmployeeResponseDTO;
import com.rakib.project.entity.Consumer;
import com.rakib.project.entity.Employee;
import com.rakib.project.entity.User;
import com.rakib.project.repository.IEmployeeRepo;
import com.rakib.project.repository.IUserRepo;
import com.rakib.project.service.AuthService;
import com.rakib.project.service.ConsumerService;
import com.rakib.project.service.EmployeeService;
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
@RequestMapping("/api/employee/")
public class EmployeeRestController {


    @Autowired
    private AuthService userService;

    @Autowired
    private IEmployeeRepo employeeRepoRepository;

    @Autowired
    private IUserRepo userRepo;

    @Autowired
    private EmployeeService employeeService;

    @Autowired
    private AuthService authService;

    @PostMapping("")
    public ResponseEntity<Map<String, String>> registerEmployee(
            @RequestPart(value = "user") String userJson,
            @RequestPart(value = "employee") String employeeJson,
            @RequestParam(value = "photo") MultipartFile file
    ) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        User user = objectMapper.readValue(userJson, User.class);
        Employee employee = objectMapper.readValue(employeeJson, Employee.class);

        try {
            authService.registerEmployee(user, file, employee);
            Map<String, String> response = new HashMap<>();
            response.put("Message", "User Added Successfully ");

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {

            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("Message", "User Add Faild " + e);
            return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
        }


    }


    @GetMapping("")
    public ResponseEntity<List<Employee>> getAllEmployee() {
        List<Employee> employeeList = employeeService.getAll();
        return ResponseEntity.ok(employeeList);

    }


    @GetMapping("all")
    public ResponseEntity<List<EmployeeResponseDTO>> getAllEmployees() {
        List<EmployeeResponseDTO> employeeList = employeeService.getAllAttendanceResponseDTOS();
        return ResponseEntity.ok(employeeList);

    }




//    @GetMapping("/profile")
//    public ResponseEntity<?> getProfile(Authentication authentication) {
//        System.out.println("Authenticated User: " + authentication.getName());
//        System.out.println("Authorities: " + authentication.getAuthorities());
//        String email = authentication.getName();
//        Optional<User> user =userRepo.findByEmail(email);
//        Employee employee = employeeService.getProfileByUserId(user.get().getId());
//        return ResponseEntity.ok(employee);
//
//    }



    @GetMapping("my-id")
    public ResponseEntity<Long> getLoggedInEmployeeId(Authentication authentication) {
        String email = authentication.getName(); // Spring Security sets this to username (your email)
        Long employeeId = employeeService.getEmployeeIdByEmail(email);
        System.out.println(employeeId);
        if (employeeId != null) {
            return ResponseEntity.ok(employeeId);
        } else {
            return ResponseEntity.notFound().build();
        }
    }




@GetMapping("/profile")
    public ResponseEntity<EmployeeResponseDTO> getProfile(Authentication authentication) {
        System.out.println("Authenticated User: " + authentication.getName());
        System.out.println("Authorities: " + authentication.getAuthorities());
        String email = authentication.getName();
        Optional<User> user =userRepo.findByEmail(email);
        EmployeeResponseDTO employee = employeeService.getProfileByUserId(user.get().getId());
        return ResponseEntity.ok(employee);

    }



//    {
//        "id": 1,
//            "name": "Parvej",
//            "email": "parvej@gmail.com",
//            "gender": "MALE",
//            "nid": "1452369",
//            "address": "Agargaon",
//            "designation": "Area Manager",
//            "joindate": "2025-06-25T00:00:00.000+00:00",
//            "phone": "01607005625",
//            "salary": 100000.0,
//            "photo": "Parvej_336b6369-5796-4b51-bbf5-6414e81c9c25",
//            "empOnHub": "1",
//            "countryId": {
//        "id": 1,
//                "name": "Bangladesh"
//    },
//        "divisionId": {
//        "id": 1,
//                "name": "Dhaka",
//                "country": null
//    },
//        "districtId": {
//        "id": 1,
//                "name": "Dhaka",
//                "division": null
//    },
//        "policeStationId": {
//        "id": 1,
//                "name": "Mohammadpur",
//                "district": null
//    },
//        "userId": {
//        "id": 2,
//                "name": "Parvej",
//                "email": "parvej@gmail.com"
//    }
//    }



}