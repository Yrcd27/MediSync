package com.lakshan.medi_sync.service;

import com.lakshan.medi_sync.entity.UrineReport;
import com.lakshan.medi_sync.repository.UrineReportRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UrineReportService {

    private final UrineReportRepository urineRepository;

    @Autowired
    public UrineReportService(UrineReportRepository urineRepository) {
        this.urineRepository = urineRepository;
    }

    public void addNewUrineReport(UrineReport urineReport) {
        urineRepository.save(urineReport);
    }

    public List<UrineReport> getAllUrineReportRecords() {
        return urineRepository.findAll();
    }

    public UrineReport getUrineReportRecordById(int id) {
        return urineRepository.findById(id).orElseThrow(() ->
                new IllegalArgumentException("Record not found"));
    }

    public List<UrineReport> getUrineReportRecordsByUserId(int userId) {
        if (urineRepository.findByUserId(userId).isEmpty()) {
            throw new IllegalArgumentException("User not found");
        }
        return urineRepository.findByUserId(userId);
    }

    public void updateUrineReportRecord(UrineReport urineReport) {
        if (urineRepository.existsById(urineReport.getId()))
            urineRepository.save(urineReport);
        else
            throw new IllegalArgumentException("Record not found");
    }

    public void deleteUrineReportRecord(int id) {
        if (urineRepository.existsById(id))
            urineRepository.deleteById(id);
        else
            throw new IllegalArgumentException("Record not found");
    }
}

