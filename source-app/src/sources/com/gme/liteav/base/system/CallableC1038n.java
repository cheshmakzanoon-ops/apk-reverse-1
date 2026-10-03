package com.gme.liteav.base.system;

import android.os.Build;
import java.util.concurrent.Callable;

final class CallableC1038n implements Callable {

    private static final CallableC1038n f729a = new CallableC1038n();

    private CallableC1038n() {
    }

    public static Callable m984a() {
        return f729a;
    }

    @Override
    public final Object call() {
        return Integer.valueOf(Build.VERSION.SDK_INT);
    }
}
