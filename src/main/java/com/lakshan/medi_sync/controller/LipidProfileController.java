package com.lakshan.medi_sync.controller;

import com.lakshan.medi_sync.entity.LipidProfile;
import com.lakshan.medi_sync.service.LipidProfileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/lipid_profile")
public class LipidProfileController {

    private final LipidProfileService lipidService;

    @Autowired
    public LipidProfileController(LipidProfileService lipidService) {
        this.lipidService = lipidService;
    }

    @PostMapping("/addLipidProfileRecord")
    public ResponseEntity<LipidProfile> addLipidProfileRecord(@RequestBody LipidProfile lipidProfile) {
        lipidService.addNewLipidProfile(lipidProfile);
        return ResponseEntity.status(201).body(lipidProfile);
    }

    @GetMapping("/getAllLipidProfileRecords")
    public List<LipidProfile> getAllLipidProfileRecords() {
        return lipidService.getAllLipidProfileRecords();
    }

    @GetMapping("/getLipidProfileRecord/{id}")
    public LipidProfile getLipidProfileRecordById(@PathVariable int id) {
        return lipidService.getLipidProfileRecordById(id);
    }

    @GetMapping("/getLipidProfileRecordsByUserId/{userId}")
    public List<LipidProfile> getLipidProfileRecordsByUserId(@PathVariable int userId) {
        return lipidService.getLipidProfileRecordsByUserId(userId);
    }

    @PutMapping("/updateLipidProfileRecord")
    public ResponseEntity<LipidProfile> updateLipidProfileRecord(@RequestBody LipidProfile lipidProfile) {
        lipidService.updateLipidProfileRecord(lipidProfile);
        return ResponseEntity.ok(lipidProfile);
    }

    @DeleteMapping("/deleteLipidProfileRecord/{id}")
    public ResponseEntity<String> deleteLipidProfileRecord(@PathVariable int id) {
        lipidService.deleteLipidProfileRecord(id);
        return ResponseEntity.ok("Record deleted successfully");
    }
}

