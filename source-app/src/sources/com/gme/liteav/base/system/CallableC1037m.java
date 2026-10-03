package com.gme.liteav.base.system;

import android.os.Build;
import java.util.concurrent.Callable;

final class CallableC1037m implements Callable {

    private static final CallableC1037m f728a = new CallableC1037m();

    private CallableC1037m() {
    }

    public static Callable m983a() {
        return f728a;
    }

    @Override
    public final Object call() {
        return Build.VERSION.RELEASE;
    }
}
