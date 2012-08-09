import lejos.nxt.*;
import lejos.nxt.comm.*;
import java.util.*;

/**
 * Dangler controls a robot hanging from two strings.
 */
public class Dangler {
        static final int MAX_SPEED = 300;
        static final int PEN_SPEED = 50;
        static final int PEN_ROT = 30;
        static final int OFF_X = 48;
        static final int OFF_Y = 0;
        static final int WIDTH = 610; // mm
        static final double MM_REV = 4.762; // mm per revolution
        static final int START_X = 0;//WIDTH / 2;
        static final int START_Y = START_X;
        static int curX = START_X;
        static int curY = START_Y;
        static boolean penDown = true;



        public static void main(String[] args) {
                //RConsole.openUSB(15000);
                //RConsole.openBluetooth(1000);

                int[] pos = Data.data;
                //int[] pos = star();

                int total = pos.length / 3;

                for (int i = 0; i < pos.length;) {
                        int pen = pos[i];
                        int x = pos[i+1];
                        int y = pos[i+2];
                        if (pen == 0) penUp(); else penDown();
                        int step = (int)(i / 3);
                        RConsole.println(step + "/" + total + ": going to " + x + "," + y);
                        LCD.drawString(step + "/" + total, 0, 3);
                        if (!go(x, y)) break;
                        i = i + 3;
                }
                //Button.waitForPress();
        }


        static int[] lines() {
                return new int[] {
                        0, -10, -10,
                        1, -10,  10,
                        1,  10,  10,
                        1,  10, -10,
                        0,  0,  0,
                };
        }

        static int[] grid() {
                int size = 5;
                int step = 2;

                return new int[] {
                        0, -6, -6,
                        1, -6, -6,
                        0, -4, -6,
                        1, -4, -6,
                        0, -2, -6,
                        1, -2, -6,
                        0, -0, -6,
                        1, -0, -6,

                        0, -6, -0,
                        1, -6, -0,
                        0, -4, -0,
                        1, -4, -0,
                        0, -2, -0,
                        1, -2, -0,
                        0, -0, -0,
                        1, -0, -0,

                        0,  6,  6,
                        1,  6,  6,
                        0,  4,  6,
                        1,  4,  6,
                        0,  2,  6,
                        1,  2,  6,
                        0,  0,  6,
                        1,  0,  6,

                        0,  0,  0,
                        1,  0,  0
                };
                        /*
                for (int x = -size; x <= size; x += step) {
                        for (int y = -size; y <= size; y += step) {
                                pos[x*3 + y*x + 0] = 0;
                                pos[x*3 + y*x + 1] = x;
                                pos[x*3 + y*x + 2] = y;
                        }
                }
                        */
        }

        static int[] square() {
                return new int[] {
                        1, 0, 10,
                        1, 10, 10,
                        1, 10, 0,
                        1, 0, 0 };
        }

        static int[] star() {
                return new int[] {
                        0, 0, -7, // top
                        1, -5,  0,
                        1, -15, 0, // left
                        1, -7,  4,
                        1, -9,  10, // l bot
                        1, 0, 5,
                        1, 9, 10, // r bot
                        1, 7, 4,
                        1, 15, 0,  // right
                        1, 5, 0,
                        1, 0, -10,
                        0, 0, 0,
                        1, 0, 0
                };
        }



        static boolean go(int px, int py) {
                px += START_X;
                py += START_Y;

                int[] cr = rect2hyp(curX, curY);
                int[] nw = rect2hyp(px, py);

                int diffa = nw[0] - cr[0];
                int diffb = nw[1] - cr[1];

                int da = mmToDegrees(diffa);
                int db = mmToDegrees(diffb);

                // the larger goes at max speed
                int spdA = 0;
                int spdB = 0;

                if (Math.abs(da) > 0 && Math.abs(db) > 0) {
                        if (Math.abs(da) > Math.abs(db)) {
                                spdA = MAX_SPEED;
                                spdB = (int)Math.abs(((float)db / (float)da) * (float)MAX_SPEED);
                        } else {
                                spdA = (int)Math.abs(((float)da / (float)db) * (float)MAX_SPEED);
                                spdB = MAX_SPEED;
                        }
                } else if (Math.abs(da) > 0) {
                        spdA = MAX_SPEED;
                        spdB = 0;
                } else if (Math.abs(db) > 0) {
                        spdA = 0;
                        spdB = MAX_SPEED;
                // } else {
                //         RConsole.println("speed confusion " + da + "," + db);
                //         return false;
                }

                if (spdA == 0 || spdB == 0) {
                        RConsole.println("zero speed: " + spdA + "," + spdB);
                        //return;
                }

                RConsole.println("  dist: " + da + "," + db);
                RConsole.println("  speed: " + spdA + "," + spdB);

                if (spdA > 0) Motor.A.setSpeed(spdA);
                if (spdB > 0) Motor.B.setSpeed(spdB);

                if (spdA > 0) Motor.A.rotate(da, true);
                if (spdB > 0) Motor.B.rotate(db, true);

                boolean keep = true;
                while (keep &&
                       (Motor.A.isMoving() || Motor.B.isMoving())) 
                {
                        if (Button.ENTER.isDown() || 
                            Button.ENTER.isDown()) {
                                keep = false;
                        }
                        //RConsole.println(".");
                        try { Thread.sleep(500); }
                        catch (InterruptedException e) {};
                }

                curX = px;
                curY = py;

                //Sound.playTone(500, 150);

                return keep;
        }

        static int[] rect2hyp(double px, double py) {
                double a = Math.sqrt(Math.pow(px - OFF_X, 2) +
                                     Math.pow(py - OFF_Y, 2));
                double b = Math.sqrt(Math.pow(WIDTH - px - OFF_X, 2) +
                                     Math.pow(py - OFF_Y, 2));
                int[] p = {(int)a,(int)b};
                return p;
        }

        static int mmToDegrees(int mm) {
                return (int)((mm / MM_REV) * 360);
        }

        static void penUp() {
                if (!penDown) return;
                Motor.C.setSpeed(PEN_SPEED);
                Motor.C.rotate(-PEN_ROT);
                penDown = false;
        }

        static void penDown() {
                if (penDown) return;
                Motor.C.setSpeed(PEN_SPEED);
                Motor.C.rotate(PEN_ROT);
                penDown = true;
        }
}
