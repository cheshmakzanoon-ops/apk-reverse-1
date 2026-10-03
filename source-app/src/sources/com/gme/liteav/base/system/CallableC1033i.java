package com.gme.liteav.base.system;

import android.os.Build;
import java.util.concurrent.Callable;

final class CallableC1033i implements Callable {

    private static final CallableC1033i f724a = new CallableC1033i();

    private CallableC1033i() {
    }

    public static Callable m979a() {
        return f724a;
    }

    @Override
    public final Object call() {
        return Build.MODEL;
    }
}
