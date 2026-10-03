package com.google.android.material.card2;

import android.content.Context;
import android.os.AsyncTask;

public class C0159fi implements InterfaceC0171fu {
    public static void m3930(Object obj) {
        if (C0456zb.m10326() < 0) {
            C0174fx.m503a((AsyncTask<Void, Void, Void>) obj);
        }
    }

    public static void m3931(Object obj) {
        if (C0445ya.m8330() >= 0) {
            m3930((AsyncTask) obj);
        }
    }

    @Override
    public void mo474a(Context context, String str, String str2, InterfaceC0172fv interfaceC0172fv, Runnable runnable) {
        gggy.m4350(new AsyncTaskC0160fj(this, context, str, interfaceC0172fv, runnable));
    }

    @Override
    public boolean mo475aE() {
        return false;
    }

    @Override
    public boolean mo476l(String str) {
        return C0458ze.m10811(str, C0460zg.m11264(adds.m2835()));
    }
}
