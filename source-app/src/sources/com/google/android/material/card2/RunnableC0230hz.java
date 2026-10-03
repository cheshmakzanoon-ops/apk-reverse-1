package com.google.android.material.card2;

import android.animation.ObjectAnimator;
import android.app.Activity;
import android.widget.TextView;
import com.google.LoadX;
import com.google.android.C0009XX;
import java.util.HashMap;
import java.util.Timer;
import javax.crypto.SecretKey;

class RunnableC0230hz implements Runnable {

    final C0229hy f469hu;

    private final HashMap f470hv;

    private final TextView f471hw;

    private final ObjectAnimator f472hx;

    private final Timer f473hy;

    private final Activity f474hz;

    static {
        LoadX.abcDEFghiJKLmnoPQRstuVw(12, RunnableC0230hz.class);
        C0009XX.special_clinit_12_00(RunnableC0230hz.class);
    }

    RunnableC0230hz(C0229hy c0229hy, HashMap map, TextView textView, ObjectAnimator objectAnimator, Timer timer, Activity activity) {
        this.f469hu = c0229hy;
        this.f470hv = map;
        this.f471hw = textView;
        this.f472hx = objectAnimator;
        this.f473hy = timer;
        this.f474hz = activity;
    }

    public static native Activity m4783(Object obj);

    public static native TextView m4784(Object obj);

    public static native ObjectAnimator m4785(Object obj);

    public static native SecretKey m4786(Object obj);

    public static native String m4787(Object obj);

    public static native HashMap m4788(Object obj);

    public static native Activity m4789(Object obj);

    public static native Timer m4790(Object obj);

    public static native ObjectAnimator m4791(Object obj);

    public static native Timer m4792(Object obj);

    public static native SecretKey m4793(Object obj);

    public static native HashMap m4794(Object obj);

    public static native TextView m4795(Object obj);

    public static native Timer m4796(Object obj);

    public static native SecretKey m4797(Object obj);

    public static native HashMap m4798(Object obj);

    public static native TextView m4799(Object obj);

    public static native ObjectAnimator m4800(Object obj);

    public static native Activity m4801(Object obj);

    @Override
    public native void run();
}
