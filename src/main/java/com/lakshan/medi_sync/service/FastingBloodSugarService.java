package com.lakshan.medi_sync.service;

import com.lakshan.medi_sync.entity.FastingBloodSugar;
import com.lakshan.medi_sync.repository.FastingBloodSugarRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FastingBloodSugarService {

    private final FastingBloodSugarRepository fbsRepository;

    @Autowired
    public FastingBloodSugarService(FastingBloodSugarRepository fbsRepository) {
        this.fbsRepository = fbsRepository;
    }

    public void addNewFastingBloodSugarRecord(FastingBloodSugar fastingBloodSugar) {
        fbsRepository.save(fastingBloodSugar);
    }

    public List<FastingBloodSugar> getAllFastingBloodSugarRecords() {
        return fbsRepository.findAll();
    }

    public FastingBloodSugar getFastingBloodSugarRecordById(int id) {
        return fbsRepository.findById(id).orElseThrow(() ->
                new IllegalArgumentException("Record not found"));
    }

    public List<FastingBloodSugar> getFastingBloodSugarRecordsByUserId(int userId) {
        if(fbsRepository.findByUserId(userId).isEmpty()) {
            throw new IllegalArgumentException("User not found");
        }
        return fbsRepository.findByUserId(userId);
    }

    public void updateFastingBloodSugarRecord(FastingBloodSugar fastingBloodSugar){
        if(fbsRepository.existsById(fastingBloodSugar.getId()))
            fbsRepository.save(fastingBloodSugar);
        else
            throw new IllegalArgumentException("Record not found");
    }

    public void deleteFastingBloodSugarRecord(int id) {
        if(fbsRepository.existsById(id))
            fbsRepository.deleteById(id);
        else
            throw new IllegalArgumentException("Record not found");
    }
}
