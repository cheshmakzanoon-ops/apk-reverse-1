package com.ishumei.smantifraud;

public class l1l11I11ll extends Exception {
    public static final int l111l11111I1l = -1;
    public static final int l111l11111Il = -2;
    public static final int l111l1111l1Il = -3;
    public static final String l111l1111lI1l = "body is null";
    public static final int l111l1111llIl = -4;
    public final l1l11ll1Il l1111l111111Il;
    public final int l111l11111lIl;

    public l1l11I11ll(int i) {
        this.l111l11111lIl = i;
        this.l1111l111111Il = null;
    }

    public l1l11I11ll(l1l11ll1Il l1l11ll1il, int i) {
        this.l111l11111lIl = i;
        this.l1111l111111Il = l1l11ll1il;
    }

    public l1l11I11ll(String str, int i) {
        super(str);
        this.l111l11111lIl = i;
        this.l1111l111111Il = null;
    }

    public l1l11I11ll(String str, Throwable th, int i) {
        super(str, th);
        this.l111l11111lIl = i;
        this.l1111l111111Il = null;
    }

    public l1l11I11ll(Throwable th, int i) {
        super(th);
        this.l111l11111lIl = i;
        this.l1111l111111Il = null;
    }
}
