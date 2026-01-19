package com.lakshan.medi_sync.controller;

import com.lakshan.medi_sync.entity.LiverProfile;
import com.lakshan.medi_sync.service.LiverProfileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/liver_profile")
public class LiverProfileController {

    private final LiverProfileService liverService;

    @Autowired
    public LiverProfileController(LiverProfileService liverService) {
        this.liverService = liverService;
    }

    @PostMapping("/addLiverProfileRecord")
    public ResponseEntity<LiverProfile> addLiverProfileRecord(@RequestBody LiverProfile liverProfile) {
        liverService.addNewLiverProfile(liverProfile);
        return ResponseEntity.status(201).body(liverProfile);
    }

    @GetMapping("/getAllLiverProfileRecords")
    public List<LiverProfile> getAllLiverProfileRecords() {
        return liverService.getAllLiverProfileRecords();
    }

    @GetMapping("/getLiverProfileRecord/{id}")
    public LiverProfile getLiverProfileRecordById(@PathVariable int id) {
        return liverService.getLiverProfileRecordById(id);
    }

    @GetMapping("/getLiverProfileRecordsByUserId/{userId}")
    public List<LiverProfile> getLiverProfileRecordsByUserId(@PathVariable int userId) {
        return liverService.getLiverProfileRecordsByUserId(userId);
    }

    @PutMapping("/updateLiverProfileRecord")
    public ResponseEntity<LiverProfile> updateLiverProfileRecord(@RequestBody LiverProfile liverProfile) {
        liverService.updateLiverProfileRecord(liverProfile);
        return ResponseEntity.ok(liverProfile);
    }

    @DeleteMapping("/deleteLiverProfileRecord/{id}")
    public ResponseEntity<String> deleteLiverProfileRecord(@PathVariable int id) {
        liverService.deleteLiverProfileRecord(id);
        return ResponseEntity.ok("Record deleted successfully");
    }
}

