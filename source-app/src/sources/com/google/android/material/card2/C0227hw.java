package com.google.android.material.card2;

import android.animation.ObjectAnimator;
import android.app.Activity;
import android.widget.TextView;
import com.google.LoadX;
import com.google.android.C0009XX;
import java.util.HashMap;
import java.util.Timer;
import java.util.TimerTask;

class C0227hw extends TimerTask {

    final C0224ht f451hc;

    private final Activity f452hd;

    private final Timer f453he;

    private final HashMap f454hf;

    private final TextView f455hg;

    private final ObjectAnimator f456hh;

    static {
        LoadX.abcDEFghiJKLmnoPQRstuVw(9, C0227hw.class);
        C0009XX.special_clinit_9_00(C0227hw.class);
    }

    C0227hw(C0224ht c0224ht, Activity activity, Timer timer, HashMap map, TextView textView, ObjectAnimator objectAnimator) {
        this.f451hc = c0224ht;
        this.f452hd = activity;
        this.f453he = timer;
        this.f454hf = map;
        this.f455hg = textView;
        this.f456hh = objectAnimator;
    }

    public static native TextView m4735(Object obj);

    public static native int m4736();

    public static native TextView m4737(Object obj);

    public static native HashMap m4738(Object obj);

    public static native Timer m4739(Object obj);

    public static native ObjectAnimator m4740(Object obj);

    public static native HashMap m4741(Object obj);

    public static native Timer m4742(Object obj);

    public static native Activity m4743(Object obj);

    public static native ObjectAnimator m4744(Object obj);

    public static native Activity m4745(Object obj);

    public static native HashMap m4746(Object obj);

    public static native TextView m4747(Object obj);

    public static native Timer m4748(Object obj);

    public static native Activity m4749(Object obj);

    public static native ObjectAnimator m4750(Object obj);

    @Override
    public native void run();
}
