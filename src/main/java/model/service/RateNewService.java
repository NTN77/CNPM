package model.service;

import model.bean.RateNew;
import model.dao.RateNewDAO;

public class RateNewService {
    public static RateNewService instance;

    public static RateNewService getInstance() {
        if (instance == null) instance = new RateNewService();
        return instance;
    }

    public int insertRate(RateNew rateNew) {
        return RateNewDAO.insertRate(rateNew);
    }
}
