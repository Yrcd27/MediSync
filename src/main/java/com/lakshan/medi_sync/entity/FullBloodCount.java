package com.lakshan.medi_sync.entity;

import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "fbc")
public class FullBloodCount {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "test_date")
    private LocalDate testDate;

    @Column(name = "haemoglobin")
    private double haemoglobin;

    @Column(name = "total_leucocyte_count")
    private double totalLeucocyteCount;

    @Column(name = "platelet_count")
    private double plateletCount;

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

    public double getHaemoglobin() {
        return haemoglobin;
    }

    public void setHaemoglobin(double haemoglobin) {
        this.haemoglobin = haemoglobin;
    }

    public double getTotalLeucocyteCount() {
        return totalLeucocyteCount;
    }

    public void setTotalLeucocyteCount(double totalLeucocyteCount) {
        this.totalLeucocyteCount = totalLeucocyteCount;
    }

    public double getPlateletCount() {
        return plateletCount;
    }

    public void setPlateletCount(double plateletCount) {
        this.plateletCount = plateletCount;
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
