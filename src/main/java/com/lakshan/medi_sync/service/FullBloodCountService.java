package com.lakshan.medi_sync.service;

import com.lakshan.medi_sync.entity.FullBloodCount;
import com.lakshan.medi_sync.entity.Report;
import com.lakshan.medi_sync.repository.FullBloodCountRepository;
import com.lakshan.medi_sync.repository.ReportRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FullBloodCountService {

    private final FullBloodCountRepository fbcRepository;
    private final ReportRepository reportRepository;

    @Autowired
    public FullBloodCountService(FullBloodCountRepository fbcRepository, ReportRepository reportRepository) {
        this.fbcRepository = fbcRepository;
        this.reportRepository = reportRepository;
    }

    @Transactional
    public void addNewFullBloodCount(FullBloodCount fullBloodCount) {
        fbcRepository.save(fullBloodCount);

        Report report = new Report();
        report.setUser(fullBloodCount.getUser());
        report.setFullBloodCount(fullBloodCount);
        report.setReportDate(fullBloodCount.getTestDate());
        reportRepository.save(report);
    }

    public List<FullBloodCount> getAllFullBloodCountRecords() {
        return fbcRepository.findAll();
    }

    public FullBloodCount getFullBloodCountRecordById(int id) {
        return fbcRepository.findById(id).orElseThrow(() ->
                new IllegalArgumentException("Record not found"));
    }

    public List<FullBloodCount> getFullBloodCountRecordsByUserId(int userId) {
        if (fbcRepository.findByUserId(userId).isEmpty()) {
            throw new IllegalArgumentException("User not found");
        }
        return fbcRepository.findByUserId(userId);
    }

    @Transactional
    public void updateFullBloodCountRecord(FullBloodCount fullBloodCount) {
        if (fbcRepository.existsById(fullBloodCount.getId())) {
            fbcRepository.save(fullBloodCount);

            Report report = reportRepository.findByFullBloodCountId(fullBloodCount.getId());
            report.setUser(fullBloodCount.getUser());
            report.setFullBloodCount(fullBloodCount);
            report.setReportDate(fullBloodCount.getTestDate());
            reportRepository.save(report);
        } else
            throw new IllegalArgumentException("Record not found");
    }

    public void deleteFullBloodCountRecord(int id) {
        if (fbcRepository.existsById(id))
            fbcRepository.deleteById(id);
        else
            throw new IllegalArgumentException("Record not found");
    }
}
