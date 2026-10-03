package com.ishumei.smantifraud;

import android.content.Context;
import com.ishumei.smantifraud.dfp.SMSDK;

public class l11l11Il extends l11l1111I1l {
    public String l111l11111lIl;

    public l11l11Il(String str) {
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null) {
            return;
        }
        try {
            this.l111l11111lIl = l1l1l11Ill.l11l1111lIIl(str + "_" + context.getPackageName());
        } catch (Throwable unused) {
        }
    }

    @Override
    public void l1111l111111Il(String str) {
        super.l1111l111111Il(str);
    }

    @Override
    public String l111l11111I1l() {
        return this.l111l11111lIl;
    }

    @Override
    public String l111l11111Il() {
        return this.l111l11111lIl;
    }

    @Override
    public String l111l11111lIl() {
        return super.l111l11111lIl();
    }

    @Override
    public void l111l11111lIl(String str) {
        super.l111l11111lIl(str);
        l1l11I11l.l111l11111Il().l1111l111111Il(l11l11l111Il.l1111l111111Il, l1l11I11l.l111l11111Il().l1111l111111Il(l111l1111l1Il()));
    }

    public long l111l1111l1Il() {
        return SMSDK.m372u2(l11l11l111Il.l1111l111111Il.getFilesDir().getParent() + "/shared_prefs/" + l111l11111I1l() + ".xml");
    }
}
