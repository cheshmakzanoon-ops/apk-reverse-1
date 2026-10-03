package com.gme.liteav.sdkcommon;

import android.view.View;

final class ViewOnClickListenerC1072k implements View.OnClickListener {

    private final C1068g f823a;

    private ViewOnClickListenerC1072k(C1068g c1068g) {
        this.f823a = c1068g;
    }

    public static View.OnClickListener m1058a(C1068g c1068g) {
        return new ViewOnClickListenerC1072k(c1068g);
    }

    @Override
    public final void onClick(View view) {
        this.f823a.m1052a(false);
    }
}
