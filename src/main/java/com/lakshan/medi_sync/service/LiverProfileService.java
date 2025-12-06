package com.lakshan.medi_sync.service;

import com.lakshan.medi_sync.entity.LiverProfile;
import com.lakshan.medi_sync.entity.Report;
import com.lakshan.medi_sync.repository.LiverProfileRepository;
import com.lakshan.medi_sync.repository.ReportRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LiverProfileService {

    private final LiverProfileRepository liverRepository;
    private final ReportRepository reportRepository;

    @Autowired
    public LiverProfileService(LiverProfileRepository liverRepository, ReportRepository reportRepository) {
        this.liverRepository = liverRepository;
        this.reportRepository = reportRepository;
    }

    @Transactional
    public void addNewLiverProfile(LiverProfile liverProfile) {
        liverRepository.save(liverProfile);

        Report report = new Report();
        report.setUser(liverProfile.getUser());
        report.setLiverProfile(liverProfile);
        report.setReportDate(liverProfile.getTestDate());
        reportRepository.save(report);
    }

    public List<LiverProfile> getAllLiverProfileRecords() {
        return liverRepository.findAll();
    }

    public LiverProfile getLiverProfileRecordById(int id) {
        return liverRepository.findById(id).orElseThrow(() ->
                new IllegalArgumentException("Record not found"));
    }

    public List<LiverProfile> getLiverProfileRecordsByUserId(int userId) {
        if (liverRepository.findByUserId(userId).isEmpty()) {
            throw new IllegalArgumentException("User not found");
        }
        return liverRepository.findByUserId(userId);
    }

    @Transactional
    public void updateLiverProfileRecord(LiverProfile liverProfile) {
        if (liverRepository.existsById(liverProfile.getId())) {
            liverRepository.save(liverProfile);

            Report report = reportRepository.findByLiverProfileId(liverProfile.getId());
            report.setUser(liverProfile.getUser());
            report.setLiverProfile(liverProfile);
            report.setReportDate(liverProfile.getTestDate());
            reportRepository.save(report);
        } else
            throw new IllegalArgumentException("Record not found");
    }

    public void deleteLiverProfileRecord(int id) {
        if (liverRepository.existsById(id))
            liverRepository.deleteById(id);
        else
            throw new IllegalArgumentException("Record not found");
    }
}

