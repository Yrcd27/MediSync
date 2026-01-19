package com.lakshan.medi_sync.entity;

import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "fbs")
public class FastingBloodSugar {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "test_date")
    private LocalDate testDate;

    @Column(name = "fbs_level")
    private double fbsLevel;

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

    public double getFbsLevel() {
        return fbsLevel;
    }

    public void setFbsLevel(double fbsLevel) {
        this.fbsLevel = fbsLevel;
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

    @Override
    public String toString() {
        return "FastingBloodSugar{" +
                "id=" + id +
                ", testDate=" + testDate +
                ", fbsLevel=" + fbsLevel +
                ", imageUrl='" + imageUrl + '\'' +
                ", user=" + user +
                '}';
    }
}
