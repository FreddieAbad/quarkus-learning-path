package org.example;

public class Proceso2 implements Runnable{
    @Override
    public void run() {
        for (int i=0; i<=20;i++){
            System.out.println("Proceso 2");
        }
    }
}
