package com.ishumei.smantifraud;

public class l1l11lIl<T> {
    public final T l1111l111111Il;
    public boolean l111l11111I1l;
    public final l1l11I11ll l111l11111lIl;

    public interface l1111l111111Il {
        void l1111l111111Il(l1l11I11ll l1l11i11ll);
    }

    public interface l111l11111lIl<T> {
        void l1111l111111Il(T t);
    }

    public l1l11lIl(l1l11I11ll l1l11i11ll) {
        this.l111l11111I1l = false;
        this.l1111l111111Il = null;
        this.l111l11111lIl = l1l11i11ll;
    }

    public l1l11lIl(T t) {
        this.l111l11111I1l = false;
        this.l1111l111111Il = t;
        this.l111l11111lIl = null;
    }

    public static <T> l1l11lIl<T> l1111l111111Il(l1l11I11ll l1l11i11ll) {
        return new l1l11lIl<>(l1l11i11ll);
    }

    public static <T> l1l11lIl<T> l1111l111111Il(T t) {
        return new l1l11lIl<>(t);
    }

    public boolean l1111l111111Il() {
        return this.l111l11111lIl == null;
    }
}
