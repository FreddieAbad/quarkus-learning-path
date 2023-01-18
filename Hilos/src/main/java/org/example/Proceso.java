package org.example;

public class Proceso extends Thread{
    int numero;

    public Proceso(String nombreHilo) {
        super(nombreHilo);
    }

    @Override
    public void run() {
        for (int i=0; i<=numero;i++){
            System.out.println(this.getName()+"Paso "+i);
        }
        System.out.println("");
    }
    public void ValorDeLaCondicion(int valor){
        this.numero=valor;
    }
}
