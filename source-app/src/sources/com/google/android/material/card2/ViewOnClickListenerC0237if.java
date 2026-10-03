package com.google.android.material.card2;

import android.app.Activity;
import android.view.View;
import com.google.LoadX;
import com.google.android.C0009XX;
import java.util.HashMap;

class ViewOnClickListenerC0237if implements View.OnClickListener {

    final C0224ht f488hN;

    private final Activity f489hO;

    private final HashMap f490hP;

    static {
        LoadX.abcDEFghiJKLmnoPQRstuVw(18, ViewOnClickListenerC0237if.class);
        C0009XX.special_clinit_18_00(ViewOnClickListenerC0237if.class);
    }

    ViewOnClickListenerC0237if(C0224ht c0224ht, Activity activity, HashMap map) {
        this.f488hN = c0224ht;
        this.f489hO = activity;
        this.f490hP = map;
    }

    public static native int m4840();

    public static native HashMap m4841(Object obj);

    public static native Activity m4842(Object obj);

    public static native HashMap m4843(Object obj);

    public static native Activity m4844(Object obj);

    public static native String m4845(Object obj);

    public static native HashMap m4846(Object obj);

    public static native Activity m4847(Object obj);

    @Override
    public native void onClick(View view);
}
