package com.ishumei.smantifraud;

import android.text.TextUtils;

public final class l11l11l11lIl {
    public final String l1111l111111Il;
    public final String l111l11111lIl;

    public l11l11l11lIl(String str, String str2) {
        this.l1111l111111Il = str;
        this.l111l11111lIl = str2;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || l11l11l11lIl.class != obj.getClass()) {
            return false;
        }
        l11l11l11lIl l11l11l11lil = (l11l11l11lIl) obj;
        return TextUtils.equals(this.l1111l111111Il, l11l11l11lil.l1111l111111Il) && TextUtils.equals(this.l111l11111lIl, l11l11l11lil.l111l11111lIl);
    }

    public int hashCode() {
        return this.l111l11111lIl.hashCode() + (this.l1111l111111Il.hashCode() * 31);
    }

    public final String l1111l111111Il() {
        return this.l1111l111111Il;
    }

    public final String l111l11111lIl() {
        return this.l111l11111lIl;
    }

    public String toString() {
        return "Header[name=" + this.l1111l111111Il + ",value=" + this.l111l11111lIl + "]";
    }
}
