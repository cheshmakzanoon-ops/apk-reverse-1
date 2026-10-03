package com.gme.liteav.sdkcommon;

import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

final class ViewOnClickListenerC1071j implements View.OnClickListener {

    private final C1068g f821a;

    private final Button f822b;

    private ViewOnClickListenerC1071j(C1068g c1068g, Button button) {
        this.f821a = c1068g;
        this.f822b = button;
    }

    public static View.OnClickListener m1057a(C1068g c1068g, Button button) {
        return new ViewOnClickListenerC1071j(c1068g, button);
    }

    @Override
    public final void onClick(View view) {
        C1068g c1068g = this.f821a;
        if (c1068g.f810m) {
            c1068g.f799b.height = c1068g.f811n;
            if (c1068g.f799b.y + c1068g.f799b.height > c1068g.f798a.heightPixels) {
                c1068g.f799b.height = c1068g.f798a.heightPixels - c1068g.f799b.y;
            }
        } else {
            c1068g.f799b.height = c1068g.f811n / 2;
        }
        c1068g.f810m = !c1068g.f810m;
        c1068g.f803f.updateViewLayout(c1068g.f804g, c1068g.f799b);
        ViewGroup.LayoutParams layoutParams = c1068g.f808k.getLayoutParams();
        layoutParams.height = c1068g.m1053b();
        c1068g.f808k.setLayoutParams(layoutParams);
        c1068g.f801d.post(RunnableC1073l.m1059a(c1068g));
    }
}
