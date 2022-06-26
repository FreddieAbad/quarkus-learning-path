package org.acme.transaction.model;

import io.quarkus.mongodb.panache.PanacheMongoEntity;

import java.time.LocalDate;

public class Transaction extends PanacheMongoEntity {
    public String account;
    public Double value;
    public LocalDate date;
    public TxType type;
    public String description;
    public Transaction(){}
    public String getAccount(){
        return account;
    }
    public void setAccount(String account){
        this.account=account;
    }
    public Double getValue(){
        return value;
    }
    public void setValue(Double value){
        this.value=value;
    }

    public LocalDate getDate(){
        return date;
    }
    public void setDate(LocalDate date){
        this.date=date;
    }

    public TxType getType(){
        return type;
    }
    public void setType(TxType type){
        this.type=type;
    }

    public String getDescription(){
        return description;
    }
    public void setDescription(String description){
        this.description=description;
    }
}
