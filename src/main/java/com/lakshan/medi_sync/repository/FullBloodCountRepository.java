package com.lakshan.medi_sync.repository;

import com.lakshan.medi_sync.entity.FullBloodCount;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FullBloodCountRepository extends JpaRepository<FullBloodCount, Integer> {
    List<FullBloodCount> findByUserId(int userId);
}
