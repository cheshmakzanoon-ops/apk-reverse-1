package com.gme.liteav.base.system;

import android.os.Build;
import java.util.concurrent.Callable;

final class CallableC1039o implements Callable {

    private static final CallableC1039o f730a = new CallableC1039o();

    private CallableC1039o() {
    }

    public static Callable m985a() {
        return f730a;
    }

    @Override
    public final Object call() {
        return Build.BOARD;
    }
}
