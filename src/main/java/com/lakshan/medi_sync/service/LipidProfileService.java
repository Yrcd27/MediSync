package com.lakshan.medi_sync.service;

import com.lakshan.medi_sync.entity.LipidProfile;
import com.lakshan.medi_sync.entity.Report;
import com.lakshan.medi_sync.repository.LipidProfileRepository;
import com.lakshan.medi_sync.repository.ReportRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LipidProfileService {

    private final LipidProfileRepository lipidRepository;
    private final ReportRepository reportRepository;

    @Autowired
    public LipidProfileService(LipidProfileRepository lipidRepository, ReportRepository reportRepository) {
        this.lipidRepository = lipidRepository;
        this.reportRepository = reportRepository;
    }

    @Transactional
    public void addNewLipidProfile(LipidProfile lipidProfile) {
        lipidRepository.save(lipidProfile);

        Report report = new Report();
        report.setUser(lipidProfile.getUser());
        report.setLipidProfile(lipidProfile);
        report.setReportDate(lipidProfile.getTestDate());
        reportRepository.save(report);
    }

    public List<LipidProfile> getAllLipidProfileRecords() {
        return lipidRepository.findAll();
    }

    public LipidProfile getLipidProfileRecordById(int id) {
        return lipidRepository.findById(id).orElseThrow(() ->
                new IllegalArgumentException("Record not found"));
    }

    public List<LipidProfile> getLipidProfileRecordsByUserId(int userId) {
        if (lipidRepository.findByUserId(userId).isEmpty()) {
            throw new IllegalArgumentException("User not found");
        }
        return lipidRepository.findByUserId(userId);
    }

    @Transactional
    public void updateLipidProfileRecord(LipidProfile lipidProfile) {
        if (lipidRepository.existsById(lipidProfile.getId())) {
            lipidRepository.save(lipidProfile);

            Report report = reportRepository.findByLipidProfileId(lipidProfile.getId());
            report.setUser(lipidProfile.getUser());
            report.setLipidProfile(lipidProfile);
            report.setReportDate(lipidProfile.getTestDate());
            reportRepository.save(report);
        } else
            throw new IllegalArgumentException("Record not found");
    }

    public void deleteLipidProfileRecord(int id) {
        if (lipidRepository.existsById(id))
            lipidRepository.deleteById(id);
        else
            throw new IllegalArgumentException("Record not found");
    }
}

