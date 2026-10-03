package com.google.android.material.card2;

import android.content.Context;
import android.os.AsyncTask;

public class C0157fg implements InterfaceC0171fu {
    public static void m3906(Object obj) {
        if (C0448yd.m9079() <= 0) {
            C0174fx.m503a((AsyncTask<Void, Void, Void>) obj);
        }
    }

    public static void m3907(Object obj) {
        if (C0457zc.m10555() >= 0) {
            m3906((AsyncTask) obj);
        }
    }

    @Override
    public void mo474a(Context context, String str, String str2, InterfaceC0172fv interfaceC0172fv, Runnable runnable) {
        adds.m2849(new AsyncTaskC0158fh(this, str, context, interfaceC0172fv, runnable));
    }

    @Override
    public boolean mo475aE() {
        return false;
    }

    @Override
    public boolean mo476l(String str) {
        return C0458ze.m10811(str, abf.m2416());
    }
}
