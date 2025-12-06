package com.lakshan.medi_sync.entity;

import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "reports")
public class Report {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "report_date")
    private LocalDate reportDate;

    @OneToOne
    @JoinColumn(name = "fbc_id")
    private FullBloodCount fullBloodCount;

    @OneToOne
    @JoinColumn(name = "liver_id")
    private LiverProfile liverProfile;

    @OneToOne
    @JoinColumn(name = "urine_id")
    private UrineReport urineReport;

    @OneToOne
    @JoinColumn(name = "fbs_id")
    private FastingBloodSugar fastingBloodSugar;

    @OneToOne
    @JoinColumn(name = "lipid_id")
    private LipidProfile lipidProfile;

    @OneToOne
    @JoinColumn(name = "bp_id")
    private BloodPressure bloodPressure;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDate getReportDate() {
        return reportDate;
    }

    public void setReportDate(LocalDate reportDate) {
        this.reportDate = reportDate;
    }

    public FullBloodCount getFullBloodCount() {
        return fullBloodCount;
    }

    public void setFullBloodCount(FullBloodCount fullBloodCount) {
        this.fullBloodCount = fullBloodCount;
    }

    public LiverProfile getLiverProfile() {
        return liverProfile;
    }

    public void setLiverProfile(LiverProfile liverProfile) {
        this.liverProfile = liverProfile;
    }

    public UrineReport getUrineReport() {
        return urineReport;
    }

    public void setUrineReport(UrineReport urineReport) {
        this.urineReport = urineReport;
    }

    public FastingBloodSugar getFastingBloodSugar() {
        return fastingBloodSugar;
    }

    public void setFastingBloodSugar(FastingBloodSugar fastingBloodSugar) {
        this.fastingBloodSugar = fastingBloodSugar;
    }

    public LipidProfile getLipidProfile() {
        return lipidProfile;
    }

    public void setLipidProfile(LipidProfile lipidProfile) {
        this.lipidProfile = lipidProfile;
    }

    public BloodPressure getBloodPressure() {
        return bloodPressure;
    }

    public void setBloodPressure(BloodPressure bloodPressure) {
        this.bloodPressure = bloodPressure;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
