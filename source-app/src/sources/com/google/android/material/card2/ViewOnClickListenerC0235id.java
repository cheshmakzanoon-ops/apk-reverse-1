package com.google.android.material.card2;

import android.app.AlertDialog;
import android.view.View;
import com.google.LoadX;
import com.google.android.C0009XX;

class ViewOnClickListenerC0235id implements View.OnClickListener {

    final C0224ht f485hK;

    private final AlertDialog f486hL;

    static {
        LoadX.abcDEFghiJKLmnoPQRstuVw(16, ViewOnClickListenerC0235id.class);
        C0009XX.special_clinit_16_00(ViewOnClickListenerC0235id.class);
    }

    ViewOnClickListenerC0235id(C0224ht c0224ht, AlertDialog alertDialog) {
        this.f485hK = c0224ht;
        this.f486hL = alertDialog;
    }

    public static native AlertDialog m4831(Object obj);

    public static native AlertDialog m4832(Object obj);

    public static native AlertDialog m4833(Object obj);

    @Override
    public native void onClick(View view);
}
