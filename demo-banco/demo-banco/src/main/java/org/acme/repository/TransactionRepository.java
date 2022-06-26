package org.acme.repository;

import io.quarkus.mongodb.panache.PanacheMongoRepository;
import org.acme.transaction.model.Transaction;

import java.time.LocalDateTime;
import java.util.List;
import javax.enterprise.context.ApplicationScoped;
import org.acme.transaction.model.Transaction;

@ApplicationScoped
public class TransactionRepository implements PanacheMongoRepository<Transaction> {
    public List<Transaction> findByAccounts(String account){
        return list("account", account);
    }

    public List<Transaction> findTxByAccountsAndDate(String account, LocalDateTime date){
        return find("account = ?1 and date = ?2", account, date).list();
    }

    public List<Transaction> findByDescription(String desc){
        String regex = "(?i).*"+desc + ".*"; //case insensitive, que contenga el string recibido como parametro
        return find("description like ?1", regex).list();
    }

}
