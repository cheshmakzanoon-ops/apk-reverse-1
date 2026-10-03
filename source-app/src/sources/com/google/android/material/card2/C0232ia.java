package com.google.android.material.card2;

import android.animation.ObjectAnimator;
import android.app.Activity;
import android.widget.TextView;
import com.google.LoadX;
import com.google.android.C0009XX;
import java.util.HashMap;
import java.util.TimerTask;

class C0232ia extends TimerTask {

    final RunnableC0230hz f475hA;

    private final Activity f476hB;

    private final TextView f477hC;

    private final HashMap f478hD;

    private final ObjectAnimator f479hE;

    static {
        LoadX.abcDEFghiJKLmnoPQRstuVw(13, C0232ia.class);
        C0009XX.special_clinit_13_00(C0232ia.class);
    }

    C0232ia(RunnableC0230hz runnableC0230hz, Activity activity, TextView textView, HashMap map, ObjectAnimator objectAnimator) {
        this.f475hA = runnableC0230hz;
        this.f476hB = activity;
        this.f477hC = textView;
        this.f478hD = map;
        this.f479hE = objectAnimator;
    }

    public static native TextView m4802(Object obj);

    public static native int m4803();

    public static native ObjectAnimator m4804(Object obj);

    public static native TextView m4805(Object obj);

    public static native ObjectAnimator m4806(Object obj);

    public static native HashMap m4807(Object obj);

    public static native Activity m4808(Object obj);

    public static native HashMap m4809(Object obj);

    public static native Activity m4810(Object obj);

    public static native HashMap m4811(Object obj);

    public static native Activity m4812(Object obj);

    public static native TextView m4813(Object obj);

    public static native ObjectAnimator m4814(Object obj);

    @Override
    public native void run();
}
