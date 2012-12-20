public class PresetShapes {

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
}
