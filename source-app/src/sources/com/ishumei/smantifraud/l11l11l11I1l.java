package com.ishumei.smantifraud;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

public final class l11l11l11I1l {
    public final int l1111l111111Il;
    public final InputStream l111l11111I1l = null;
    public final byte[] l111l11111Il;
    public final int l111l11111lIl;

    public l11l11l11I1l(int i, byte[] bArr) {
        this.l1111l111111Il = i;
        this.l111l11111lIl = bArr.length;
        this.l111l11111Il = bArr;
    }

    public final InputStream l1111l111111Il() {
        InputStream inputStream = this.l111l11111I1l;
        if (inputStream != null) {
            return inputStream;
        }
        if (this.l111l11111Il != null) {
            return new ByteArrayInputStream(this.l111l11111Il);
        }
        return null;
    }

    public final int l111l11111I1l() {
        return this.l111l11111lIl;
    }

    public final int l111l11111Il() {
        return this.l1111l111111Il;
    }

    public final byte[] l111l11111lIl() {
        return this.l111l11111Il;
    }
}
