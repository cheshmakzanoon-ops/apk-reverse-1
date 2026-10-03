package com.gme.liteav.base.system;

import android.os.Build;
import java.util.concurrent.Callable;

final class CallableC1031g implements Callable {

    private static final CallableC1031g f722a = new CallableC1031g();

    private CallableC1031g() {
    }

    public static Callable m977a() {
        return f722a;
    }

    @Override
    public final Object call() {
        return Build.SUPPORTED_ABIS;
    }
}
