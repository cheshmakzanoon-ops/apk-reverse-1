package com.ishumei.smantifraud;

import android.os.SystemClock;
import android.text.TextUtils;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

public class l11l1111I1ll implements l1l11l1Il1l {
    public final l111l1111lIl l1111l111111Il;

    public l11l1111I1ll(l111l1111lIl l111l1111lil) {
        this.l1111l111111Il = l111l1111lil;
    }

    @Override
    public l1l11lIl<?> l1111l111111Il(l1l11lI1I1l<?> l1l11li1i1l) throws l1l11I11ll {
        Exception exc;
        l11l11l11I1l l11l11l11i1lL1111l111111Il;
        byte[] bArr;
        long jElapsedRealtime = SystemClock.elapsedRealtime();
        l1l11li1i1l.l1111l111111Il(false);
        while (true) {
            try {
                l11l11l11i1lL1111l111111Il = this.l1111l111111Il.l1111l111111Il(l1l11li1i1l, Collections.emptyMap());
                try {
                    byte[] bArr2 = l11l11l11i1lL1111l111111Il.l111l11111Il;
                    try {
                        int i = l11l11l11i1lL1111l111111Il.l1111l111111Il;
                        if (bArr2 == null) {
                            bArr2 = new byte[0];
                        }
                        if (i < 200 || i > 299) {
                            throw new IOException();
                        }
                        l1l11lIl<?> l1l11lilL1111l111111Il = l1l11li1i1l.l1111l111111Il(new l1l11ll1Il(i, bArr2, l1l11ll1Il.l1111l111111Il((List<l11l11l11lIl>) null), null, false, SystemClock.elapsedRealtime() - jElapsedRealtime));
                        l1l11li1i1l.l1111l111111Il("network-parse-complete");
                        if (l1l11lilL1111l111111Il.l1111l111111Il()) {
                            return l1l11lilL1111l111111Il;
                        }
                        l1l11I11ll l1l11i11ll = l1l11lilL1111l111111Il.l111l11111lIl;
                        if (l1l11i11ll != null) {
                            throw l1l11i11ll;
                        }
                        throw new Exception("");
                    } catch (Exception e) {
                        e = e;
                        bArr = bArr2;
                        exc = e;
                        l1l11li1i1l.l1111l111111Il(true);
                        if ((exc instanceof IllegalArgumentException) && TextUtils.equals(exc.getMessage(), l1l11I11ll.l111l1111lI1l)) {
                            throw ((IllegalArgumentException) exc);
                        }
                        l1l11lllIl.l1111l111111Il(l1l11li1i1l, l1l11lllIl.l1111l111111Il(l1l11li1i1l, exc, jElapsedRealtime, l11l11l11i1lL1111l111111Il, bArr));
                    }
                } catch (Exception e2) {
                    e = e2;
                    bArr = null;
                }
            } catch (Exception e3) {
                exc = e3;
                l11l11l11i1lL1111l111111Il = null;
                bArr = null;
            }
            l1l11lllIl.l1111l111111Il(l1l11li1i1l, l1l11lllIl.l1111l111111Il(l1l11li1i1l, exc, jElapsedRealtime, l11l11l11i1lL1111l111111Il, bArr));
        }
    }
}
