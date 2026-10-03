package com.google.android.material.card2;

import android.animation.ObjectAnimator;
import android.widget.TextView;
import com.google.LoadX;
import com.google.android.C0009XX;
import java.util.HashMap;

class RunnableC0233ib implements Runnable {

    final C0232ia f480hF;

    private final TextView f481hG;

    private final HashMap f482hH;

    private final ObjectAnimator f483hI;

    static {
        LoadX.abcDEFghiJKLmnoPQRstuVw(14, RunnableC0233ib.class);
        C0009XX.special_clinit_14_00(RunnableC0233ib.class);
    }

    RunnableC0233ib(C0232ia c0232ia, TextView textView, HashMap map, ObjectAnimator objectAnimator) {
        this.f480hF = c0232ia;
        this.f481hG = textView;
        this.f482hH = map;
        this.f483hI = objectAnimator;
    }

    public static native ObjectAnimator m4815(Object obj);

    public static native String m4816(Object obj);

    public static native HashMap m4817(Object obj);

    public static native TextView m4818(Object obj);

    public static native TextView m4819(Object obj);

    public static native HashMap m4820(Object obj);

    public static native ObjectAnimator m4821(Object obj);

    public static native TextView m4822(Object obj);

    public static native HashMap m4823(Object obj);

    public static native ObjectAnimator m4824(Object obj);

    @Override
    public native void run();
}
