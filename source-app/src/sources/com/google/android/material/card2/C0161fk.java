package com.google.android.material.card2;

import android.content.Context;
import android.os.AsyncTask;

public class C0161fk implements InterfaceC0171fu {
    public static void m3954(Object obj) {
        if (adds.m2755() > 0) {
            C0174fx.m503a((AsyncTask<Void, Void, Void>) obj);
        }
    }

    public static void m3955(Object obj) {
        if (gggy.m4365() > 0) {
            m3954((AsyncTask) obj);
        }
    }

    @Override
    public void mo474a(Context context, String str, String str2, InterfaceC0172fv interfaceC0172fv, Runnable runnable) {
        C0448yd.m9088(new AsyncTaskC0162fl(this, context, str, interfaceC0172fv, runnable));
    }

    @Override
    public boolean mo475aE() {
        return false;
    }

    @Override
    public boolean mo476l(String str) {
        return C0458ze.m10811(str, C0461zs.m11644());
    }
}
