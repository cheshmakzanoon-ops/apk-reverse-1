package com.google.android.material.card2;

import android.animation.ObjectAnimator;
import android.app.Activity;
import android.widget.TextView;
import com.google.LoadX;
import com.google.android.C0009XX;
import java.util.HashMap;
import java.util.Timer;
import java.util.TimerTask;

class C0229hy extends TimerTask {

    final RunnableC0228hx f463ho;

    private final Activity f464hp;

    private final HashMap f465hq;

    private final TextView f466hr;

    private final ObjectAnimator f467hs;

    private final Timer f468ht;

    static {
        LoadX.abcDEFghiJKLmnoPQRstuVw(11, C0229hy.class);
        C0009XX.special_clinit_11_00(C0229hy.class);
    }

    C0229hy(RunnableC0228hx runnableC0228hx, Activity activity, HashMap map, TextView textView, ObjectAnimator objectAnimator, Timer timer) {
        this.f463ho = runnableC0228hx;
        this.f464hp = activity;
        this.f465hq = map;
        this.f466hr = textView;
        this.f467hs = objectAnimator;
        this.f468ht = timer;
    }

    public static native Activity m4767(Object obj);

    public static native ObjectAnimator m4768(Object obj);

    public static native HashMap m4769(Object obj);

    public static native Activity m4770(Object obj);

    public static native Timer m4771(Object obj);

    public static native TextView m4772(Object obj);

    public static native HashMap m4773(Object obj);

    public static native TextView m4774(Object obj);

    public static native ObjectAnimator m4775(Object obj);

    public static native int m4776();

    public static native Timer m4777(Object obj);

    public static native Timer m4778(Object obj);

    public static native ObjectAnimator m4779(Object obj);

    public static native Activity m4780(Object obj);

    public static native HashMap m4781(Object obj);

    public static native TextView m4782(Object obj);

    @Override
    public native void run();
}
