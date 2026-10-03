package com.gme.liteav.base.system;

import android.os.Build;
import java.util.concurrent.Callable;

final class CallableC1035k implements Callable {

    private static final CallableC1035k f726a = new CallableC1035k();

    private CallableC1035k() {
    }

    public static Callable m981a() {
        return f726a;
    }

    @Override
    public final Object call() {
        return Build.MANUFACTURER;
    }
}
