package com.gme.liteav.base;

import java.util.concurrent.Callable;

final class CallableC1002a implements Callable {

    private static final CallableC1002a f603a = new CallableC1002a();

    private CallableC1002a() {
    }

    public static Callable m953a() {
        return f603a;
    }

    @Override
    public final Object call() {
        return PathUtils.setPrivateDataDirectorySuffixInternal();
    }
}
