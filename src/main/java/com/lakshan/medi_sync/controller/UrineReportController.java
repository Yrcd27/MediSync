package com.lakshan.medi_sync.controller;

import com.lakshan.medi_sync.entity.UrineReport;
import com.lakshan.medi_sync.service.UrineReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/urine_report")
public class UrineReportController {

    private final UrineReportService urineService;

    @Autowired
    public UrineReportController(UrineReportService urineService) {
        this.urineService = urineService;
    }

    @PostMapping("/addUrineReportRecord")
    public ResponseEntity<UrineReport> addUrineReportRecord(@RequestBody UrineReport urineReport) {
        urineService.addNewUrineReport(urineReport);
        return ResponseEntity.status(201).body(urineReport);
    }

    @GetMapping("/getAllUrineReportRecords")
    public List<UrineReport> getAllUrineReportRecords() {
        return urineService.getAllUrineReportRecords();
    }

    @GetMapping("/getUrineReportRecord/{id}")
    public UrineReport getUrineReportRecordById(@PathVariable int id) {
        return urineService.getUrineReportRecordById(id);
    }

    @GetMapping("/getUrineReportRecordsByUserId/{userId}")
    public List<UrineReport> getUrineReportRecordsByUserId(@PathVariable int userId) {
        return urineService.getUrineReportRecordsByUserId(userId);
    }

    @PutMapping("/updateUrineReportRecord")
    public ResponseEntity<UrineReport> updateUrineReportRecord(@RequestBody UrineReport urineReport) {
        urineService.updateUrineReportRecord(urineReport);
        return ResponseEntity.ok(urineReport);
    }

    @DeleteMapping("/deleteUrineReportRecord/{id}")
    public ResponseEntity<String> deleteUrineReportRecord(@PathVariable int id) {
        urineService.deleteUrineReportRecord(id);
        return ResponseEntity.ok("Record deleted successfully");
    }
}

