package com.gme.liteav.base;

import android.os.StrictMode;
import java.io.Closeable;

public final class C1004b implements Closeable {

    private final StrictMode.ThreadPolicy f606a;

    private final StrictMode.VmPolicy f607b;

    private C1004b(StrictMode.ThreadPolicy threadPolicy) {
        this.f606a = threadPolicy;
        this.f607b = null;
    }

    private C1004b(StrictMode.ThreadPolicy threadPolicy, byte b) {
        this(threadPolicy);
    }

    public static C1004b m955a() {
        return new C1004b(StrictMode.allowThreadDiskWrites(), (byte) 0);
    }

    @Override
    public final void close() {
        StrictMode.ThreadPolicy threadPolicy = this.f606a;
        if (threadPolicy != null) {
            StrictMode.setThreadPolicy(threadPolicy);
        }
        StrictMode.VmPolicy vmPolicy = this.f607b;
        if (vmPolicy != null) {
            StrictMode.setVmPolicy(vmPolicy);
        }
    }
}
