package com.lakshan.medi_sync.repository;

import com.lakshan.medi_sync.entity.BloodPressure;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BloodPressureRepository extends JpaRepository<BloodPressure, Integer> {
    List<BloodPressure> findByUserId(int userId);
}
