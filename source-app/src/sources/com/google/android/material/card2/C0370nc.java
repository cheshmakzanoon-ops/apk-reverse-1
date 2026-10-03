package com.google.android.material.card2;

import java.io.Closeable;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

final class C0370nc implements Closeable {

    static final Logger f1181tb = C0460zg.m11225(C0456zb.m10455(C0351mk.class));

    private final boolean f1182tc;

    private final C0371nd f1183td = new C0371nd(m6985(this));

    final C0349mi f1184te = new C0349mi(4096, m7006(this));

    private final InterfaceC0411oq f1185tf;

    C0370nc(InterfaceC0411oq interfaceC0411oq, boolean z) {
        this.f1185tf = interfaceC0411oq;
        this.f1182tc = z;
    }

    static int m1187a(int i, byte b, short s) throws IOException {
        int i2 = i;
        if ((b & 8) != 0) {
            i2--;
        }
        if (s > i2) {
            throw m7016(C0450yf.m9367(), new Object[]{C0457zc.m10556(s), abd.m2028(i2)});
        }
        return (short) (i2 - s);
    }

    static int m1188a(InterfaceC0411oq interfaceC0411oq) {
        return ((C0446yb.m8575(interfaceC0411oq) & 255) << 16) | ((C0446yb.m8575(interfaceC0411oq) & 255) << 8) | (C0446yb.m8575(interfaceC0411oq) & 255);
    }

    private List<C0347mg> m1189a(int i, short s, byte b, int i2) {
        C0371nd c0371ndM7006 = m7006(this);
        m7006(this).f1187th = i;
        c0371ndM7006.f1188ti = i;
        m7006(this).f1189tj = s;
        m7006(this).f1186tg = b;
        m7006(this).f1191tl = i2;
        m6952(m7004(this));
        return m6989(m7004(this));
    }

    private void m1190a(InterfaceC0372ne interfaceC0372ne, int i) {
        int iM10834 = C0458ze.m10834(m6985(this));
        m6981(interfaceC0372ne, i, iM10834 & Integer.MAX_VALUE, (C0446yb.m8575(m6985(this)) & 255) + 1, (Integer.MIN_VALUE & iM10834) != 0);
    }

    private void m1191a(InterfaceC0372ne interfaceC0372ne, int i, byte b, int i2) throws IOException {
        if (i2 == 0) {
            throw m7016(C0459zf.m11214(), new Object[0]);
        }
        boolean z = (b & 1) != 0;
        if ((b & 32) != 0) {
            throw m7016(C0450yf.m9465(), new Object[0]);
        }
        short sM8575 = (b & 8) != 0 ? (short) (C0446yb.m8575(m6985(this)) & 255) : (short) 0;
        m6973(interfaceC0372ne, z, i2, m6985(this), m6995(i, b, sM8575));
        C0461zs.m11605(m6985(this), sM8575);
    }

    private void m1192b(InterfaceC0372ne interfaceC0372ne, int i, byte b, int i2) throws IOException {
        if (i < 8) {
            throw m7016(C0453yj.m9862(), new Object[]{abd.m2028(i)});
        }
        if (i2 != 0) {
            throw m7016(C0447yc.m8816(), new Object[0]);
        }
        int iM10834 = C0458ze.m10834(m6985(this));
        int iM10835 = C0458ze.m10834(m6985(this));
        int i3 = i - 8;
        EnumC0346mf enumC0346mfM2578 = abf.m2578(iM10835);
        if (enumC0346mfM2578 == null) {
            throw m7016(C0455za.m10056(), new Object[]{abd.m2028(iM10835)});
        }
        C0412or c0412orM2357 = abe.m2357();
        if (i3 > 0) {
            c0412orM2357 = C0447yc.m8847(m6985(this), i3);
        }
        m6979(interfaceC0372ne, iM10834, enumC0346mfM2578, c0412orM2357);
    }

    private void m1193c(InterfaceC0372ne interfaceC0372ne, int i, byte b, int i2) throws IOException {
        int i3 = i;
        if (i2 == 0) {
            throw m7016(C0449ye.m9124(), new Object[0]);
        }
        boolean z = (b & 1) != 0;
        short sM8575 = (b & 8) != 0 ? (short) (C0446yb.m8575(m6985(this)) & 255) : (short) 0;
        if ((b & 32) != 0) {
            m6958(this, interfaceC0372ne, i2);
            i3 -= 5;
        }
        m6986(interfaceC0372ne, z, i2, -1, m6991(this, m6995(i3, b, sM8575), sM8575, b, i2));
    }

    private void m1194d(InterfaceC0372ne interfaceC0372ne, int i, byte b, int i2) throws IOException {
        if (i != 8) {
            throw m7016(abf.m2646(), new Object[]{abd.m2028(i)});
        }
        if (i2 != 0) {
            throw m7016(C0447yc.m8736(), new Object[0]);
        }
        m6997(interfaceC0372ne, (b & 1) != 0, C0458ze.m10834(m6985(this)), C0458ze.m10834(m6985(this)));
    }

    private void m1195e(InterfaceC0372ne interfaceC0372ne, int i, byte b, int i2) throws IOException {
        if (i != 5) {
            throw m7016(C0452yh.m9777(), new Object[]{abd.m2028(i)});
        }
        if (i2 == 0) {
            throw m7016(abd.m2167(), new Object[0]);
        }
        m6958(this, interfaceC0372ne, i2);
    }

    private void m1196f(InterfaceC0372ne interfaceC0372ne, int i, byte b, int i2) throws IOException {
        if (i2 == 0) {
            throw m7016(C0460zg.m11318(), new Object[0]);
        }
        short sM8575 = (b & 8) != 0 ? (short) (C0446yb.m8575(m6985(this)) & 255) : (short) 0;
        m6999(interfaceC0372ne, i2, C0458ze.m10834(m6985(this)) & Integer.MAX_VALUE, m6991(this, m6995(i - 4, b, sM8575), sM8575, b, i2));
    }

    private void m1197g(InterfaceC0372ne interfaceC0372ne, int i, byte b, int i2) throws IOException {
        if (i != 4) {
            throw m7016(C0459zf.m11045(), new Object[]{abd.m2028(i)});
        }
        if (i2 == 0) {
            throw m7016(C0461zs.m11648(), new Object[0]);
        }
        int iM10834 = C0458ze.m10834(m6985(this));
        EnumC0346mf enumC0346mfM2578 = abf.m2578(iM10834);
        if (enumC0346mfM2578 == null) {
            throw m7016(C0448yd.m9035(), new Object[]{abd.m2028(iM10834)});
        }
        m7013(interfaceC0372ne, i2, enumC0346mfM2578);
    }

    private void m1198h(InterfaceC0372ne interfaceC0372ne, int i, byte b, int i2) throws IOException {
        if (i2 != 0) {
            throw m7016(C0445ya.m8344(), new Object[0]);
        }
        if ((b & 1) != 0) {
            if (i != 0) {
                throw m7016(C0455za.m10232(), new Object[0]);
            }
            m6966(interfaceC0372ne);
            return;
        }
        if (i % 6 != 0) {
            throw m7016(C0458ze.m10893(), new Object[]{abd.m2028(i)});
        }
        C0383np c0383np = new C0383np();
        for (int i3 = 0; i3 < i; i3 += 6) {
            short sM1754 = abc.m1754(m6985(this));
            int iM10834 = C0458ze.m10834(m6985(this));
            switch (sM1754) {
                case 2:
                    if (iM10834 != 0 && iM10834 != 1) {
                        throw m7016(C0459zf.m11216(), new Object[0]);
                    }
                    break;
                    break;
                case 3:
                    sM1754 = 4;
                    break;
                case 4:
                    sM1754 = 7;
                    if (iM10834 < 0) {
                        throw m7016(C0453yj.m9961(), new Object[0]);
                    }
                    break;
                    break;
                case 5:
                    if (iM10834 < 16384 || iM10834 > 16777215) {
                        throw m7016(C0449ye.m9096(), new Object[]{abd.m2028(iM10834)});
                    }
                    break;
                    break;
            }
            m6955(c0383np, sM1754, iM10834);
        }
        m7008(interfaceC0372ne, false, c0383np);
    }

    private void m1199i(InterfaceC0372ne interfaceC0372ne, int i, byte b, int i2) throws IOException {
        if (i != 4) {
            throw m7016(C0449ye.m9161(), new Object[]{abd.m2028(i)});
        }
        long jM10834 = ((long) C0458ze.m10834(m6985(this))) & 2147483647L;
        if (jM10834 == 0) {
            throw m7016(abf.m2549(), new Object[]{C0456zb.m10500(jM10834)});
        }
        m6965(interfaceC0372ne, i2, jM10834);
    }

    public static String m6949(boolean z, int i, int i2, byte b, byte b2) {
        if (C0456zb.m10326() < 0) {
            return m7033(z, i, i2, b, b2);
        }
        return null;
    }

    public static Logger m6950() {
        if (abf.m2510() <= 0) {
            return m7046();
        }
        return null;
    }

    public static void m6951(Object obj, int i, int i2, int i3, boolean z) {
        if (C0458ze.m10932() > 0) {
            ((InterfaceC0372ne) obj).mo1182b(i, i2, i3, z);
        }
    }

    public static void m6952(Object obj) {
        if (abd.m2162() > 0) {
            m7031(obj);
        }
    }

    public static int m6953(int i, byte b, short s) {
        if (C0446yb.m8415() < 0) {
            return m1187a(i, b, s);
        }
        return 0;
    }

    public static boolean m6954(Object obj, boolean z, Object obj2) {
        if (gggy.m4269() < 0) {
            return m7058(obj, z, obj2);
        }
        return false;
    }

    public static C0383np m6955(Object obj, int i, int i2) {
        if (C0446yb.m8415() < 0) {
            return m7054(obj, i, i2);
        }
        return null;
    }

    public static void m6956(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0447yc.m8635() > 0) {
            m7043(obj, obj2, i, b, i2);
        }
    }

    public static boolean m6957(Object obj) {
        if (C0451yg.m9580() > 0) {
            return m7037(obj);
        }
        return false;
    }

    public static void m6958(Object obj, Object obj2, int i) {
        if (C0446yb.m8415() < 0) {
            m7028(obj, obj2, i);
        }
    }

    public static void m6959(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (adds.m2755() > 0) {
            m7053(obj, obj2, i, b, i2);
        }
    }

    public static List m6960(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0349mi) obj).m1130ew();
        }
        return null;
    }

    public static void m6961(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0452yh.m9798() >= 0) {
            ((C0370nc) obj).m1194d((InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static Logger m6962() {
        if (C0445ya.m8222() >= 0) {
            return f1181tb;
        }
        return null;
    }

    public static void m6963(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (abe.m2308() < 0) {
            ((C0370nc) obj).m1196f((InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static void m6964(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0460zg.m11287() >= 0) {
            ((C0370nc) obj).m1195e((InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static void m6965(Object obj, int i, long j) {
        if (abc.m1845() <= 0) {
            m7048(obj, i, j);
        }
    }

    public static void m6966(Object obj) {
        if (C0450yf.m9352() <= 0) {
            m7041(obj);
        }
    }

    public static int m6967(Object obj) {
        if (adds.m2755() >= 0) {
            return m1188a((InterfaceC0411oq) obj);
        }
        return 0;
    }

    public static void m6968(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0453yj.m10013() >= 0) {
            m7049(obj, obj2, i, b, i2);
        }
    }

    public static void m6969(Object obj, boolean z, int i, int i2, Object obj2) {
        if (C0461zs.m11510() < 0) {
            ((InterfaceC0372ne) obj).mo1179a(z, i, i2, (List<C0347mg>) obj2);
        }
    }

    public static void m6970(Object obj, Object obj2, int i) {
        if (C0458ze.m10932() > 0) {
            ((C0370nc) obj).m1190a((InterfaceC0372ne) obj2, i);
        }
    }

    public static void m6971(Object obj, boolean z, Object obj2) {
        if (C0460zg.m11287() > 0) {
            ((InterfaceC0372ne) obj).mo1181a(z, (C0383np) obj2);
        }
    }

    public static int m6972(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return m7027(obj);
        }
        return 0;
    }

    public static void m6973(Object obj, boolean z, int i, Object obj2, int i2) {
        if (C0457zc.m10735() < 0) {
            m7025(obj, z, i, obj2, i2);
        }
    }

    public static void m6974(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0447yc.m8635() > 0) {
            m7040(obj, obj2, i, b, i2);
        }
    }

    public static void m6975(Object obj, boolean z, int i, int i2) {
        if (C0447yc.m8635() > 0) {
            ((InterfaceC0372ne) obj).mo1178a(z, i, i2);
        }
    }

    public static InterfaceC0411oq m6976(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0370nc) obj).f1185tf;
        }
        return null;
    }

    public static IOException m6977(Object obj, Object obj2) {
        if (C0448yd.m9079() < 0) {
            return C0351mk.m1144d((String) obj, (Object[]) obj2);
        }
        return null;
    }

    public static int m6978() {
        if (C0447yc.m8635() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static void m6979(Object obj, int i, Object obj2, Object obj3) {
        if (C0453yj.m10013() >= 0) {
            m7039(obj, i, obj2, obj3);
        }
    }

    public static C0383np m6980(Object obj, int i, int i2) {
        if (C0448yd.m9079() <= 0) {
            return ((C0383np) obj).m1261d(i, i2);
        }
        return null;
    }

    public static void m6981(Object obj, int i, int i2, int i3, boolean z) {
        if (C0458ze.m10932() > 0) {
            m7029(obj, i, i2, i3, z);
        }
    }

    public static void m6982(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0458ze.m10932() > 0) {
            m7023(obj, obj2, i, b, i2);
        }
    }

    public static void m6983(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0448yd.m9079() <= 0) {
            ((C0370nc) obj).m1199i((InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static void m6984(Object obj) {
        if (gggy.m4269() < 0) {
            ((InterfaceC0372ne) obj).mo1185eD();
        }
    }

    public static InterfaceC0411oq m6985(Object obj) {
        if (abd.m2162() >= 0) {
            return m7026(obj);
        }
        return null;
    }

    public static void m6986(Object obj, boolean z, int i, int i2, Object obj2) {
        if (C0448yd.m9079() < 0) {
            m7056(obj, z, i, i2, obj2);
        }
    }

    public static void m6987(Object obj, int i, long j) {
        if (C0450yf.m9352() <= 0) {
            ((InterfaceC0372ne) obj).mo1183b(i, j);
        }
    }

    public static void m6988(Object obj, int i, Object obj2) {
        if (C0450yf.m9352() <= 0) {
            ((InterfaceC0372ne) obj).mo1184d(i, (EnumC0346mf) obj2);
        }
    }

    public static List m6989(Object obj) {
        if (abf.m2510() < 0) {
            return m7047(obj);
        }
        return null;
    }

    public static String m6990(boolean z, int i, int i2, byte b, byte b2) {
        if (C0453yj.m10013() >= 0) {
            return C0351mk.m1142a(z, i, i2, b, b2);
        }
        return null;
    }

    public static List m6991(Object obj, int i, short s, byte b, int i2) {
        if (abc.m1845() < 0) {
            return m7057(obj, i, s, b, i2);
        }
        return null;
    }

    public static void m6992(Object obj) {
        if (C0450yf.m9352() < 0) {
            ((C0349mi) obj).m1132ey();
        }
    }

    public static C0349mi m6993(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0370nc) obj).f1184te;
        }
        return null;
    }

    public static void m6994(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0456zb.m10326() <= 0) {
            ((C0370nc) obj).m1198h((InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static int m6995(int i, byte b, short s) {
        if (C0458ze.m10932() >= 0) {
            return m7052(i, b, s);
        }
        return 0;
    }

    public static C0412or m6996() {
        if (C0445ya.m8222() >= 0) {
            return C0351mk.f1097rD;
        }
        return null;
    }

    public static void m6997(Object obj, boolean z, int i, int i2) {
        if (C0451yg.m9580() >= 0) {
            m7032(obj, z, i, i2);
        }
    }

    public static List m6998(Object obj, int i, short s, byte b, int i2) {
        if (abc.m1845() < 0) {
            return ((C0370nc) obj).m1189a(i, s, b, i2);
        }
        return null;
    }

    public static void m6999(Object obj, int i, int i2, Object obj2) {
        if (C0445ya.m8222() >= 0) {
            m7036(obj, i, i2, obj2);
        }
    }

    public static void m7000(Object obj, boolean z, int i, Object obj2, int i2) {
        if (abd.m2162() >= 0) {
            ((InterfaceC0372ne) obj).mo1180a(z, i, (InterfaceC0411oq) obj2, i2);
        }
    }

    public static void m7001(Object obj) {
        if (C0446yb.m8415() < 0) {
            ((InterfaceC0411oq) obj).close();
        }
    }

    public static void m7002(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (abe.m2308() <= 0) {
            m7051(obj, obj2, i, b, i2);
        }
    }

    public static boolean m7003(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0370nc) obj).f1182tc;
        }
        return false;
    }

    public static C0349mi m7004(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m7044(obj);
        }
        return null;
    }

    public static boolean m7005(Object obj, boolean z, Object obj2) {
        if (C0451yg.m9580() > 0) {
            return ((C0370nc) obj).m1201a(z, (InterfaceC0372ne) obj2);
        }
        return false;
    }

    public static C0371nd m7006(Object obj) {
        if (abc.m1845() < 0) {
            return m7034(obj);
        }
        return null;
    }

    public static void m7007(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (gggy.m4269() < 0) {
            ((C0370nc) obj).m1193c((InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static void m7008(Object obj, boolean z, Object obj2) {
        if (C0457zc.m10735() < 0) {
            m7035(obj, z, obj2);
        }
    }

    public static void m7009(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0445ya.m8222() >= 0) {
            m7042(obj, obj2, i, b, i2);
        }
    }

    public static void m7010(Object obj) {
        if (C0453yj.m10013() > 0) {
            m7030(obj);
        }
    }

    public static void m7011(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0461zs.m11510() < 0) {
            m7038(obj, obj2, i, b, i2);
        }
    }

    public static void m7012(Object obj, int i, Object obj2, Object obj3) {
        if (C0448yd.m9079() <= 0) {
            ((InterfaceC0372ne) obj).mo1177a(i, (EnumC0346mf) obj2, (C0412or) obj3);
        }
    }

    public static void m7013(Object obj, int i, Object obj2) {
        if (C0452yh.m9798() >= 0) {
            m7045(obj, i, obj2);
        }
    }

    public static void m7014(Object obj, long j) {
        if (C0459zf.m11062() >= 0) {
            C0598.m11851(obj, j);
        }
    }

    public static C0412or m7015() {
        if (C0447yc.m8635() > 0) {
            return m7050();
        }
        return null;
    }

    public static IOException m7016(Object obj, Object obj2) {
        if (C0459zf.m11062() > 0) {
            return m7055(obj, obj2);
        }
        return null;
    }

    public static void m7017(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0447yc.m8635() > 0) {
            m7024(obj, obj2, i, b, i2);
        }
    }

    public static C0371nd m7018(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0370nc) obj).f1183td;
        }
        return null;
    }

    public static void m7019(Object obj, int i, int i2, Object obj2) {
        if (C0453yj.m10013() >= 0) {
            ((InterfaceC0372ne) obj).mo1176a(i, i2, (List<C0347mg>) obj2);
        }
    }

    public static void m7020(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0457zc.m10735() < 0) {
            ((C0370nc) obj).m1192b((InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static void m7021(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (gggy.m4269() <= 0) {
            ((C0370nc) obj).m1197g((InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static void m7022(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0447yc.m8635() > 0) {
            ((C0370nc) obj).m1191a((InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static void m7023(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0453yj.m9945() <= 0) {
            m6963((C0370nc) obj, (InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static void m7024(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0456zb.m10484() < 0) {
            m6961((C0370nc) obj, (InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static void m7025(Object obj, boolean z, int i, Object obj2, int i2) {
        if (C0453yj.m9945() < 0) {
            m7000((InterfaceC0372ne) obj, z, i, (InterfaceC0411oq) obj2, i2);
        }
    }

    public static InterfaceC0411oq m7026(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m6976((C0370nc) obj);
        }
        return null;
    }

    public static int m7027(Object obj) {
        if (abf.m2500() >= 0) {
            return m6967((InterfaceC0411oq) obj);
        }
        return 0;
    }

    public static void m7028(Object obj, Object obj2, int i) {
        if (C0457zc.m10718() <= 0) {
            m6970((C0370nc) obj, (InterfaceC0372ne) obj2, i);
        }
    }

    public static void m7029(Object obj, int i, int i2, int i3, boolean z) {
        if (C0445ya.m8330() > 0) {
            m6951((InterfaceC0372ne) obj, i, i2, i3, z);
        }
    }

    public static void m7030(Object obj) {
        if (C0445ya.m8330() >= 0) {
            m7001((InterfaceC0411oq) obj);
        }
    }

    public static void m7031(Object obj) {
        if (C0453yj.m9945() < 0) {
            m6992((C0349mi) obj);
        }
    }

    public static void m7032(Object obj, boolean z, int i, int i2) {
        if (C0453yj.m10032() >= 0) {
            m6975((InterfaceC0372ne) obj, z, i, i2);
        }
    }

    public static String m7033(boolean z, int i, int i2, byte b, byte b2) {
        if (C0447yc.m8786() >= 0) {
            return m6990(z, i, i2, b, b2);
        }
        return null;
    }

    public static C0371nd m7034(Object obj) {
        if (abe.m2321() < 0) {
            return m7018((C0370nc) obj);
        }
        return null;
    }

    public static void m7035(Object obj, boolean z, Object obj2) {
        if (gggy.m4365() >= 0) {
            m6971((InterfaceC0372ne) obj, z, (C0383np) obj2);
        }
    }

    public static void m7036(Object obj, int i, int i2, Object obj2) {
        if (C0453yj.m10032() > 0) {
            m7019((InterfaceC0372ne) obj, i, i2, (List) obj2);
        }
    }

    public static boolean m7037(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m7003((C0370nc) obj);
        }
        return false;
    }

    public static void m7038(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0447yc.m8786() > 0) {
            m6983((C0370nc) obj, (InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static void m7039(Object obj, int i, Object obj2, Object obj3) {
        if (C0453yj.m9945() <= 0) {
            m7012((InterfaceC0372ne) obj, i, (EnumC0346mf) obj2, (C0412or) obj3);
        }
    }

    public static void m7040(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0458ze.m10926() < 0) {
            m7022((C0370nc) obj, (InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static void m7041(Object obj) {
        if (abd.m2021() >= 0) {
            m6984((InterfaceC0372ne) obj);
        }
    }

    public static void m7042(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0457zc.m10555() >= 0) {
            m6994((C0370nc) obj, (InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static void m7043(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0453yj.m9945() <= 0) {
            m6964((C0370nc) obj, (InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static C0349mi m7044(Object obj) {
        if (C0447yc.m8786() > 0) {
            return m6993((C0370nc) obj);
        }
        return null;
    }

    public static void m7045(Object obj, int i, Object obj2) {
        if (abe.m2321() <= 0) {
            m6988((InterfaceC0372ne) obj, i, (EnumC0346mf) obj2);
        }
    }

    public static Logger m7046() {
        if (C0448yd.m9015() <= 0) {
            return m6962();
        }
        return null;
    }

    public static List m7047(Object obj) {
        if (abe.m2321() < 0) {
            return m6960((C0349mi) obj);
        }
        return null;
    }

    public static void m7048(Object obj, int i, long j) {
        if (C0445ya.m8330() >= 0) {
            m6987((InterfaceC0372ne) obj, i, j);
        }
    }

    public static void m7049(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0460zg.m11293() > 0) {
            m7021((C0370nc) obj, (InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static C0412or m7050() {
        if (m6978() > 0) {
            return m6996();
        }
        return null;
    }

    public static void m7051(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0447yc.m8786() >= 0) {
            m7007((C0370nc) obj, (InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static int m7052(int i, byte b, short s) {
        if (C0453yj.m9945() < 0) {
            return m6953(i, b, s);
        }
        return 0;
    }

    public static void m7053(Object obj, Object obj2, int i, byte b, int i2) throws IOException {
        if (C0448yd.m9074() <= 0) {
            m7020((C0370nc) obj, (InterfaceC0372ne) obj2, i, b, i2);
        }
    }

    public static C0383np m7054(Object obj, int i, int i2) {
        if (abf.m2500() > 0) {
            return m6980((C0383np) obj, i, i2);
        }
        return null;
    }

    public static IOException m7055(Object obj, Object obj2) {
        if (C0453yj.m9996() < 0) {
            return m6977((String) obj, (Object[]) obj2);
        }
        return null;
    }

    public static void m7056(Object obj, boolean z, int i, int i2, Object obj2) {
        if (C0456zb.m10484() <= 0) {
            m6969((InterfaceC0372ne) obj, z, i, i2, (List) obj2);
        }
    }

    public static List m7057(Object obj, int i, short s, byte b, int i2) {
        if (C0460zg.m11293() >= 0) {
            return m6998((C0370nc) obj, i, s, b, i2);
        }
        return null;
    }

    public static boolean m7058(Object obj, boolean z, Object obj2) {
        if (abf.m2500() > 0) {
            return m7005((C0370nc) obj, z, (InterfaceC0372ne) obj2);
        }
        return false;
    }

    public void m1200a(InterfaceC0372ne interfaceC0372ne) {
        if (m6957(this)) {
            if (!m6954(this, true, interfaceC0372ne)) {
                throw m7016(abf.m2483(), new Object[0]);
            }
            return;
        }
        C0412or c0412orM8847 = C0447yc.m8847(m6985(this), gggy.m4418(m7015()));
        if (C0450yf.m9421(m6950(), C0447yc.m8836())) {
            C0459zf.m10980(m6950(), gggy.m4389(C0453yj.m9908(), new Object[]{gggy.m4359(c0412orM8847)}));
        }
        if (!C0459zf.m11211(m7015(), c0412orM8847)) {
            throw m7016(gggy.m4469(), new Object[]{C0458ze.m10854(c0412orM8847)});
        }
    }

    public boolean m1201a(boolean z, InterfaceC0372ne interfaceC0372ne) throws IOException {
        try {
            m7014(m6985(this), 9L);
            int iM6972 = m6972(m6985(this));
            if (iM6972 < 0 || iM6972 > 16384) {
                throw m7016(gggy.m4374(), new Object[]{abd.m2028(iM6972)});
            }
            byte bM8575 = (byte) (C0446yb.m8575(m6985(this)) & 255);
            if (z && bM8575 != 4) {
                throw m7016(abf.m2550(), new Object[]{C0460zg.m11246(bM8575)});
            }
            byte bM8576 = (byte) (C0446yb.m8575(m6985(this)) & 255);
            int iM10834 = C0458ze.m10834(m6985(this)) & Integer.MAX_VALUE;
            if (C0450yf.m9421(m6950(), C0447yc.m8836())) {
                C0459zf.m10980(m6950(), m6949(true, iM10834, iM6972, bM8575, bM8576));
            }
            switch (bM8575) {
                case 0:
                    m6974(this, interfaceC0372ne, iM6972, bM8576, iM10834);
                    return true;
                case 1:
                    m7002(this, interfaceC0372ne, iM6972, bM8576, iM10834);
                    return true;
                case 2:
                    m6956(this, interfaceC0372ne, iM6972, bM8576, iM10834);
                    return true;
                case 3:
                    m6968(this, interfaceC0372ne, iM6972, bM8576, iM10834);
                    return true;
                case 4:
                    m7009(this, interfaceC0372ne, iM6972, bM8576, iM10834);
                    return true;
                case 5:
                    m6982(this, interfaceC0372ne, iM6972, bM8576, iM10834);
                    return true;
                case 6:
                    m7017(this, interfaceC0372ne, iM6972, bM8576, iM10834);
                    return true;
                case 7:
                    m6959(this, interfaceC0372ne, iM6972, bM8576, iM10834);
                    return true;
                case 8:
                    m7011(this, interfaceC0372ne, iM6972, bM8576, iM10834);
                    return true;
                default:
                    C0461zs.m11605(m6985(this), iM6972);
                    return true;
            }
        } catch (IOException e) {
            return false;
        }
    }

    @Override
    public void close() {
        m7010(m6985(this));
    }
}
