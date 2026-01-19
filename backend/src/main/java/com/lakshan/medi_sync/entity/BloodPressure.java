package com.lakshan.medi_sync.entity;

import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "blood_pressure")
public class BloodPressure {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "test_date")
    private LocalDate testDate;

    @Column(name = "bp_level")
    private String bpLevel;

    @Column(name = "image_url")
    private String imageUrl;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDate getTestDate() {
        return testDate;
    }

    public void setTestDate(LocalDate testDate) {
        this.testDate = testDate;
    }

    public String getBpLevel() {
        return bpLevel;
    }

    public void setBpLevel(String bpLevel) {
        this.bpLevel = bpLevel;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
