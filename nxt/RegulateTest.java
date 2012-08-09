import lejos.nxt.*;
import lejos.util.*;

/**
 * Test the accuracy of motor speed regulation.
 * @author Roger
 */
public class RegulateTest
{
        Stopwatch sw = new Stopwatch();
        Motor [] m = {Motor.A, Motor.B, Motor.C}; //build an array of motors

        /**
         * Display program name, wait for button, then call go/
         * @param args
         */
        public static void main( String[] args)
        {
                LCD.drawString(" Reg Test", 0, 0);
                Button.waitForPress();
                LCD.clear();
                new RegulateTest().go();
        }
        /**
         * performs the test twice,  with and without speed regulation.
         */
        public void go()
        {
                for( int i = 0; i<3; i++)m[i].setSpeed(720);
                step();
                for( int i = 0; i<3; i++)m[i].regulateSpeed(false);
                step();
        }
        /**
         * helper method - does the detailed work; resets tacho count, runs motors,
         * displays data
         */
        public void step()
        {
                LCD.clear();
                sw.reset();
                for( int i = 0; i<3; i++)m[i].resetTachoCount();
                for( int i = 0; i<3; i++)m[i].forward();
                for(int r = 0 ; r<8; r++)
                {
                        while(sw.elapsed() < 200* r)Thread.yield();
                        for( int i = 0; i<3; i++)
                                LCD.drawInt(m[i].getTachoCount(),5*i,r);
                }
                for( int i = 0; i<3; i++)m[i].stop();
                Button.waitForPress();
        }

}
