package com.ishumei.smantifraud;

import android.content.Context;

public class l1l1l1I11l extends l1l11lI11l {
    public final Context l111l11111lIl;

    public l1l1l1I11l(Context context) {
        this.l111l11111lIl = context;
    }

    public static boolean l1111l111111Il(Context context) {
        try {
            Class.forName("com.android.id.impl.IdProviderImpl").getMethod("getOAID", Context.class);
            return true;
        } catch (Exception unused) {
            return false;
        }
    }

    @Override
    public String l1111l111111Il() {
        try {
            Class<?> cls = Class.forName("com.android.id.impl.IdProviderImpl");
            return (String) cls.getMethod("getOAID", Context.class).invoke(cls.newInstance(), this.l111l11111lIl);
        } catch (Exception unused) {
            return "";
        }
    }
}
