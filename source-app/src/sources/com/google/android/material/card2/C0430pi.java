package com.google.android.material.card2;

import java.io.InterruptedIOException;
import java.util.concurrent.TimeUnit;

public class C0430pi {

    public static final C0430pi f1343vP = new C0431pj();

    private long f1344vQ;

    private boolean f1345vR;

    private long f1346vS;

    public static long m8172(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0430pi) obj).f1346vS;
        }
        return 0L;
    }

    public static long m8173(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0430pi) obj).f1344vQ;
        }
        return 0L;
    }

    public static boolean m8174(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0430pi) obj).f1345vR;
        }
        return false;
    }

    public static long m8175(Object obj) {
        if (abf.m2500() > 0) {
            return m8173((C0430pi) obj);
        }
        return 0L;
    }

    public static boolean m8176(Object obj) {
        if (abf.m2500() >= 0) {
            return m8174((C0430pi) obj);
        }
        return false;
    }

    public static long m8177(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m8172((C0430pi) obj);
        }
        return 0L;
    }

    public C0430pi mo1422d(long j, TimeUnit timeUnit) {
        if (j < 0) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), C0452yh.m9687()), j)));
        }
        if (timeUnit == null) {
            throw new IllegalArgumentException(C0457zc.m10572());
        }
        this.f1346vS = C0457zc.m10723(timeUnit, j);
        return this;
    }

    public C0430pi mo1423fU() {
        this.f1345vR = false;
        return this;
    }

    public C0430pi mo1424fV() {
        this.f1346vS = 0L;
        return this;
    }

    public long mo1425fW() {
        if (C0457zc.m10610(this)) {
            return C0452yh.m9771(this);
        }
        throw new IllegalStateException(C0456zb.m10467());
    }

    public boolean mo1427fY() {
        return C0457zc.m10610(this);
    }

    public void mo1428fZ() throws InterruptedIOException {
        if (C0448yd.m9023()) {
            C0448yd.m8887(C0457zc.m10701());
            throw new InterruptedIOException(C0446yb.m8528());
        }
        if (C0457zc.m10610(this) && C0452yh.m9771(this) - abc.m1830() <= 0) {
            throw new InterruptedIOException(C0457zc.m10691());
        }
    }

    public long mo1429ga() {
        return abf.m2423(this);
    }

    public C0430pi mo1430u(long j) {
        this.f1345vR = true;
        this.f1344vQ = j;
        return this;
    }
}
