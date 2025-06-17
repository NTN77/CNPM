package model.service;

import model.adapter.RateDetailRequest;
import model.adapter.RateRequest;
import model.dao.RateDAO;

import java.util.List;

public class RateService {
    private static RateService instance;

    public static RateService getInstance(){
        if(instance==null) instance = new RateService();
        return instance;
    }

    public List<RateRequest> getAll() {
       return RateDAO.getAll();
    }
    public List<RateDetailRequest> getById(int id){
        return RateDAO.getRateDetailById(id);
    }
}
