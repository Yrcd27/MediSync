package com.lakshan.medi_sync.service;

import com.lakshan.medi_sync.entity.BloodPressure;
import com.lakshan.medi_sync.repository.BloodPressureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BloodPressureService {

    private final BloodPressureRepository bpRepository;

    @Autowired
    public BloodPressureService(BloodPressureRepository bpRepository) {
        this.bpRepository = bpRepository;
    }

    public void addNewBloodPressureRecord(BloodPressure bloodPressure) {
        bpRepository.save(bloodPressure);
    }

    public List<BloodPressure> getAllBloodPressureRecords() {
        return bpRepository.findAll();
    }

    public BloodPressure getBloodPressureRecordById(int id) {
        return bpRepository.findById(id).orElseThrow(() ->
                new IllegalArgumentException("Record not found"));
    }

    public List<BloodPressure> getBloodPressureRecordsByUserId(int userId) {
        if(bpRepository.findByUserId(userId).isEmpty()) {
            throw new IllegalArgumentException("User not found");
        }
        return bpRepository.findByUserId(userId);
    }

    public void updateBloodPressureRecord(BloodPressure bloodPressure){
        if(bpRepository.existsById(bloodPressure.getId()))
            bpRepository.save(bloodPressure);
        else
            throw new IllegalArgumentException("Record not found");
    }

    public void deleteBloodPressureRecord(int id) {
        if(bpRepository.existsById(id))
            bpRepository.deleteById(id);
        else
            throw new IllegalArgumentException("Record not found");
    }
}
