package model.bean;

import java.sql.Timestamp;

public class Discount {
    private int id;
    private String name;
    private Timestamp startDate;
    private Timestamp endDate;
    private double percentageOff;

    public Discount() {
    }

    public Discount(int id, String name, Timestamp startDate, Timestamp endDate, double percentageOff) {
        this.id = id;
        this.name = name;
        this.startDate = startDate;
        this.endDate = endDate;
        this.percentageOff = percentageOff;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public double getPercentageOff() {
        return percentageOff;
    }

    public void setPercentageOff(double percentageOff) {
        this.percentageOff = percentageOff;
    }
}