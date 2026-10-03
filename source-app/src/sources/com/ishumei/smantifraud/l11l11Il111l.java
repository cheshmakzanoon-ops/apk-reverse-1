package com.ishumei.smantifraud;

import android.content.Context;
import com.ishumei.smantifraud.dfp.SMSDK;

public class l11l11Il111l extends l11l1111I1l {
    public static final String l111l11111I1l = "_android";
    public static final String l111l11111lIl = "_shumei";

    @Override
    public void l1111l111111Il(String str) {
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null) {
            return;
        }
        try {
            super.l1111l111111Il(SMSDK.m378x3(context.getPackageName() + l111l11111I1l, str));
        } catch (Throwable unused) {
        }
    }

    @Override
    public String l111l11111I1l() {
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null) {
            return null;
        }
        return l1l1l11Ill.l11l1111lIIl(context.getPackageName() + l111l11111lIl);
    }

    @Override
    public String l111l11111Il() {
        return l111l11111I1l();
    }

    @Override
    public String l111l11111lIl() {
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null) {
            return null;
        }
        try {
            return SMSDK.m380x5(context.getPackageName() + l111l11111I1l, super.l111l11111lIl());
        } catch (Throwable unused) {
            return "";
        }
    }

    @Override
    public void l111l11111lIl(String str) {
        super.l111l11111lIl(str);
    }
}
