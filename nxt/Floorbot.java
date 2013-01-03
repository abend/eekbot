import lejos.nxt.*;
import lejos.nxt.comm.*;
import java.util.*;

/**
 * Floorbot controls a robot with two threaded rods and a remote stylus.
 */
public class Floorbot {
        /** Span between the center of the base points of the triangle. */
        static final int WIDTH = 450; // mm
        static final int OFF_X = WIDTH / 2;
        /** Distance from center of base to drawing tip when tip is at logical 0,0. */
        static final int OFF_Y = 540;
        static final double MM_REV = 1; // mm per revolution
        static final int START_X = 0;
        static final int START_Y = START_X;
        static int curX = START_X;
        static int curY = START_Y;
        static final int scale = 2;


        public static void main(String[] args) {
                //RConsole.open(15000);
                //RConsole.openUSB(15000);
                //RConsole.openBluetooth(1000);

                manualHome();

                Button.ESCAPE.waitForPress();
        }

        static void manualHome() {
                HomingButtonListener hbl = new HomingButtonListener(Motor.A, Motor.B);
        }

        public static void homingFinished () {
                Sound.twoBeeps();
                draw();
        }

        static void draw() {
                int[] pos = Data.data;
                //int[] pos = PresetShapes.star();

                int total = pos.length / 3;

                for (int i = 0; i < pos.length;) {
                        //int pen = pos[i];
                        int x = pos[i+1] * scale;
                        int y = pos[i+2] * scale;

                        int step = (int)(i / 3);
                        RConsole.println(step + "/" + total + ": going to " + x + "," + y);
                        LCD.drawString(step + "/" + total, 0, 3);
                        if (!go(x, y)) break;
                        i = i + 3;
                }
                LCD.drawString("Done!", 0, 3);
                //Button.waitForAnyPress(15000);
                //RConsole.close();
                //LCD.drawString("All Done!", 0, 3);
                Sound.playTone(1000, 250);
                Sound.pause(250);
                Sound.playTone(2000, 250);
                Sound.pause(250);
                Sound.playTone(4000, 500);
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
                float spdA = 0;
                float spdB = 0;

                float maxSpdA = Motor.A.getMaxSpeed();
                float maxSpdB = Motor.B.getMaxSpeed();
                float maxSpd = Math.min(maxSpdA, maxSpdB);

                if (Math.abs(da) > 0 && Math.abs(db) > 0) {
                        if (Math.abs(da) > Math.abs(db)) {
                                spdA = maxSpd;
                                spdB = (int)Math.abs(((float)db / (float)da) * (float)maxSpd);
                        } else {
                                spdA = (int)Math.abs(((float)da / (float)db) * (float)maxSpd);
                                spdB = maxSpd;
                        }
                } else if (Math.abs(da) > 0) {
                        spdA = maxSpd;
                        spdB = 0;
                } else if (Math.abs(db) > 0) {
                        spdA = 0;
                        spdB = maxSpd;
                // } else {
                //         RConsole.println("speed confusion " + da + "," + db);
                //         return false;
                }

                if (spdA == 0 || spdB == 0) {
                        RConsole.println("zero speed: " + spdA + "," + spdB);
                        //return;
                }

                //RConsole.println("  dist: " + da + "," + db);
                //RConsole.println("  speed: " + spdA + "," + spdB);
                LCD.drawString("dst: " + diffa + "," + diffb, 0, 4);
                LCD.drawString("rot: " + da + "," + db, 0, 5);
                LCD.drawString("spd: " + spdA + "," + spdB, 0, 6);

                if (spdA > 0) Motor.A.setSpeed(spdA);
                if (spdB > 0) Motor.B.setSpeed(spdB);

                if (spdA > 0) Motor.A.rotate(da, true);
                if (spdB > 0) Motor.B.rotate(-db, true); // reverse spin, motor faces other direction

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

                return keep;
        }

        /**
         * Convert from a rectangular coordinate to lengths of the
         * rods.
         */
        static int[] rect2hyp(double px, double py) {
                double a = Math.sqrt(Math.pow(OFF_X + px, 2) +
                                     Math.pow(OFF_Y + py, 2));
                double b = Math.sqrt(Math.pow(OFF_X - px, 2) +
                                     Math.pow(OFF_Y + py, 2));
                int[] p = {(int)a,(int)b};
                return p;
        }

        static int mmToDegrees(int mm) {
                return (int)((mm / MM_REV) * 360);
        }
}
