package org.example;

public class ClasePrincipal {
    public static void main(String[] args) {
        /*for (int i=0; i<=20;i++){
            System.out.println("Proceso 1");
        }
        System.out.println("");
        for (int i=0; i<=20;i++){
            System.out.println("Proceso 2");
        }*/

       /* Proceso1 proceso1 = new Proceso1();
        Proceso1 proceso3 = new Proceso1();

        Thread proceso2 = new Thread(new Proceso2());
        proceso1.start();
        proceso3.start();
        proceso2.start();*/

        /*Proceso proceso1 = new Proceso(" Hilo 1 ");
        Proceso proceso2 = new Proceso(" Hilo 2 ");
        Proceso proceso3 = new Proceso(" Hilo 3 ");
        proceso2.ValorDeLaCondicion(5);
        proceso1.ValorDeLaCondicion(3);
        proceso3.ValorDeLaCondicion(3);
        proceso1.start();
        proceso2.start();
        proceso3.start();*/


        /*//creo pero no ejecuto
        HiloProceso hiloProceso1 = new HiloProceso();
        HiloProceso hiloProceso2 = new HiloProceso();
        //inicio hilo
        hiloProceso2.start();
        //duermo hilo
        try {
            hiloProceso2.sleep(1000);
        } catch (InterruptedException e) {
            System.out.println("Excepcion en hilo2 "+e);
        }

        hiloProceso1.start();
        hiloProceso1.stop();
        try {
            hiloProceso1.sleep(3000);
        } catch (InterruptedException e) {
            System.out.println("Excepcion en hilo1 "+ e);
        }*/

        Hilo1 hilo1 = new Hilo1();
        Hilo2 hilo2 = new Hilo2();
        Hilo3 hilo3 = new Hilo3();
        Hilo4 hilo4 = new Hilo4();
        hilo1.start();
        try{
            hilo1.sleep(10);
        }catch (InterruptedException e){
            System.out.println(e);
        }
        hilo2.start();
        try{
            hilo2.sleep(10);
        }catch (InterruptedException e){
            System.out.println(e);
        }
        hilo3.start();
        try{
            hilo3.sleep(10);
        }catch (InterruptedException e){
            System.out.println(e);
        }
        hilo4.start();
        try{
            hilo4.sleep(10);
        }catch (InterruptedException e){
            System.out.println(e);
        }
    }
}
