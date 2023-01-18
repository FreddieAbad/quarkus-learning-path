//https://www.youtube.com/watch?v=5x_Nxdz_ZOs&ab_channel=LaGeekipediaDeErnesto
package org.example;

public class HiloProceso extends Thread {

    @Override
    public void run() {
        for (int i = 0; i <= 5; i++) {
            System.out.println(this.getName() + " Paso " + i);
            try {
                HiloProceso.sleep(1000);
            } catch (InterruptedException e) {
                System.out.println("Error dentro de la clase "+e);
            }
        }
        System.out.println("");
    }

}
