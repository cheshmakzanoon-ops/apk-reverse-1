package com.google.android.material.card2;

import java.io.IOException;

class C0303kr implements InterfaceC0429ph {

    boolean f907op;

    final C0302kq f908oq;

    final InterfaceC0410op f909or;

    final InterfaceC0304ks f910os;

    final InterfaceC0411oq f911ot;

    C0303kr(C0302kq c0302kq, InterfaceC0411oq interfaceC0411oq, InterfaceC0304ks interfaceC0304ks, InterfaceC0410op interfaceC0410op) {
        this.f908oq = c0302kq;
        this.f911ot = interfaceC0411oq;
        this.f910os = interfaceC0304ks;
        this.f909or = interfaceC0410op;
    }

    public static boolean m5809(Object obj) {
        if (C0448yd.m9079() < 0) {
            return m5827(obj);
        }
        return false;
    }

    public static InterfaceC0410op m5810(Object obj) {
        if (C0460zg.m11287() > 0) {
            return m5826(obj);
        }
        return null;
    }

    public static C0430pi m5811(Object obj) {
        if (adds.m2755() >= 0) {
            return m5831(obj);
        }
        return null;
    }

    public static void m5812(Object obj) {
        if (C0461zs.m11510() <= 0) {
            ((InterfaceC0411oq) obj).close();
        }
    }

    public static long m5813(Object obj, Object obj2, long j) {
        if (C0450yf.m9352() < 0) {
            return m5832(obj, obj2, j);
        }
        return 0L;
    }

    public static InterfaceC0411oq m5814(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return m5825(obj);
        }
        return null;
    }

    public static long m5815(Object obj, Object obj2, long j) {
        if (C0453yj.m10013() >= 0) {
            return ((InterfaceC0411oq) obj).mo966a((C0409oo) obj2, j);
        }
        return 0L;
    }

    public static void m5816(Object obj) {
        if (C0456zb.m10326() < 0) {
            m5830(obj);
        }
    }

    public static InterfaceC0304ks m5817(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0303kr) obj).f910os;
        }
        return null;
    }

    public static InterfaceC0411oq m5818(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0303kr) obj).f911ot;
        }
        return null;
    }

    public static void m5819(Object obj) {
        if (C0450yf.m9352() < 0) {
            m5829(obj);
        }
    }

    public static C0430pi m5820(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((InterfaceC0411oq) obj).mo967dz();
        }
        return null;
    }

    public static void m5821(Object obj) {
        if (C0451yg.m9580() > 0) {
            ((InterfaceC0410op) obj).close();
        }
    }

    public static InterfaceC0410op m5822(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0303kr) obj).f909or;
        }
        return null;
    }

    public static InterfaceC0304ks m5823(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m5828(obj);
        }
        return null;
    }

    public static boolean m5824(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0303kr) obj).f907op;
        }
        return false;
    }

    public static InterfaceC0411oq m5825(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m5818((C0303kr) obj);
        }
        return null;
    }

    public static InterfaceC0410op m5826(Object obj) {
        if (abf.m2500() > 0) {
            return m5822((C0303kr) obj);
        }
        return null;
    }

    public static boolean m5827(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m5824((C0303kr) obj);
        }
        return false;
    }

    public static InterfaceC0304ks m5828(Object obj) {
        if (abd.m2166() < 0) {
            return m5817((C0303kr) obj);
        }
        return null;
    }

    public static void m5829(Object obj) {
        if (C0460zg.m11293() > 0) {
            m5821((InterfaceC0410op) obj);
        }
    }

    public static void m5830(Object obj) {
        if (gggy.m4365() > 0) {
            m5812((InterfaceC0411oq) obj);
        }
    }

    public static C0430pi m5831(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m5820((InterfaceC0411oq) obj);
        }
        return null;
    }

    public static long m5832(Object obj, Object obj2, long j) {
        if (C0453yj.m10032() > 0) {
            return m5815((InterfaceC0411oq) obj, (C0409oo) obj2, j);
        }
        return 0L;
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) throws IOException {
        try {
            long jM5813 = m5813(m5814(this), c0409oo, j);
            if (jM5813 != -1) {
                C0445ya.m8253(c0409oo, C0461zs.m11595(m5810(this)), C0455za.m10042(c0409oo) - jM5813, jM5813);
                abc.m1901(m5810(this));
                return jM5813;
            }
            if (!m5809(this)) {
                this.f907op = true;
                m5819(m5810(this));
            }
            return -1L;
        } catch (IOException e) {
            if (!m5809(this)) {
                this.f907op = true;
                adds.m2685(m5823(this));
            }
            throw e;
        }
    }

    @Override
    public void close() {
        if (!m5809(this) && !C0448yd.m9024(this, 100, adds.m2789())) {
            this.f907op = true;
            adds.m2685(m5823(this));
        }
        m5816(m5814(this));
    }

    @Override
    public C0430pi mo967dz() {
        return m5811(m5814(this));
    }
}
