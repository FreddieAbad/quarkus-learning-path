package org.acme.api;

import java.time.LocalDateTime;
import java.util.List;
import org.acme.repository.TransactionRepository;
import org.acme.transaction.model.Transaction;

import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.Response;

import org.acme.transaction.model.TxType;
import org.bson.types.ObjectId;
import org.eclipse.microprofile.metrics.MetricUnits;
import org.eclipse.microprofile.metrics.annotation.Counted;
import org.eclipse.microprofile.metrics.annotation.Timed;
import org.jboss.logging.Logger;

@Path("/transactions")
@Consumes("application/json")
@Produces("application/json")
public class TransactionResource {
    Logger logger = Logger.getLogger(String.valueOf(TransactionResource.class));

    @Inject
    TransactionRepository repository;

    @POST
    public Transaction addTransaction(Transaction tx){
        repository.persist(tx);
        return tx;
    }

    @GET
    @Path("/{account}")
    /*metrica que da promedio de tiempo de consulta */
    @Timed(
            name = "promedio-consulta-cuentas",
            unit = MetricUnits.SECONDS,
            description = "Promedio duracion consulta cuenta"
    )
    /*metrica que da veces de  consulta */
    @Counted(
            name = "cantidad-consultas-cuentas",
            displayName = "Numero de consultas cuentas",
            description = "Cuantas consultas de cuentas se han procesado"
    )
    public List <Transaction> getTransactions(@PathParam("account") String account){
        return repository.findByAccounts(account);
    }

    @GET
    @Path("/{account}/date/{date}")
    public List <Transaction> getTransactionsByDate(@PathParam("account") String account, @PathParam("date")
                                                    String dateString){
        logger.info("Busqueda por Cuenta: "+account+ " y Fecha: "+dateString);
        LocalDateTime ld= LocalDateTime.parse(dateString+"T00:00:00");
        logger.info("Local date parsed: "+ld.toString());
        return repository.findTxByAccountsAndDate(account, ld);
    }

    @GET
    @Path("/search/{word}")
    public List <Transaction> getByDescription(@PathParam("word") String word){
        return repository.findByDescription(word);
    }

    @GET
    @Path("/balance/{account}")
    public Double getBalance(@PathParam("account") String account){
        return calculateBalance(repository.findByAccounts(account));
    }

    private Double calculateBalance(List<Transaction> transaction){
        logger.info("Inicia CalculateBalanceV2(...) :"+ transaction.size());
        return transaction.stream().map(tx -> TxType.DEBIT.equals(tx.getType()) ?
                (tx.getValue() * -1):tx.getValue()).reduce(0d, Double::sum);
    }

    @PUT
    @Path("/{id}")
    public Response update (@PathParam("id") String id, Transaction transaction){
        Transaction tx = repository.findById(new ObjectId(id));
        if (tx != null){
            logger.info("Trx encontrada, se actualiza");
            transaction.id = new ObjectId(id);
            repository.update(transaction);
            return Response.status(200).build();
        }
        logger.info("Trx no encontrada, fin");
        return Response.status(404).entity("Identificador"+id + "no encontrado").build();
    }

}




/*
    en codigo
    @GET
    @Path("/{account}")
    */
/*metrica que da promedio de tiempo de consulta *//*

    @Timed(
            name = "promedio-consulta-cuentas",
            unit = MetricUnits.SECONDS,
            description = "Promedio duracion consulta cuenta"
    )
    */
/*metrica que da veces de  consulta *//*

    @Counted(
            name = "cantidad-consultas-cuentas",
            displayName = "Numero de consultas cuentas",
            description = "Cuantas consultas de cuentas se han procesado"
    )
------
    en terminal
curl --header "Accept:application/json" localhost:8080/metrics
-----
Comando Compilacion nativa
./mvnw package -Pnative -Dquarkus.native.container-build=true

*/
