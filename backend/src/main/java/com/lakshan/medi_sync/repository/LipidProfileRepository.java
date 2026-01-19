package com.lakshan.medi_sync.repository;

import com.lakshan.medi_sync.entity.LipidProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LipidProfileRepository extends JpaRepository<LipidProfile, Integer> {
    List<LipidProfile> findByUserId(int userId);
}

