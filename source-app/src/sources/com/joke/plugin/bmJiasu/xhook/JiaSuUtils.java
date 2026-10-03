package com.joke.plugin.bmJiasu.xhook;

import android.content.Context;
import com.joke.plugin.bmJiasu.JiaSuModeConfig;
import com.joke.plugin.bmJiasu.xhook.basic.Basic;
import com.joke.plugin.bmJiasu.xhook.call.Call;
import com.joke.speedfloatingball.utils.MLog;

public final class JiaSuUtils {
    public static final int jiaSuStart = 2;
    public static final int jiaSuStop = 3;
    private static boolean xHookLoaded;

    public static void setJiasu(int type, double speed) {
        if (!xHookLoaded) {
            return;
        }
        try {
            if (type == 2) {
                Call.getInstance().setSpeed(speed);
                Basic.getInstance().refresh(true);
            } else if (type == 3) {
                Call.getInstance().stop();
                Basic.getInstance().refresh(true);
            }
        } catch (Exception e) {
            MLog.m2e(e);
        }
    }

    public static void initXHook(Context context, int speedMode) {
        if (xHookLoaded) {
            return;
        }
        try {
            int normalizedMode = JiaSuModeConfig.normalizeMode(speedMode);
            if (normalizedMode == 1) {
                Basic.getInstance().init(context);
                if (!Basic.getInstance().isInited()) {
                    return;
                }
            }
            Call.getInstance().init(context, normalizedMode);
            Call.getInstance().start();
            xHookLoaded = true;
        } catch (Exception e) {
            xHookLoaded = false;
            MLog.m2e(e);
        }
    }

    private JiaSuUtils() {
    }
}
