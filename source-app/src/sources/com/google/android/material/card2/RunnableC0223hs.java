package com.google.android.material.card2;

import android.app.Activity;
import android.content.SharedPreferences;
import com.google.LoadX;
import com.google.android.C0009XX;
import javax.crypto.SecretKey;

class RunnableC0223hs implements Runnable {

    final C0222hr f442gU;

    private final Activity f443gV;

    private final SharedPreferences f444gW;

    static {
        LoadX.abcDEFghiJKLmnoPQRstuVw(5, RunnableC0223hs.class);
        C0009XX.special_clinit_5_00(RunnableC0223hs.class);
    }

    RunnableC0223hs(C0222hr c0222hr, Activity activity, SharedPreferences sharedPreferences) {
        this.f442gU = c0222hr;
        this.f443gV = activity;
        this.f444gW = sharedPreferences;
    }

    static native C0222hr m599a(RunnableC0223hs runnableC0223hs);

    public static native SharedPreferences m4689(Object obj);

    public static native String m4690();

    public static native Activity m4691(Object obj);

    public static native SecretKey m4692(Object obj);

    public static native SecretKey m4693(Object obj);

    public static native C0222hr m4694(Object obj);

    public static native SharedPreferences m4695(Object obj);

    public static native String m4696();

    public static native Activity m4697(Object obj);

    public static native C0222hr m4698(Object obj);

    public static native SharedPreferences m4699(Object obj);

    public static native SecretKey m4700(Object obj);

    public static native C0222hr m4701(Object obj);

    public static native Activity m4702(Object obj);

    @Override
    public native void run();
}
