package net.aihelp.utils;

public class FastClickValidator {
    private static long lastClickTime;

    public static boolean validate(float f) {
        long jCurrentTimeMillis = System.currentTimeMillis();
        boolean z = ((float) (jCurrentTimeMillis - lastClickTime)) > f * 1000.0f;
        lastClickTime = jCurrentTimeMillis;
        return z;
    }

    public static boolean validate() {
        return validate(1.0f);
    }
}
