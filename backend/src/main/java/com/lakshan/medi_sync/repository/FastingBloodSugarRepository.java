package com.lakshan.medi_sync.repository;

import com.lakshan.medi_sync.entity.FastingBloodSugar;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FastingBloodSugarRepository extends JpaRepository<FastingBloodSugar, Integer> {
    List<FastingBloodSugar> findByUserId(int userId);
}
