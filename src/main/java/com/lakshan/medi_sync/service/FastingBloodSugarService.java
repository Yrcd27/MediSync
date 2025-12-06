package com.lakshan.medi_sync.service;

import com.lakshan.medi_sync.entity.FastingBloodSugar;
import com.lakshan.medi_sync.entity.Report;
import com.lakshan.medi_sync.repository.FastingBloodSugarRepository;
import com.lakshan.medi_sync.repository.ReportRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FastingBloodSugarService {

    private final FastingBloodSugarRepository fbsRepository;
    private final ReportRepository reportRepository;

    @Autowired
    public FastingBloodSugarService(FastingBloodSugarRepository fbsRepository, ReportRepository reportRepository) {
        this.fbsRepository = fbsRepository;
        this.reportRepository = reportRepository;
    }

    @Transactional
    public void addNewFastingBloodSugarRecord(FastingBloodSugar fastingBloodSugar) {
        fbsRepository.save(fastingBloodSugar);

        Report report = new Report();
        report.setUser(fastingBloodSugar.getUser());
        report.setFastingBloodSugar(fastingBloodSugar);
        report.setReportDate(fastingBloodSugar.getTestDate());
        reportRepository.save(report);

    }

    public List<FastingBloodSugar> getAllFastingBloodSugarRecords() {
        return fbsRepository.findAll();
    }

    public FastingBloodSugar getFastingBloodSugarRecordById(int id) {
        return fbsRepository.findById(id).orElseThrow(() ->
                new IllegalArgumentException("Record not found"));
    }

    public List<FastingBloodSugar> getFastingBloodSugarRecordsByUserId(int userId) {
        if (fbsRepository.findByUserId(userId).isEmpty()) {
            throw new IllegalArgumentException("User not found");
        }
        return fbsRepository.findByUserId(userId);
    }

    @Transactional
    public void updateFastingBloodSugarRecord(FastingBloodSugar fastingBloodSugar) {
        if (fbsRepository.existsById(fastingBloodSugar.getId())) {
            fbsRepository.save(fastingBloodSugar);

            Report report = reportRepository.findByFastingBloodSugarId(fastingBloodSugar.getId());
            report.setUser(fastingBloodSugar.getUser());
            report.setFastingBloodSugar(fastingBloodSugar);
            report.setReportDate(fastingBloodSugar.getTestDate());
            reportRepository.save(report);
        } else
            throw new IllegalArgumentException("Record not found");
    }

    public void deleteFastingBloodSugarRecord(int id) {
        if (fbsRepository.existsById(id))
            fbsRepository.deleteById(id);
        else
            throw new IllegalArgumentException("Record not found");
    }
}
