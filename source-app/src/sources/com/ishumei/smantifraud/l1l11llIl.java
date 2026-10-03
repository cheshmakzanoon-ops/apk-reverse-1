package com.ishumei.smantifraud;

import android.content.Context;
import android.os.Build;
import java.util.ArrayList;
import java.util.List;

public class l1l11llIl {
    public static final long l111l11111I1l = 2000;
    public final Context l1111l111111Il;
    public final l1l11lI11l l111l11111lIl = l111l11111lIl();

    public l1l11llIl(Context context) {
        this.l1111l111111Il = context;
    }

    public static List<String> l1111l111111Il(Context context) {
        ArrayList arrayList = new ArrayList();
        if (l111l11111Il.l1111l111111Il(context)) {
            arrayList.add("as");
        }
        if (l11l11l11Il.l1111l111111Il(context)) {
            arrayList.add("hu");
        }
        if (l11l11l1I11l.l1111l111111Il(context)) {
            arrayList.add("le");
        }
        if (l1l11l1Il.l1111l111111Il(context)) {
            arrayList.add("me");
        }
        if (l1l11llI1l.l1111l111111Il(context)) {
            arrayList.add("nu");
        }
        if (l1l11lI11Il.l1111l111111Il(context)) {
            arrayList.add("op");
        }
        if (l11l11lII1l.l1111l111111Il(context)) {
            arrayList.add("sa");
        }
        if (l1l1l1ll.l1111l111111Il(context)) {
            arrayList.add("vi");
        }
        if (l1l1l1I11l.l1111l111111Il(context)) {
            arrayList.add("xi");
        }
        if (l1l1l1I1ll.l1111l111111Il(context)) {
            arrayList.add("zt");
        }
        return arrayList;
    }

    public String l1111l111111Il() {
        l1l11lI11l l1l11li11l = this.l111l11111lIl;
        return l1l11li11l == null ? "" : l1l11li11l.l1111l111111Il(l111l11111I1l);
    }

    public final l1l11lI11l l111l11111lIl() {
        if (this.l1111l111111Il == null) {
            return null;
        }
        String lowerCase = Build.MANUFACTURER.toLowerCase();
        if (lowerCase.contains("asus")) {
            return new l111l11111Il(this.l1111l111111Il);
        }
        if (lowerCase.contains("huawei") || lowerCase.contains("honor")) {
            return new l11l11l11Il(this.l1111l111111Il);
        }
        if (lowerCase.contains("lenovo")) {
            return new l11l11l1I11l(this.l1111l111111Il);
        }
        if (lowerCase.contains("meizu")) {
            return new l1l11l1Il(this.l1111l111111Il);
        }
        if (lowerCase.contains("nubia")) {
            return new l1l11llI1l(this.l1111l111111Il);
        }
        if (lowerCase.contains("oppo") || lowerCase.contains("realme") || lowerCase.contains("oneplus")) {
            return new l1l11lI11Il(this.l1111l111111Il);
        }
        if (lowerCase.contains("samsung")) {
            return new l11l11lII1l(this.l1111l111111Il);
        }
        if (lowerCase.contains("vivo")) {
            return new l1l1l1ll(this.l1111l111111Il);
        }
        if (lowerCase.contains("xiaomi")) {
            return new l1l1l1I11l(this.l1111l111111Il);
        }
        if (lowerCase.contains("zte")) {
            return new l1l1l1I1ll(this.l1111l111111Il);
        }
        return null;
    }
}
