package com.lakshan.medi_sync.controller;

import com.lakshan.medi_sync.entity.FullBloodCount;
import com.lakshan.medi_sync.service.FullBloodCountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/fbc")
public class FullBloodCountController {

    private final FullBloodCountService fbcService;

    @Autowired
    public FullBloodCountController(FullBloodCountService fbcService) {
        this.fbcService = fbcService;
    }

    @PostMapping("/addFullBloodCountRecord")
    public ResponseEntity<FullBloodCount> addFullBloodCountRecord(
            @RequestBody FullBloodCount fullBloodCount
    ) {
        fbcService.addNewFullBloodCount(fullBloodCount);
        return ResponseEntity.status(201).body(fullBloodCount);
    }

    @GetMapping("/getAllFullBloodCountRecords")
    public List<FullBloodCount> getAllFullBloodCountRecords() {
        return fbcService.getAllFullBloodCountRecords();
    }

    @GetMapping("/getFullBloodCountRecord/{id}")
    public FullBloodCount getFullBloodCountRecordById(@PathVariable int id) {
        return fbcService.getFullBloodCountRecordById(id);
    }

    @GetMapping("/getFullBloodCountRecordsByUserId/{userId}")
    public List<FullBloodCount> getFullBloodCountRecordsByUserId(@PathVariable int userId) {
        return fbcService.getFullBloodCountRecordsByUserId(userId);
    }

    @PutMapping("/updateFullBloodCountRecord")
    public ResponseEntity<FullBloodCount> updateFullBloodCountRecord(
            @RequestBody FullBloodCount fullBloodCount
    ) {
        fbcService.updateFullBloodCountRecord(fullBloodCount);
        return ResponseEntity.ok(fullBloodCount);
    }

    @DeleteMapping("/deleteFullBloodCountRecord/{id}")
    public ResponseEntity<String> deleteFullBloodCountRecord(@PathVariable int id) {
        fbcService.deleteFullBloodCountRecord(id);
        return ResponseEntity.ok("Record deleted successfully");
    }
}
