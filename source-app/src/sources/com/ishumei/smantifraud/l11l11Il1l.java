package com.ishumei.smantifraud;

import android.content.Context;
import java.lang.reflect.Method;

public class l11l11Il1l {
    public Object l1111l111111Il;
    public Context l111l11111lIl;

    public l11l11Il1l() {
        this.l1111l111111Il = null;
        this.l111l11111lIl = null;
        try {
            Context context = l11l11l111Il.l1111l111111Il;
            if (context != null) {
                this.l111l11111lIl = context;
                this.l1111l111111Il = l1l11lI1lIl.l1111l111111Il(context, "getSystemService", new Class[]{String.class}, new Object[]{"phone"});
            }
        } catch (Exception unused) {
        }
    }

    public final Object l1111l111111Il(String str) {
        try {
            Context context = this.l111l11111lIl;
            if (context != null) {
                return l1l11lI1lIl.l1111l111111Il(context.getApplicationContext(), "getSystemService", new Class[]{String.class}, new Object[]{str});
            }
        } catch (Exception unused) {
        }
        return null;
    }

    public String l1111l111111Il() {
        try {
            Object objL1111l111111Il = l1111l111111Il("phone");
            Method declaredMethod = objL1111l111111Il.getClass().getDeclaredMethod("getNetworkCountryIso", null);
            declaredMethod.setAccessible(true);
            return (String) declaredMethod.invoke(objL1111l111111Il, null);
        } catch (Exception unused) {
            return "";
        }
    }

    public String l111l11111I1l() {
        try {
            Object objL1111l111111Il = l1111l111111Il("phone");
            Method declaredMethod = objL1111l111111Il.getClass().getDeclaredMethod("getSimCountryIso", null);
            declaredMethod.setAccessible(true);
            return (String) declaredMethod.invoke(objL1111l111111Il, null);
        } catch (Exception unused) {
            return "";
        }
    }

    public String l111l11111lIl() {
        try {
            Object obj = this.l1111l111111Il;
            if (obj == null) {
                return "";
            }
            String str = (String) l1l11lI1lIl.l111l11111lIl(obj, "getSimOperator");
            if (str != null) {
                try {
                    if (str.isEmpty()) {
                    }
                } catch (Exception unused) {
                }
                return str;
            }
            String str2 = (String) l1l11lI1lIl.l111l11111lIl(this.l1111l111111Il, "getNetworkOperatorName");
            return str2 == null ? "" : str2;
        } catch (Exception unused2) {
            return "";
        }
    }
}
