package com.google.android.gms.internal.play_billing;

import java.util.concurrent.TimeoutException;

final class zzdf extends TimeoutException {
    zzdf(String str, zzdg zzdgVar) {
        super(str);
    }

    @Override
    public final synchronized Throwable fillInStackTrace() {
        setStackTrace(new StackTraceElement[0]);
        return this;
    }
}
