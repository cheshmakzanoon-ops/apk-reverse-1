package com.google.android.material.card2;

import android.content.Context;
import android.os.AsyncTask;

public class C0164fn implements InterfaceC0171fu {
    public static void m3980(Object obj) {
        if (C0457zc.m10735() < 0) {
            C0174fx.m503a((AsyncTask<Void, Void, Void>) obj);
        }
    }

    public static void m3981(Object obj) {
        if (abd.m2166() < 0) {
            m3980((AsyncTask) obj);
        }
    }

    @Override
    public void mo474a(Context context, String str, String str2, InterfaceC0172fv interfaceC0172fv, Runnable runnable) {
        C0458ze.m10875(new AsyncTaskC0165fo(this, interfaceC0172fv, str, runnable));
    }

    @Override
    public boolean mo475aE() {
        return false;
    }

    @Override
    public boolean mo476l(String str) {
        return C0458ze.m10811(str, C0455za.m10234());
    }
}
