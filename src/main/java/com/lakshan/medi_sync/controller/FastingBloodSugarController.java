package com.lakshan.medi_sync.controller;

import com.lakshan.medi_sync.entity.FastingBloodSugar;
import com.lakshan.medi_sync.service.FastingBloodSugarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/fbs")
public class FastingBloodSugarController {

    private final FastingBloodSugarService fbsService;

    @Autowired
    public FastingBloodSugarController(FastingBloodSugarService fbsService) {
        this.fbsService = fbsService;
    }

    @PostMapping("/addFastingBloodSugarRecord")
    public ResponseEntity<FastingBloodSugar> addFastingBloodSugarRecord(
            @RequestBody FastingBloodSugar fastingBloodSugar
    ) {
        System.out.println("========= RECEIVED FROM FRONTEND =========");
        System.out.println("User Email: " + fastingBloodSugar.getUser().getEmail());
        System.out.println("User ID: " + fastingBloodSugar.getUser().getId());
        System.out.println("==========================================");

        fbsService.addNewFastingBloodSugarRecord(fastingBloodSugar);
        return ResponseEntity.status(201).body(fastingBloodSugar);
    }

    @GetMapping("/getAllFastingBloodSugarRecords")
    public List<FastingBloodSugar> getAllFastingBloodSugarRecords() {
        return fbsService.getAllFastingBloodSugarRecords();
    }

    @GetMapping("/getFastingBloodSugarRecord/{id}")
    public FastingBloodSugar getFastingBloodSugarRecordById(@PathVariable int id) {
        return fbsService.getFastingBloodSugarRecordById(id);
    }

    @GetMapping("/getFastingBloodSugarRecordsByUserId/{userId}")
    public List<FastingBloodSugar> getFastingBloodSugarRecordsByUserId(@PathVariable int userId) {
        return fbsService.getFastingBloodSugarRecordsByUserId(userId);
    }

    @PutMapping("/updateFastingBloodSugarRecord")
    public ResponseEntity<FastingBloodSugar> updateFastingBloodSugarRecord(
            @RequestBody FastingBloodSugar fastingBloodSugar
    ) {
        fbsService.updateFastingBloodSugarRecord(fastingBloodSugar);
        return ResponseEntity.ok(fastingBloodSugar);
    }

    @DeleteMapping("/deleteFastingBloodSugarRecord/{id}")
    public ResponseEntity<String> deleteFastingBloodSugarRecord(@PathVariable int id) {
        fbsService.deleteFastingBloodSugarRecord(id);
        return ResponseEntity.ok("Record deleted successfully");
    }

}
