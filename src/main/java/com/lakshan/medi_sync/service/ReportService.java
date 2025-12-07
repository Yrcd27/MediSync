package com.lakshan.medi_sync.service;

import com.lakshan.medi_sync.entity.Report;
import com.lakshan.medi_sync.repository.ReportRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReportService {

    private final ReportRepository reportRepository;

    @Autowired
    public ReportService(ReportRepository reportRepository) {
        this.reportRepository = reportRepository;
    }

    public List<Report> getReportsByUserId(int userId) {
        if (reportRepository.findByUserId(userId).isEmpty()) {
            throw new IllegalArgumentException("User not found");
        }
        return reportRepository.findByUserId(userId);
    }

    public void updateReport(Report report) {
        if (reportRepository.existsById(report.getId()))
            reportRepository.save(report);
        else
            throw new IllegalArgumentException("Record not found");
    }

    public void deleteReport(int id) {
        if (reportRepository.existsById(id))
            reportRepository.deleteById(id);
        else
            throw new IllegalArgumentException("Record not found");
    }
}
