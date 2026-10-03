package com.joke.plugin.bmJiasu;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import com.joke.connectdevice.utils.BmAutoConfig;
import com.joke.plugin.bmJiasu.xhook.JiaSuUtils;
import com.joke.speedfloatingball.utils.MLog;

public class BmFloatSpeedView {
    private static final Handler HANDLER = new Handler(Looper.getMainLooper());
    private static final String KEY_SPEED = "KEY_SPEED_NUMER";

    public BmFloatSpeedLayout initView(final Context context) {
        BmFloatSpeedLayout layout = new BmFloatSpeedLayout(context, null);
        layout.setSpeedChangeListener(new BmSpeedChangeListener() {
            @Override
            public final void onSpeedChange(int i, double d, int i2) {
                BmFloatSpeedView.lambda$initView$0(context, i, d, i2);
            }
        });
        return layout;
    }

    static void lambda$initView$0(final Context context, int type, final double speed, final int speedMode) {
        if (type == 2) {
            JiaSuUtils.setJiasu(2, speed);
        } else if (type == 3) {
            JiaSuUtils.setJiasu(3, speed);
        }
        HANDLER.postDelayed(new Runnable() {
            @Override
            public final void run() {
                BmAutoConfig.setFloat(context, (float) speed, BmFloatSpeedView.KEY_SPEED + JiaSuModeConfig.getSpeedKeySuffix(speedMode));
            }
        }, 200L);
    }

    public void initSpeed(Context context) {
        try {
            JiaSuUtils.initXHook(context, JiaSuModeConfig.getCurrentMode(context));
        } catch (Exception e) {
            MLog.m2e(e);
        }
    }
}
