package com.gme.liteav.base.util;

import com.gme.liteav.base.ContextUtils;
import java.util.concurrent.Callable;

final class CallableC1054f implements Callable {

    private static final CallableC1054f f758a = new CallableC1054f();

    private CallableC1054f() {
    }

    public static Callable m1022a() {
        return f758a;
    }

    @Override
    public final Object call() {
        return Boolean.valueOf(C1053e.m1013a(ContextUtils.getApplicationContext()));
    }
}
