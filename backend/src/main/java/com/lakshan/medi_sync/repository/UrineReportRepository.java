package com.lakshan.medi_sync.repository;

import com.lakshan.medi_sync.entity.UrineReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UrineReportRepository extends JpaRepository<UrineReport, Integer> {
    List<UrineReport> findByUserId(int userId);
}
