package com.gme.liteav.base.system;

import android.os.Build;
import java.util.concurrent.Callable;

final class CallableC1034j implements Callable {

    private static final CallableC1034j f725a = new CallableC1034j();

    private CallableC1034j() {
    }

    public static Callable m980a() {
        return f725a;
    }

    @Override
    public final Object call() {
        return Build.BRAND;
    }
}
