package com.lakshan.medi_sync.service;

import com.lakshan.medi_sync.entity.FullBloodCount;
import com.lakshan.medi_sync.repository.FullBloodCountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FullBloodCountService {

    private final FullBloodCountRepository fbcRepository;

    @Autowired
    public FullBloodCountService(FullBloodCountRepository fbcRepository) {
        this.fbcRepository = fbcRepository;
    }

    public void addNewFullBloodCount(FullBloodCount fullBloodCount) {
        fbcRepository.save(fullBloodCount);
    }

    public List<FullBloodCount> getAllFullBloodCountRecords() {
        return fbcRepository.findAll();
    }

    public FullBloodCount getFullBloodCountRecordById(int id) {
        return fbcRepository.findById(id).orElseThrow(() ->
                new IllegalArgumentException("Record not found"));
    }

    public List<FullBloodCount> getFullBloodCountRecordsByUserId(int userId) {
        if(fbcRepository.findByUserId(userId).isEmpty()) {
            throw new IllegalArgumentException("User not found");
        }
        return fbcRepository.findByUserId(userId);
    }

    public void updateFullBloodCountRecord(FullBloodCount fullBloodCount){
        if(fbcRepository.existsById(fullBloodCount.getId()))
            fbcRepository.save(fullBloodCount);
        else
            throw new IllegalArgumentException("Record not found");
    }

    public void deleteFullBloodCountRecord(int id) {
        if(fbcRepository.existsById(id))
            fbcRepository.deleteById(id);
        else
            throw new IllegalArgumentException("Record not found");
    }
}
