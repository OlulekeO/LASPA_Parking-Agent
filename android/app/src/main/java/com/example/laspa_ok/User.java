package com.example.laspa_ok;



public class User {



    private String name;
    private String job;
    private String parkingID;
    private String id;
    private String createdAt;


    public User(String name, String job, String parkingID, String id, String createdAt) {
        this.name = name;
        this.job = job;
        this.parkingID = parkingID;
        this.id = id;
        this.createdAt = createdAt;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getJob() {
        return job;
    }
    public void setJob(String job) {
        this.job = job;
    }


    public String getParkingID() {
        return parkingID;
    }

    public void setParkingID(String ParkingID) { this.parkingID = parkingID; }


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}

