package com.google.android.material.card2;

import java.io.Closeable;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

final class C0377nj implements Closeable {

    private static final Logger f1218tH = C0460zg.m11225(C0456zb.m10455(C0351mk.class));

    private boolean f1219oL;

    private final boolean f1220tI;

    private final C0409oo f1221tJ = new C0409oo();

    final C0350mj f1222tK = new C0350mj(m7326(this));

    private int f1223tL = 16384;

    private final InterfaceC0410op f1224tM;

    C0377nj(InterfaceC0410op interfaceC0410op, boolean z) {
        this.f1224tM = interfaceC0410op;
        this.f1220tI = z;
    }

    private static void m1228a(InterfaceC0410op interfaceC0410op, int i) {
        C0455za.m10213(interfaceC0410op, (i >>> 16) & 255);
        C0455za.m10213(interfaceC0410op, (i >>> 8) & 255);
        C0455za.m10213(interfaceC0410op, i & 255);
    }

    private void m1229c(int i, long j) {
        long j2 = j;
        while (j2 > 0) {
            int iM9495 = (int) C0450yf.m9495(m7316(this), j2);
            j2 -= (long) iM9495;
            m7330(this, i, iM9495, (byte) 9, j2 == 0 ? (byte) 4 : (byte) 0);
            m7339(m7333(this), m7326(this), iM9495);
        }
    }

    public static Logger m7292() {
        if (C0446yb.m8415() <= 0) {
            return f1218tH;
        }
        return null;
    }

    public static void m7293(Object obj, int i, byte b, Object obj2, int i2) {
        if (C0446yb.m8415() < 0) {
            m7357(obj, i, b, obj2, i2);
        }
    }

    public static int m7294(Object obj, int i) {
        if (C0453yj.m10013() > 0) {
            return m7344(obj, i);
        }
        return 0;
    }

    public static void m7295(Object obj, Object obj2, long j) {
        if (abd.m2162() >= 0) {
            ((InterfaceC0410op) obj).mo1045b((C0409oo) obj2, j);
        }
    }

    public static int m7296() {
        if (C0459zf.m11062() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static void m7297(Object obj, Object obj2) {
        if (gggy.m4269() <= 0) {
            ((C0350mj) obj).m1139c((List) obj2);
        }
    }

    public static boolean m7298(Object obj, int i) {
        if (adds.m2755() >= 0) {
            return m7343(obj, i);
        }
        return false;
    }

    public static boolean m7299(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0377nj) obj).f1220tI;
        }
        return false;
    }

    public static void m7300(Object obj, int i, int i2, byte b, byte b2) {
        if (adds.m2755() >= 0) {
            ((C0377nj) obj).m1231a(i, i2, b, b2);
        }
    }

    public static InterfaceC0410op m7301(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0377nj) obj).f1224tM;
        }
        return null;
    }

    public static void m7302(Object obj, boolean z, int i, Object obj2) throws IOException {
        if (adds.m2755() > 0) {
            m7350(obj, z, i, obj2);
        }
    }

    public static int m7303(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0377nj) obj).f1223tL;
        }
        return 0;
    }

    public static void m7304(Object obj, int i, long j) {
        if (adds.m2755() >= 0) {
            ((C0377nj) obj).m1229c(i, j);
        }
    }

    public static void m7305(Object obj, int i) {
        if (abd.m2162() >= 0) {
            m7341(obj, i);
        }
    }

    public static C0409oo m7306(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0377nj) obj).f1221tJ;
        }
        return null;
    }

    public static void m7307(Object obj, Object obj2) {
        if (C0458ze.m10932() > 0) {
            m7349(obj, obj2);
        }
    }

    public static Logger m7308() {
        if (abf.m2510() <= 0) {
            return m7364();
        }
        return null;
    }

    public static int m7309(Object obj) {
        if (abe.m2308() < 0) {
            return m7362(obj);
        }
        return 0;
    }

    public static boolean m7310(Object obj, int i) {
        if (abd.m2162() > 0) {
            return ((C0383np) obj).m1259A(i);
        }
        return false;
    }

    public static void m7311(Object obj, int i) {
        if (C0458ze.m10932() > 0) {
            m1228a((InterfaceC0410op) obj, i);
        }
    }

    public static int m7312(Object obj, int i) {
        if (C0458ze.m10932() >= 0) {
            return m7354(obj, i);
        }
        return 0;
    }

    public static String m7313(boolean z, int i, int i2, byte b, byte b2) {
        if (abd.m2162() > 0) {
            return m7360(z, i, i2, b, b2);
        }
        return null;
    }

    public static void m7314(Object obj) {
        if (C0451yg.m9580() >= 0) {
            m7356(obj);
        }
    }

    public static void m7315(Object obj) {
        if (C0456zb.m10326() <= 0) {
            ((InterfaceC0410op) obj).close();
        }
    }

    public static int m7316(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return m7359(obj);
        }
        return 0;
    }

    public static int m7317(Object obj, int i) {
        if (C0460zg.m11287() >= 0) {
            return ((C0383np) obj).m1266z(i);
        }
        return 0;
    }

    public static void m7318(Object obj, boolean z, int i, Object obj2) throws IOException {
        if (abd.m2162() >= 0) {
            ((C0377nj) obj).m1237a(z, i, (List<C0347mg>) obj2);
        }
    }

    public static int m7319(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m7363(obj);
        }
        return 0;
    }

    public static int m7320(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0383np) obj).m1262fa();
        }
        return 0;
    }

    public static IllegalArgumentException m7321(Object obj, Object obj2) {
        if (gggy.m4269() <= 0) {
            return m7355(obj, obj2);
        }
        return null;
    }

    public static String m7322(boolean z, int i, int i2, byte b, byte b2) {
        if (C0446yb.m8415() < 0) {
            return C0351mk.m1142a(z, i, i2, b, b2);
        }
        return null;
    }

    public static void m7323(Object obj, int i) {
        if (C0450yf.m9352() <= 0) {
            m7342(obj, i);
        }
    }

    public static C0350mj m7324(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0377nj) obj).f1222tK;
        }
        return null;
    }

    public static void m7325(Object obj, int i, long j) {
        if (abf.m2510() < 0) {
            m7347(obj, i, j);
        }
    }

    public static C0409oo m7326(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return m7352(obj);
        }
        return null;
    }

    public static C0350mj m7327(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return m7361(obj);
        }
        return null;
    }

    public static boolean m7328(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return m7346(obj);
        }
        return false;
    }

    public static boolean m7329(Object obj) {
        if (abe.m2308() < 0) {
            return m7351(obj);
        }
        return false;
    }

    public static void m7330(Object obj, int i, int i2, byte b, byte b2) {
        if (C0453yj.m10013() >= 0) {
            m7358(obj, i, i2, b, b2);
        }
    }

    public static C0412or m7331() {
        if (adds.m2755() > 0) {
            return m7345();
        }
        return null;
    }

    public static void m7332(Object obj, int i, byte b, Object obj2, int i2) {
        if (C0447yc.m8635() > 0) {
            ((C0377nj) obj).m1230a(i, b, (C0409oo) obj2, i2);
        }
    }

    public static InterfaceC0410op m7333(Object obj) {
        if (C0450yf.m9352() < 0) {
            return m7348(obj);
        }
        return null;
    }

    public static IllegalArgumentException m7334(Object obj, Object obj2) {
        if (adds.m2755() > 0) {
            return C0351mk.m1143c((String) obj, (Object[]) obj2);
        }
        return null;
    }

    public static int m7335(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0383np) obj).size();
        }
        return 0;
    }

    public static void m7336(Object obj, int i) {
        if (C0449ye.m9220() < 0) {
            ((C0350mj) obj).m1140s(i);
        }
    }

    public static C0412or m7337() {
        if (C0459zf.m11062() >= 0) {
            return C0351mk.f1097rD;
        }
        return null;
    }

    public static boolean m7338(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0377nj) obj).f1219oL;
        }
        return false;
    }

    public static void m7339(Object obj, Object obj2, long j) {
        if (C0460zg.m11287() >= 0) {
            m7353(obj, obj2, j);
        }
    }

    public static int m7340(Object obj, int i) {
        if (C0451yg.m9580() > 0) {
            return ((C0383np) obj).m1264x(i);
        }
        return 0;
    }

    public static void m7341(Object obj, int i) {
        if (C0457zc.m10718() <= 0) {
            m7336((C0350mj) obj, i);
        }
    }

    public static void m7342(Object obj, int i) {
        if (abd.m2021() > 0) {
            m7311((InterfaceC0410op) obj, i);
        }
    }

    public static boolean m7343(Object obj, int i) {
        if (C0445ya.m8330() > 0) {
            return m7310((C0383np) obj, i);
        }
        return false;
    }

    public static int m7344(Object obj, int i) {
        if (m7296() >= 0) {
            return m7317((C0383np) obj, i);
        }
        return 0;
    }

    public static C0412or m7345() {
        if (C0447yc.m8786() >= 0) {
            return m7337();
        }
        return null;
    }

    public static boolean m7346(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m7299((C0377nj) obj);
        }
        return false;
    }

    public static void m7347(Object obj, int i, long j) {
        if (C0453yj.m9966() >= 0) {
            m7304((C0377nj) obj, i, j);
        }
    }

    public static InterfaceC0410op m7348(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m7301((C0377nj) obj);
        }
        return null;
    }

    public static void m7349(Object obj, Object obj2) {
        if (C0448yd.m9015() < 0) {
            m7297((C0350mj) obj, (List) obj2);
        }
    }

    public static void m7350(Object obj, boolean z, int i, Object obj2) throws IOException {
        if (abd.m2166() < 0) {
            m7318((C0377nj) obj, z, i, (List) obj2);
        }
    }

    public static boolean m7351(Object obj) {
        if (abd.m2166() < 0) {
            return m7338((C0377nj) obj);
        }
        return false;
    }

    public static C0409oo m7352(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m7306((C0377nj) obj);
        }
        return null;
    }

    public static void m7353(Object obj, Object obj2, long j) {
        if (abd.m2166() < 0) {
            m7295((InterfaceC0410op) obj, (C0409oo) obj2, j);
        }
    }

    public static int m7354(Object obj, int i) {
        if (C0460zg.m11293() > 0) {
            return m7340((C0383np) obj, i);
        }
        return 0;
    }

    public static IllegalArgumentException m7355(Object obj, Object obj2) {
        if (abd.m2166() < 0) {
            return m7334((String) obj, (Object[]) obj2);
        }
        return null;
    }

    public static void m7356(Object obj) {
        if (C0456zb.m10484() <= 0) {
            m7315((InterfaceC0410op) obj);
        }
    }

    public static void m7357(Object obj, int i, byte b, Object obj2, int i2) {
        if (C0445ya.m8330() > 0) {
            m7332((C0377nj) obj, i, b, (C0409oo) obj2, i2);
        }
    }

    public static void m7358(Object obj, int i, int i2, byte b, byte b2) {
        if (C0456zb.m10484() < 0) {
            m7300((C0377nj) obj, i, i2, b, b2);
        }
    }

    public static int m7359(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m7303((C0377nj) obj);
        }
        return 0;
    }

    public static String m7360(boolean z, int i, int i2, byte b, byte b2) {
        if (C0448yd.m9074() < 0) {
            return m7322(z, i, i2, b, b2);
        }
        return null;
    }

    public static C0350mj m7361(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m7324((C0377nj) obj);
        }
        return null;
    }

    public static int m7362(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m7335((C0383np) obj);
        }
        return 0;
    }

    public static int m7363(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m7320((C0383np) obj);
        }
        return 0;
    }

    public static Logger m7364() {
        if (C0448yd.m9074() <= 0) {
            return m7292();
        }
        return null;
    }

    void m1230a(int i, byte b, C0409oo c0409oo, int i2) {
        m7330(this, i, i2, (byte) 0, b);
        if (i2 > 0) {
            m7339(m7333(this), c0409oo, i2);
        }
    }

    public void m1231a(int i, int i2, byte b, byte b2) {
        if (C0450yf.m9421(m7308(), C0447yc.m8836())) {
            C0459zf.m10980(m7308(), m7313(false, i, i2, b, b2));
        }
        if (i2 > m7316(this)) {
            throw m7321(adds.m2677(), new Object[]{abd.m2028(m7316(this)), abd.m2028(i2)});
        }
        if ((Integer.MIN_VALUE & i) != 0) {
            throw m7321(gggy.m4398(), new Object[]{abd.m2028(i)});
        }
        m7323(m7333(this), i2);
        C0455za.m10213(m7333(this), b & 255);
        C0455za.m10213(m7333(this), b2 & 255);
        C0455za.m10262(m7333(this), Integer.MAX_VALUE & i);
    }

    public void m1232a(int i, int i2, List<C0347mg> list) {
        synchronized (this) {
            if (m7329(this)) {
                throw new IOException(C0447yc.m8663());
            }
            m7307(m7327(this), list);
            long jM10042 = C0455za.m10042(m7326(this));
            int iM9495 = (int) C0450yf.m9495(m7316(this) - 4, jM10042);
            m7330(this, i, iM9495 + 4, (byte) 5, jM10042 == ((long) iM9495) ? (byte) 4 : (byte) 0);
            C0455za.m10262(m7333(this), Integer.MAX_VALUE & i2);
            m7339(m7333(this), m7326(this), iM9495);
            if (jM10042 > iM9495) {
                m7325(this, i, jM10042 - ((long) iM9495));
            }
        }
    }

    public void m1233a(int i, EnumC0346mf enumC0346mf, byte[] bArr) {
        synchronized (this) {
            if (m7329(this)) {
                throw new IOException(C0447yc.m8663());
            }
            if (C0461zs.m11488(enumC0346mf) == -1) {
                throw m7321(C0457zc.m10687(), new Object[0]);
            }
            m7330(this, 0, bArr.length + 8, (byte) 7, (byte) 0);
            C0455za.m10262(m7333(this), i);
            C0455za.m10262(m7333(this), C0461zs.m11488(enumC0346mf));
            if (bArr.length > 0) {
                gggy.m4402(m7333(this), bArr);
            }
            C0458ze.m10814(m7333(this));
        }
    }

    public void m1234a(C0383np c0383np) {
        synchronized (this) {
            if (m7329(this)) {
                throw new IOException(C0447yc.m8663());
            }
            this.f1223tL = m7294(c0383np, m7316(this));
            if (m7319(c0383np) != -1) {
                m7305(m7327(this), m7319(c0383np));
            }
            m7330(this, 0, 0, (byte) 4, (byte) 1);
            C0458ze.m10814(m7333(this));
        }
    }

    public void m1235a(boolean z, int i, int i2) {
        synchronized (this) {
            if (m7329(this)) {
                throw new IOException(C0447yc.m8663());
            }
            m7330(this, 0, 8, (byte) 6, z ? (byte) 1 : (byte) 0);
            C0455za.m10262(m7333(this), i);
            C0455za.m10262(m7333(this), i2);
            C0458ze.m10814(m7333(this));
        }
    }

    public void m1236a(boolean z, int i, C0409oo c0409oo, int i2) {
        synchronized (this) {
            if (m7329(this)) {
                throw new IOException(C0447yc.m8663());
            }
            m7293(this, i, z ? (byte) 1 : (byte) 0, c0409oo, i2);
        }
    }

    void m1237a(boolean z, int i, List<C0347mg> list) throws IOException {
        if (m7329(this)) {
            throw new IOException(C0447yc.m8663());
        }
        m7307(m7327(this), list);
        long jM10042 = C0455za.m10042(m7326(this));
        int iM9495 = (int) C0450yf.m9495(m7316(this), jM10042);
        byte b = jM10042 == ((long) iM9495) ? (byte) 4 : (byte) 0;
        if (z) {
            b = (byte) (b | 1);
        }
        m7330(this, i, iM9495, (byte) 1, b);
        m7339(m7333(this), m7326(this), iM9495);
        if (jM10042 > iM9495) {
            m7325(this, i, jM10042 - ((long) iM9495));
        }
    }

    public void m1238b(int i, long j) {
        synchronized (this) {
            if (m7329(this)) {
                throw new IOException(C0447yc.m8663());
            }
            if (j == 0 || j > 2147483647L) {
                throw m7321(C0453yj.m10014(), new Object[]{C0456zb.m10500(j)});
            }
            m7330(this, i, 4, (byte) 8, (byte) 0);
            C0455za.m10262(m7333(this), (int) j);
            C0458ze.m10814(m7333(this));
        }
    }

    public void m1239b(C0383np c0383np) {
        int i;
        int i2 = 0;
        synchronized (this) {
            if (m7329(this)) {
                throw new IOException(C0447yc.m8663());
            }
            m7330(this, 0, m7309(c0383np) * 6, (byte) 4, (byte) 0);
            while (i2 < 10) {
                if (m7298(c0383np, i2)) {
                    if (i2 == 4) {
                        i = 3;
                    } else {
                        i = i2 == 7 ? 4 : i2;
                    }
                    C0448yd.m8851(m7333(this), i);
                    C0455za.m10262(m7333(this), m7312(c0383np, i2));
                }
                i2++;
            }
            C0458ze.m10814(m7333(this));
        }
    }

    public void m1240b(boolean z, int i, int i2, List<C0347mg> list) {
        synchronized (this) {
            if (m7329(this)) {
                throw new IOException(C0447yc.m8663());
            }
            m7302(this, z, i, list);
        }
    }

    @Override
    public void close() {
        synchronized (this) {
            this.f1219oL = true;
            m7314(m7333(this));
        }
    }

    public void m1241d(int i, EnumC0346mf enumC0346mf) {
        synchronized (this) {
            if (m7329(this)) {
                throw new IOException(C0447yc.m8663());
            }
            if (C0461zs.m11488(enumC0346mf) == -1) {
                throw new IllegalArgumentException();
            }
            m7330(this, i, 4, (byte) 3, (byte) 0);
            C0455za.m10262(m7333(this), C0461zs.m11488(enumC0346mf));
            C0458ze.m10814(m7333(this));
        }
    }

    public void m1242eT() {
        synchronized (this) {
            if (m7329(this)) {
                throw new IOException(C0447yc.m8663());
            }
            if (m7328(this)) {
                if (C0450yf.m9421(m7308(), C0447yc.m8836())) {
                    C0459zf.m10980(m7308(), gggy.m4389(C0456zb.m10305(), new Object[]{gggy.m4359(m7331())}));
                }
                gggy.m4402(m7333(this), C0455za.m10142(m7331()));
                C0458ze.m10814(m7333(this));
            }
        }
    }

    public int m1243eU() {
        return m7316(this);
    }

    public void flush() {
        synchronized (this) {
            if (m7329(this)) {
                throw new IOException(C0447yc.m8663());
            }
            C0458ze.m10814(m7333(this));
        }
    }
}
