package com.lakshan.medi_sync.controller;

import com.lakshan.medi_sync.entity.BloodPressure;
import com.lakshan.medi_sync.service.BloodPressureService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/blood_pressure")
public class BloodPressureController {

    private final BloodPressureService bpService;

    @Autowired
    public BloodPressureController(BloodPressureService bpService) {
        this.bpService = bpService;
    }

    @PostMapping("/addBloodPressureRecord")
    public ResponseEntity<BloodPressure> addBloodPressureRecord(@RequestBody BloodPressure bloodPressure) {
        bpService.addNewBloodPressureRecord(bloodPressure);
        return ResponseEntity.status(201).body(bloodPressure);
    }

    @GetMapping("/getAllBloodPressureRecords")
    public List<BloodPressure> getAllBloodPressureRecords() {
        return bpService.getAllBloodPressureRecords();
    }

    @GetMapping("/getBloodPressureRecord/{id}")
    public BloodPressure getBloodPressureRecordById(@PathVariable int id) {
        return bpService.getBloodPressureRecordById(id);
    }

    @GetMapping("/getBloodPressureRecordsByUserId/{userId}")
    public List<BloodPressure> getBloodPressureRecordsByUserId(@PathVariable int userId) {
        return bpService.getBloodPressureRecordsByUserId(userId);
    }

    @PutMapping("/updateBloodPressureRecord")
    public ResponseEntity<BloodPressure> updateBloodPressureRecord(@RequestBody BloodPressure bloodPressure) {
        bpService.updateBloodPressureRecord(bloodPressure);
        return ResponseEntity.ok(bloodPressure);
    }

    @DeleteMapping("/deleteBloodPressureRecord/{id}")
    public ResponseEntity<String> deleteBloodPressureRecord(@PathVariable int id) {
        bpService.deleteBloodPressureRecord(id);
        return ResponseEntity.ok("Record deleted successfully");
    }
}
