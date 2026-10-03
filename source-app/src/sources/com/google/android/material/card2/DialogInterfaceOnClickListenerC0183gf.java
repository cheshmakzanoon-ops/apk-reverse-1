package com.google.android.material.card2;

import android.content.DialogInterface;
import normal.updatev2.DebugActivity;

public class DialogInterfaceOnClickListenerC0183gf implements DialogInterface.OnClickListener {

    final DebugActivity f369fU;

    public DialogInterfaceOnClickListenerC0183gf(DebugActivity debugActivity) {
        this.f369fU = debugActivity;
    }

    public static void m4259(Object obj) {
        if (abe.m2308() < 0) {
            ((DebugActivity) obj).finish();
        }
    }

    public static DebugActivity m4260(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((DialogInterfaceOnClickListenerC0183gf) obj).f369fU;
        }
        return null;
    }

    public static DebugActivity m4261(Object obj) {
        if (C0458ze.m10932() > 0) {
            return m4262(obj);
        }
        return null;
    }

    public static DebugActivity m4262(Object obj) {
        if (abd.m2166() < 0) {
            return m4260((DialogInterfaceOnClickListenerC0183gf) obj);
        }
        return null;
    }

    public static void m4263(Object obj) {
        if (abe.m2321() <= 0) {
            m4259((DebugActivity) obj);
        }
    }

    @Override
    public void onClick(DialogInterface dialogInterface, int i) {
        abc.m1935(m4261(this));
    }
}
