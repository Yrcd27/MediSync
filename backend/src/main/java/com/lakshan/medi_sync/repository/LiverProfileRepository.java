package com.lakshan.medi_sync.repository;

import com.lakshan.medi_sync.entity.LiverProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LiverProfileRepository extends JpaRepository<LiverProfile, Integer> {
    List<LiverProfile> findByUserId(int userId);
}
