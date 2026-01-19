package com.lakshan.medi_sync.controller;

import com.lakshan.medi_sync.entity.Report;
import com.lakshan.medi_sync.service.ReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/reports")
public class ReportController {

    private final ReportService reportService;

    @Autowired
    public ReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    @GetMapping("/getReportsByUserId/{userId}")
    public List<Report> getReportsByUserId(@PathVariable int userId) {
        return reportService.getReportsByUserId(userId);
    }

    @PutMapping("/updateReport")
    public ResponseEntity<Report> updateReport(@RequestBody Report report) {
        reportService.updateReport(report);
        return ResponseEntity.ok(report);
    }

    @DeleteMapping("/deleteReport/{id}")
    public ResponseEntity<String> deleteReport(@PathVariable int id) {
        reportService.deleteReport(id);
        return ResponseEntity.ok("Report deleted successfully");
    }
}

