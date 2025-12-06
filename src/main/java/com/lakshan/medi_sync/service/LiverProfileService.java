package com.lakshan.medi_sync.service;

import com.lakshan.medi_sync.entity.LiverProfile;
import com.lakshan.medi_sync.repository.LiverProfileRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LiverProfileService {

    private final LiverProfileRepository liverRepository;

    @Autowired
    public LiverProfileService(LiverProfileRepository liverRepository) {
        this.liverRepository = liverRepository;
    }

    public void addNewLiverProfile(LiverProfile liverProfile) {
        liverRepository.save(liverProfile);
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

    public void updateLiverProfileRecord(LiverProfile liverProfile) {
        if (liverRepository.existsById(liverProfile.getId()))
            liverRepository.save(liverProfile);
        else
            throw new IllegalArgumentException("Record not found");
    }

    public void deleteLiverProfileRecord(int id) {
        if (liverRepository.existsById(id))
            liverRepository.deleteById(id);
        else
            throw new IllegalArgumentException("Record not found");
    }
}

