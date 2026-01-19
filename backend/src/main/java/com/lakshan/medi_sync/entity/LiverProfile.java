package com.lakshan.medi_sync.entity;

import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "liver_profile")
public class LiverProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "test_date")
    private LocalDate testDate;

    @Column(name = "protein_total_serum")
    private double proteinTotalSerum;

    @Column(name = "albumin_serum")
    private double albuminSerum;

    @Column(name = "bilirubin_total_serum")
    private double bilirubinTotalSerum;

    @Column(name = "sgpt")
    private double sgpt;

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

    public double getProteinTotalSerum() {
        return proteinTotalSerum;
    }

    public void setProteinTotalSerum(double proteinTotalSerum) {
        this.proteinTotalSerum = proteinTotalSerum;
    }

    public double getAlbuminSerum() {
        return albuminSerum;
    }

    public void setAlbuminSerum(double albuminSerum) {
        this.albuminSerum = albuminSerum;
    }

    public double getBilirubinTotalSerum() {
        return bilirubinTotalSerum;
    }

    public void setBilirubinTotalSerum(double bilirubinTotalSerum) {
        this.bilirubinTotalSerum = bilirubinTotalSerum;
    }

    public double getSgpt() {
        return sgpt;
    }

    public void setSgpt(double sgpt) {
        this.sgpt = sgpt;
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
