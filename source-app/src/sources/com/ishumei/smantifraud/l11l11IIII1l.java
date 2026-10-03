package com.ishumei.smantifraud;

import java.util.ArrayList;
import java.util.List;

public class l11l11IIII1l {
    public static final int l111l11111I1l = 60000;
    public static final int l111l11111Il = 20;
    public final List<l11l111ll11l> l1111l111111Il = new ArrayList();
    public long l111l11111lIl;

    public String l1111l111111Il() {
        StringBuilder sb = new StringBuilder();
        for (l11l111ll11l l11l111ll11lVar : this.l1111l111111Il) {
            long j = l11l111ll11lVar.l111l11111lIl;
            if (j < -1 || j > 60000) {
                j = 60000;
            }
            if (j >= 20) {
                sb.append(l11l111ll11lVar.l1111l111111Il);
                sb.append(":");
                sb.append(j);
                sb.append(";");
            }
        }
        return sb.toString();
    }

    public void l1111l111111Il(int i) {
        this.l1111l111111Il.add(new l11l111ll11l(i, System.currentTimeMillis() - this.l111l11111lIl));
    }

    public void l111l11111I1l() {
        this.l111l11111lIl = System.currentTimeMillis();
    }

    public void l111l11111lIl() {
        this.l1111l111111Il.clear();
    }
}
