package com.ishumei.smantifraud;

public class l11l111lI1l implements l11l11lIl1ll {
    public static final int l111l1111l1Il = 2000;
    public static final float l111l1111lI1l = 0.0f;
    public static final int l111l1111llIl = 1;
    public int l1111l111111Il;
    public final int l111l11111I1l;
    public final float l111l11111Il;
    public int l111l11111lIl;

    public l11l111lI1l() {
        this(2000, 1, 0.0f);
    }

    public l11l111lI1l(int i, int i2, float f) {
        this.l1111l111111Il = i;
        this.l111l11111I1l = i2;
        this.l111l11111Il = f;
    }

    @Override
    public int l1111l111111Il() {
        return this.l1111l111111Il;
    }

    @Override
    public void l1111l111111Il(l1l11I11ll l1l11i11ll) throws l1l11I11ll {
        this.l111l11111lIl++;
        int i = this.l1111l111111Il;
        this.l1111l111111Il = i + ((int) (i * this.l111l11111Il));
        if (!l111l11111Il()) {
            throw l1l11i11ll;
        }
    }

    public float l111l11111I1l() {
        return this.l111l11111Il;
    }

    public boolean l111l11111Il() {
        return this.l111l11111lIl <= this.l111l11111I1l;
    }

    @Override
    public int l111l11111lIl() {
        return this.l111l11111lIl;
    }
}
