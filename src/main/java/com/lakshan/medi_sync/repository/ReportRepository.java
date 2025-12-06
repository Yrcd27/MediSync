package com.lakshan.medi_sync.repository;

import com.lakshan.medi_sync.entity.Report;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReportRepository extends JpaRepository<Report, Integer> {
    List<Report> findByUserId(int userId);
}
