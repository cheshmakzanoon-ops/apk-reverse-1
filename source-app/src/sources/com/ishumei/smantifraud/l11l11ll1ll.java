package com.ishumei.smantifraud;

public class l11l11ll1ll {
    public static l11l11ll1ll l111l11111I1l;
    public l1l11lIIlll l1111l111111Il;
    public boolean l111l11111lIl = true;

    public static synchronized l11l11ll1ll l1111l111111Il() {
        if (l111l11111I1l == null) {
            l111l11111I1l = new l11l11ll1ll();
        }
        return l111l11111I1l;
    }

    public synchronized void l1111l111111Il(l1l11lI1I1l<?> l1l11li1i1l) {
        if (this.l111l11111lIl) {
            l1l11lIIlll l1l11liilllL1111l111111Il = l1l1l1ll1l.l1111l111111Il();
            this.l1111l111111Il = l1l11liilllL1111l111111Il;
            l1l11liilllL1111l111111Il.l111l11111Il();
            this.l111l11111lIl = false;
        }
        this.l1111l111111Il.l1111l111111Il((l1l11lI1I1l) l1l11li1i1l);
    }

    public synchronized void l111l11111lIl() {
        this.l1111l111111Il.l111l1111l1Il();
        this.l111l11111lIl = true;
    }
}
