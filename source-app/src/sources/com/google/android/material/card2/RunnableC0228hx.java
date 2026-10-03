package com.google.android.material.card2;

import android.animation.ObjectAnimator;
import android.app.Activity;
import android.widget.TextView;
import com.google.LoadX;
import com.google.android.C0009XX;
import java.util.HashMap;
import java.util.Timer;

class RunnableC0228hx implements Runnable {

    final C0227hw f457hi;

    private final Timer f458hj;

    private final Activity f459hk;

    private final HashMap f460hl;

    private final TextView f461hm;

    private final ObjectAnimator f462hn;

    static {
        LoadX.abcDEFghiJKLmnoPQRstuVw(10, RunnableC0228hx.class);
        C0009XX.special_clinit_10_00(RunnableC0228hx.class);
    }

    RunnableC0228hx(C0227hw c0227hw, Timer timer, Activity activity, HashMap map, TextView textView, ObjectAnimator objectAnimator) {
        this.f457hi = c0227hw;
        this.f458hj = timer;
        this.f459hk = activity;
        this.f460hl = map;
        this.f461hm = textView;
        this.f462hn = objectAnimator;
    }

    public static native HashMap m4751(Object obj);

    public static native Timer m4752(Object obj);

    public static native TextView m4753(Object obj);

    public static native TextView m4754(Object obj);

    public static native ObjectAnimator m4755(Object obj);

    public static native ObjectAnimator m4756(Object obj);

    public static native Activity m4757(Object obj);

    public static native Timer m4758(Object obj);

    public static native HashMap m4759(Object obj);

    public static native Activity m4760(Object obj);

    public static native int m4761();

    public static native Timer m4762(Object obj);

    public static native HashMap m4763(Object obj);

    public static native TextView m4764(Object obj);

    public static native ObjectAnimator m4765(Object obj);

    public static native Activity m4766(Object obj);

    @Override
    public native void run();
}
