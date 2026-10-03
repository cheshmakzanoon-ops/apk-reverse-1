package com.joke.plugin.bmJiasu.xhook.basic;

import android.content.Context;
import com.joke.speedfloatingball.utils.MLog;

public final class Basic {
    private static final Basic INSTANCE = new Basic();
    private boolean inited;

    public static Basic getInstance() {
        return INSTANCE;
    }

    public synchronized boolean isInited() {
        return this.inited;
    }

    public synchronized boolean init(Context context) {
        if (this.inited) {
            return true;
        }
        try {
            System.loadLibrary("basic");
            this.inited = true;
        } catch (Throwable e) {
            MLog.m2e(e);
        }
        return this.inited;
    }

    public synchronized void refresh(boolean async) {
        if (this.inited) {
            try {
                NativeHandler.getInstance().refresh(async);
            } catch (Throwable e) {
                MLog.m2e(e);
            }
        }
    }
}
