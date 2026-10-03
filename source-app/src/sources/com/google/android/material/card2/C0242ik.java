package com.google.android.material.card2;

import java.io.Closeable;
import java.io.Flushable;

public final class C0242ik implements Closeable, Flushable {

    final C0307kv f504id;

    final InterfaceC0310ky f505ie;

    public static C0307kv m4875(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0242ik) obj).f504id;
        }
        return null;
    }

    public static C0307kv m4876(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m4875((C0242ik) obj);
        }
        return null;
    }

    @Override
    public void close() {
        C0449ye.m9097(C0455za.m10123(this));
    }

    @Override
    public void flush() {
        C0457zc.m10703(C0455za.m10123(this));
    }
}
