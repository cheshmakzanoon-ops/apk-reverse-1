package com.google.android.material.card2;

import android.content.Context;
import android.os.AsyncTask;

public class C0166fp implements InterfaceC0171fu {

    private InterfaceC0180gc f318eU;

    public static void m4000(Object obj) {
        if (C0453yj.m10013() >= 0) {
            C0174fx.m503a((AsyncTask<Void, Void, Void>) obj);
        }
    }

    public static InterfaceC0180gc m4001(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0166fp) obj).f318eU;
        }
        return null;
    }

    public static InterfaceC0180gc m4002(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m4001((C0166fp) obj);
        }
        return null;
    }

    public static void m4003(Object obj) {
        if (C0458ze.m10926() < 0) {
            m4000((AsyncTask) obj);
        }
    }

    @Override
    public void mo474a(Context context, String str, String str2, InterfaceC0172fv interfaceC0172fv, Runnable runnable) {
        gggy.m4391(new AsyncTaskC0167fq(this, str, context, interfaceC0172fv, runnable));
    }

    @Override
    public boolean mo475aE() {
        return true;
    }

    @Override
    public boolean mo476l(String str) {
        return C0458ze.m10811(str, abd.m2063());
    }
}
