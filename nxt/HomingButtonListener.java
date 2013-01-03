import lejos.nxt.*;
import lejos.nxt.comm.*;
import java.util.*;

public class HomingButtonListener implements ButtonListener {
        NXTRegulatedMotor motor1, motor2, currentMotor;
        boolean flipDirection = false;


        public HomingButtonListener(NXTRegulatedMotor m1, NXTRegulatedMotor m2) {
                motor1 = m1;
                motor2 = m2;

                initMotor(m1, false);

                Button.LEFT.addButtonListener(this);
                Button.RIGHT.addButtonListener(this);
                Button.ENTER.addButtonListener(this);

        }

        public void buttonPressed(Button b) {
                switch (b.getId()) {
                case Button.ID_LEFT:
                        moveMotor(true);
                        break;

                case Button.ID_RIGHT:
                        moveMotor(false);
                        break;

                case Button.ID_ENTER:
                        stopMotor();

                        if (currentMotor == motor1) {
                                initMotor(motor2, true);
                        } else if (currentMotor == motor2) {
                                // there's no removeButtonListener!
                                currentMotor = null;
                                LCD.drawString("Homing done.", 0, 1);
                                Floorbot.homingFinished();
                        }
                        break;
                }
        }

        public void buttonReleased(Button b) {
                stopMotor();
        }

        private void initMotor(NXTRegulatedMotor m, boolean flipDir) {
                currentMotor = m;
                flipDirection = flipDir;

                stopMotor();

                String name = m == motor1 ? "A" : "B";

                LCD.drawString("Homing motor " + name, 0, 1);
        }

        private void moveMotor(boolean forward) {
                if (currentMotor == null) return;

                currentMotor.setSpeed(currentMotor.getMaxSpeed());

                if (forward ^ !flipDirection) {
                        LCD.drawString("Forward " + forward + " " + flipDirection, 0, 2);
                        currentMotor.forward();
                } else {
                        LCD.drawString("Backward " + forward + " " + flipDirection, 0, 2);
                        currentMotor.backward();
                }
        }

        private void stopMotor() {
                if (currentMotor == null) return;

                currentMotor.flt();
        }
}
