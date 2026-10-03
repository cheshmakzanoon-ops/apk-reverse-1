package com.google.android.material.card2;

import java.io.IOException;
import java.net.ProtocolException;

class C0341ma extends AbstractC0337ly {

    private long f1047qN;

    private boolean f1048qO;

    final C0335lw f1049qP;

    private final C0273jo f1050qQ;

    C0341ma(C0335lw c0335lw, C0273jo c0273jo) {
        super(c0335lw, null);
        this.f1049qP = c0335lw;
        this.f1047qN = -1L;
        this.f1048qO = true;
        this.f1050qQ = c0273jo;
    }

    private void m1112ep() throws ProtocolException {
        if (m6276(this) != -1) {
            C0460zg.m11224(m6278(m6284(this)));
        }
        try {
            this.f1047qN = C0452yh.m9772(m6278(m6284(this)));
            String strM9463 = C0450yf.m9463(C0460zg.m11224(m6278(m6284(this))));
            if (m6276(this) < 0 || !(C0460zg.m11421(strM9463) || C0458ze.m10811(strM9463, C0445ya.m8242()))) {
                throw new ProtocolException(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), C0449ye.m9301()), m6276(this)), strM9463), C0448yd.m8958())));
            }
            if (m6276(this) == 0) {
                this.f1048qO = false;
                C0450yf.m9332(C0460zg.m11336(m6269(m6284(this))), m6286(this), C0459zf.m11038(m6284(this)));
                m6281(this, true, null);
            }
        } catch (NumberFormatException e) {
            throw new ProtocolException(C0455za.m10074(e));
        }
    }

    public static boolean m6268(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return m6290(obj);
        }
        return false;
    }

    public static C0279ju m6269(Object obj) {
        if (C0453yj.m10013() > 0) {
            return m6291(obj);
        }
        return null;
    }

    public static long m6270(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0341ma) obj).f1047qN;
        }
        return 0L;
    }

    public static void m6271(Object obj, boolean z, Object obj2) {
        if (C0456zb.m10326() < 0) {
            ((C0341ma) obj).m1094a(z, (IOException) obj2);
        }
    }

    public static void m6272(Object obj) throws ProtocolException {
        if (C0452yh.m9798() > 0) {
            m6293(obj);
        }
    }

    public static C0273jo m6273(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0341ma) obj).f1050qQ;
        }
        return null;
    }

    public static boolean m6274(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0341ma) obj).f1048qO;
        }
        return false;
    }

    public static C0279ju m6275(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0335lw) obj).f1031qC;
        }
        return null;
    }

    public static long m6276(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return m6294(obj);
        }
        return 0L;
    }

    public static void m6277(Object obj) throws ProtocolException {
        if (gggy.m4269() < 0) {
            ((C0341ma) obj).m1112ep();
        }
    }

    public static InterfaceC0411oq m6278(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return m6289(obj);
        }
        return null;
    }

    public static C0335lw m6279(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0341ma) obj).f1049qP;
        }
        return null;
    }

    public static int m6280() {
        if (C0450yf.m9352() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static void m6281(Object obj, boolean z, Object obj2) {
        if (C0447yc.m8635() > 0) {
            m6287(obj, z, obj2);
        }
    }

    public static boolean m6282(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0341ma) obj).f1037oL;
        }
        return false;
    }

    public static InterfaceC0411oq m6283(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0335lw) obj).f1034qF;
        }
        return null;
    }

    public static C0335lw m6284(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m6295(obj);
        }
        return null;
    }

    public static boolean m6285(Object obj) {
        if (gggy.m4269() <= 0) {
            return m6288(obj);
        }
        return false;
    }

    public static C0273jo m6286(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return m6292(obj);
        }
        return null;
    }

    public static void m6287(Object obj, boolean z, Object obj2) {
        if (C0457zc.m10718() <= 0) {
            m6271((C0341ma) obj, z, (IOException) obj2);
        }
    }

    public static boolean m6288(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m6282((C0341ma) obj);
        }
        return false;
    }

    public static InterfaceC0411oq m6289(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m6283((C0335lw) obj);
        }
        return null;
    }

    public static boolean m6290(Object obj) {
        if (abd.m2166() <= 0) {
            return m6274((C0341ma) obj);
        }
        return false;
    }

    public static C0279ju m6291(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m6275((C0335lw) obj);
        }
        return null;
    }

    public static C0273jo m6292(Object obj) {
        if (m6280() > 0) {
            return m6273((C0341ma) obj);
        }
        return null;
    }

    public static void m6293(Object obj) throws ProtocolException {
        if (C0453yj.m9945() <= 0) {
            m6277((C0341ma) obj);
        }
    }

    public static long m6294(Object obj) {
        if (abe.m2321() <= 0) {
            return m6270((C0341ma) obj);
        }
        return 0L;
    }

    public static C0335lw m6295(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m6279((C0341ma) obj);
        }
        return null;
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) throws IOException {
        if (j < 0) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), adds.m2831()), j)));
        }
        if (m6285(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        if (!m6268(this)) {
            return -1L;
        }
        if (m6276(this) == 0 || m6276(this) == -1) {
            m6272(this);
            if (!m6268(this)) {
                return -1L;
            }
        }
        long jMo966a = super.mo966a(c0409oo, C0450yf.m9495(j, m6276(this)));
        if (jMo966a != -1) {
            this.f1047qN = m6276(this) - jMo966a;
            return jMo966a;
        }
        ProtocolException protocolException = new ProtocolException(C0445ya.m8367());
        m6281(this, false, protocolException);
        throw protocolException;
    }

    @Override
    public void close() {
        if (m6285(this)) {
            return;
        }
        if (m6268(this) && !C0448yd.m9024(this, 100, adds.m2789())) {
            m6281(this, false, null);
        }
        this.f1037oL = true;
    }
}
