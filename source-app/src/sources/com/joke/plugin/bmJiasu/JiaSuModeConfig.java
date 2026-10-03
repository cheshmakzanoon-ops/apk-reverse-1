package com.joke.plugin.bmJiasu;

import android.content.Context;
import com.joke.connectdevice.utils.BmAutoConfig;

public final class JiaSuModeConfig {
    private static final String KEY_SPEED_MODE = "SpeedMode";
    public static final int MODE_CORE1 = 1;
    public static final int MODE_CORE2 = 2;
    public static final int MODE_CORE3 = 3;

    private JiaSuModeConfig() {
    }

    public static int getCurrentMode(Context context) {
        return normalizeMode(BmAutoConfig.getInt(context, KEY_SPEED_MODE, getBuildDefaultMode()));
    }

    public static void setCurrentMode(Context context, int speedMode) {
        int normalizedMode = normalizeMode(speedMode);
        boolean commit = BmAutoConfig.setIntCommit(context, normalizedMode, KEY_SPEED_MODE);
        if (!commit) {
            BmAutoConfig.setInt(context, normalizedMode, KEY_SPEED_MODE);
        }
    }

    public static int normalizeMode(int speedMode) {
        if (speedMode == 2 || speedMode == 3) {
            return speedMode;
        }
        return 1;
    }

    public static String getSpeedKeySuffix(int speedMode) {
        return String.valueOf(normalizeMode(speedMode));
    }

    public static String getModeLabel(int speedMode) {
        switch (normalizeMode(speedMode)) {
            case 2:
                return "Core2";
            case 3:
                return "Core3";
            default:
                return "Core1";
        }
    }

    public static int getBuildDefaultMode() {
        return 1;
    }
}
