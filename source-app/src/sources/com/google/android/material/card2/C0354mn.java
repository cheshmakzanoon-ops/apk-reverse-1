package com.google.android.material.card2;

import java.io.Closeable;
import java.io.IOException;
import java.net.Socket;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.SynchronousQueue;
import java.util.concurrent.ThreadPoolExecutor;

public final class C0354mn implements Closeable {

    static final boolean f1118rX;

    static final ExecutorService f1119rY;

    long f1120rZ;

    final boolean f1121sa;

    final String f1123sc;

    int f1124sd;

    final AbstractC0363mw f1125se;

    private int f1126sf;

    int f1127sg;

    private Map<Integer, C0380nm> f1130sj;

    private final ExecutorService f1131sk;

    final InterfaceC0381nn f1132sl;

    final C0365my f1133sm;

    boolean f1135so;

    final Socket f1136sp;

    final C0377nj f1139ss;

    final Map<Integer, C0373nf> f1137sq = new LinkedHashMap();

    long f1138sr = 0;

    C0383np f1128sh = new C0383np();

    final C0383np f1129si = new C0383np();

    boolean f1134sn = false;

    final Set<Integer> f1122sb = new LinkedHashSet();

    static {
        f1118rX = !C0460zg.m11342(C0354mn.class);
        f1119rY = new ThreadPoolExecutor(0, Integer.MAX_VALUE, 60L, C0446yb.m8507(), new SynchronousQueue(), C0446yb.m8515(C0455za.m10258(), true));
    }

    C0354mn(C0362mv c0362mv) {
        this.f1132sl = abc.m1862(c0362mv);
        this.f1121sa = abf.m2649(c0362mv);
        this.f1125se = C0453yj.m10025(c0362mv);
        this.f1127sg = abf.m2649(c0362mv) ? 1 : 2;
        if (abf.m2649(c0362mv)) {
            this.f1127sg = abf.m2634(this) + 2;
        }
        this.f1126sf = abf.m2649(c0362mv) ? 1 : 2;
        if (abf.m2649(c0362mv)) {
            C0452yh.m9776(C0456zb.m10276(this), 7, 16777216);
        }
        this.f1123sc = C0446yb.m8533(c0362mv);
        this.f1131sk = new ThreadPoolExecutor(0, 1, 60L, C0446yb.m8507(), new LinkedBlockingQueue(), C0446yb.m8515(gggy.m4389(abf.m2647(), new Object[]{C0450yf.m9391(this)}), true));
        C0452yh.m9776(C0449ye.m9195(this), 7, 65535);
        C0452yh.m9776(C0449ye.m9195(this), 5, 16384);
        this.f1120rZ = C0461zs.m11568(C0449ye.m9195(this));
        this.f1136sp = C0452yh.m9739(c0362mv);
        this.f1139ss = new C0377nj(C0450yf.m9346(c0362mv), abe.m2264(this));
        this.f1133sm = new C0365my(this, new C0370nc(C0449ye.m9203(c0362mv), abe.m2264(this)));
    }

    private C0373nf m1148a(int i, List<C0347mg> list, boolean z) {
        int iM2634;
        C0373nf c0373nf;
        boolean z2;
        boolean z3 = !z;
        synchronized (m6568(this)) {
            synchronized (this) {
                if (abe.m2393(this)) {
                    throw new C0345me();
                }
                iM2634 = abf.m2634(this);
                this.f1127sg = abf.m2634(this) + 2;
                c0373nf = new C0373nf(iM2634, this, z3, false, list);
                z2 = !z || C0459zf.m11157(this) == 0 || C0456zb.m10419(c0373nf) == 0;
                if (C0447yc.m8828(c0373nf)) {
                    C0445ya.m8264(abd.m2092(this), abd.m2028(iM2634), c0373nf);
                }
            }
            if (i == 0) {
                C0448yd.m8892(m6568(this), z3, iM2634, i, list);
            } else {
                if (abe.m2264(this)) {
                    throw new IllegalArgumentException(C0447yc.m8636());
                }
                C0456zb.m10519(m6568(this), i, iM2634, list);
            }
        }
        if (z2) {
            C0458ze.m10910(m6568(this));
        }
        return c0373nf;
    }

    public static void m6561(Object obj, boolean z, int i, int i2) {
        if (C0445ya.m8222() > 0) {
            ((C0377nj) obj).m1235a(z, i, i2);
        }
    }

    public static C0365my m6562(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0354mn) obj).f1133sm;
        }
        return null;
    }

    public static boolean m6563(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0354mn) obj).f1135so;
        }
        return false;
    }

    public static InterfaceC0410op m6564(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0362mv) obj).f1166pv;
        }
        return null;
    }

    public static void m6565(Object obj) {
        if (C0447yc.m8635() >= 0) {
            ((C0377nj) obj).m1242eT();
        }
    }

    public static void m6566(Object obj) {
        if (C0458ze.m10932() > 0) {
            ((C0377nj) obj).flush();
        }
    }

    public static int m6567(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0383np) obj).m1263fb();
        }
        return 0;
    }

    public static C0377nj m6568(Object obj) {
        if (adds.m2755() >= 0) {
            return m6659(obj);
        }
        return null;
    }

    public static void m6569(Object obj, int i, Object obj2, Object obj3) {
        if (abc.m1845() < 0) {
            ((C0377nj) obj).m1233a(i, (EnumC0346mf) obj2, (byte[]) obj3);
        }
    }

    public static InterfaceC0411oq m6570(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0362mv) obj).f1168px;
        }
        return null;
    }

    public static void m6571(Object obj, boolean z, int i, int i2, Object obj2) {
        if (gggy.m4269() < 0) {
            ((C0377nj) obj).m1240b(z, i, i2, (List) obj2);
        }
    }

    public static C0383np m6572(Object obj, int i, int i2) {
        if (C0452yh.m9798() >= 0) {
            return ((C0383np) obj).m1261d(i, i2);
        }
        return null;
    }

    public static C0383np m6573(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0354mn) obj).f1129si;
        }
        return null;
    }

    public static int m6574() {
        if (abd.m2162() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static long m6575(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0354mn) obj).f1120rZ;
        }
        return 0L;
    }

    public static void m6576(Object obj, int i, Object obj2) {
        if (C0456zb.m10326() < 0) {
            ((C0354mn) obj).m1162c(i, (EnumC0346mf) obj2);
        }
    }

    public static boolean m6577(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0354mn) obj).f1121sa;
        }
        return false;
    }

    public static void m6578(Object obj, Object obj2, Object obj3) throws IOException {
        if (C0451yg.m9580() >= 0) {
            ((C0354mn) obj).m1156a((EnumC0346mf) obj2, (EnumC0346mf) obj3);
        }
    }

    public static void m6579(Object obj, boolean z, int i, Object obj2, int i2) {
        if (C0445ya.m8222() >= 0) {
            ((C0377nj) obj).m1236a(z, i, (C0409oo) obj2, i2);
        }
    }

    public static void m6580(Object obj, int i, long j) {
        if (C0452yh.m9798() > 0) {
            ((C0377nj) obj).m1238b(i, j);
        }
    }

    public static boolean m6581(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0362mv) obj).f1169sa;
        }
        return false;
    }

    public static Socket m6582(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0362mv) obj).f1167pw;
        }
        return null;
    }

    public static void m6583(Object obj, int i, int i2, Object obj2) {
        if (adds.m2755() > 0) {
            ((C0377nj) obj).m1232a(i, i2, (List<C0347mg>) obj2);
        }
    }

    public static void m6584(Object obj) {
        if (C0461zs.m11510() < 0) {
            ((C0380nm) obj).m1254eZ();
        }
    }

    public static int m6585(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0377nj) obj).m1243eU();
        }
        return 0;
    }

    public static int m6586(Object obj, int i) {
        if (C0456zb.m10326() < 0) {
            return ((C0383np) obj).m1265y(i);
        }
        return 0;
    }

    public static long m6587(Object obj, Object obj2, long j) {
        if (C0445ya.m8222() > 0) {
            return ((InterfaceC0411oq) obj).mo966a((C0409oo) obj2, j);
        }
        return 0L;
    }

    public static Set m6588(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0354mn) obj).f1122sb;
        }
        return null;
    }

    public static int m6589(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0354mn) obj).f1127sg;
        }
        return 0;
    }

    public static long m6590(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0373nf) obj).f1193rZ;
        }
        return 0L;
    }

    public static C0383np m6591(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0354mn) obj).f1128sh;
        }
        return null;
    }

    public static void m6592(Object obj) {
        if (C0457zc.m10735() <= 0) {
            C0598.m11842(obj);
        }
    }

    public static InterfaceC0381nn m6593(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0362mv) obj).f1172sl;
        }
        return null;
    }

    public static C0377nj m6594(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0354mn) obj).f1139ss;
        }
        return null;
    }

    public static Map m6595(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0354mn) obj).f1137sq;
        }
        return null;
    }

    public static String m6596(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0362mv) obj).f1170sc;
        }
        return null;
    }

    public static ExecutorService m6597(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0354mn) obj).f1131sk;
        }
        return null;
    }

    public static C0373nf m6598(Object obj, int i, Object obj2, boolean z) {
        if (adds.m2755() >= 0) {
            return ((C0354mn) obj).m1148a(i, (List) obj2, z);
        }
        return null;
    }

    public static void m6599(Object obj) {
        if (C0449ye.m9220() < 0) {
            ((C0377nj) obj).close();
        }
    }

    public static int m6600(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0354mn) obj).f1124sd;
        }
        return 0;
    }

    public static void m6601(Object obj) {
        if (abe.m2308() < 0) {
            ((C0380nm) obj).m1252eX();
        }
    }

    public static void m6602(Object obj, boolean z) {
        if (C0452yh.m9798() > 0) {
            ((C0354mn) obj).m1167n(z);
        }
    }

    public static String m6603(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0354mn) obj).f1123sc;
        }
        return null;
    }

    public static ExecutorService m6604() {
        if (C0457zc.m10735() < 0) {
            return f1119rY;
        }
        return null;
    }

    public static boolean m6605() {
        if (C0447yc.m8635() >= 0) {
            return f1118rX;
        }
        return false;
    }

    public static AbstractC0363mw m6606(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0362mv) obj).f1171se;
        }
        return null;
    }

    public static C0365my m6607(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return m6648(obj);
        }
        return null;
    }

    public static void m6608(Object obj, Object obj2) {
        if (abe.m2308() <= 0) {
            ((C0377nj) obj).m1239b((C0383np) obj2);
        }
    }

    public static Socket m6609(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0354mn) obj).f1136sp;
        }
        return null;
    }

    public static Map m6610(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0354mn) obj).f1130sj;
        }
        return null;
    }

    public static void m6611(Object obj, int i, Object obj2) {
        if (C0446yb.m8415() < 0) {
            ((C0377nj) obj).m1241d(i, (EnumC0346mf) obj2);
        }
    }

    public static void m6612(Object obj, long j) {
        if (C0447yc.m8635() > 0) {
            C0598.m11851(obj, j);
        }
    }

    public static void m6613(Object obj, Object obj2) {
        if (C0456zb.m10326() < 0) {
            C0598.m11904(obj, obj2);
        }
    }

    public static long m6614(Object obj, Object obj2, long j) {
        if (C0445ya.m8330() > 0) {
            return m6587((InterfaceC0411oq) obj, (C0409oo) obj2, j);
        }
        return 0L;
    }

    public static void m6615(Object obj, boolean z, int i, int i2, Object obj2) {
        if (C0453yj.m9996() < 0) {
            m6571((C0377nj) obj, z, i, i2, (List) obj2);
        }
    }

    public static void m6616(Object obj, int i, long j) {
        if (C0453yj.m9945() <= 0) {
            m6580((C0377nj) obj, i, j);
        }
    }

    public static ExecutorService m6617(Object obj) {
        if (abd.m2021() >= 0) {
            return m6597((C0354mn) obj);
        }
        return null;
    }

    public static void m6618(Object obj, int i, Object obj2) {
        if (C0448yd.m9074() < 0) {
            m6576((C0354mn) obj, i, (EnumC0346mf) obj2);
        }
    }

    public static C0383np m6619(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m6573((C0354mn) obj);
        }
        return null;
    }

    public static Map m6620(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m6595((C0354mn) obj);
        }
        return null;
    }

    public static void m6621(Object obj) {
        if (C0456zb.m10484() <= 0) {
            m6566((C0377nj) obj);
        }
    }

    public static long m6622(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m6575((C0354mn) obj);
        }
        return 0L;
    }

    public static void m6623(Object obj, Object obj2) {
        if (C0453yj.m9945() < 0) {
            m6608((C0377nj) obj, (C0383np) obj2);
        }
    }

    public static Set m6624(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m6588((C0354mn) obj);
        }
        return null;
    }

    public static int m6625(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m6600((C0354mn) obj);
        }
        return 0;
    }

    public static int m6626(Object obj) {
        if (abf.m2500() > 0) {
            return m6567((C0383np) obj);
        }
        return 0;
    }

    public static Map m6627(Object obj) {
        if (gggy.m4365() >= 0) {
            return m6610((C0354mn) obj);
        }
        return null;
    }

    public static boolean m6628(Object obj) {
        if (abf.m2500() >= 0) {
            return m6577((C0354mn) obj);
        }
        return false;
    }

    public static Socket m6629(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m6609((C0354mn) obj);
        }
        return null;
    }

    public static InterfaceC0410op m6630(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m6564((C0362mv) obj);
        }
        return null;
    }

    public static void m6631(Object obj, boolean z) {
        if (C0448yd.m9074() <= 0) {
            m6602((C0354mn) obj, z);
        }
    }

    public static AbstractC0363mw m6632(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m6606((C0362mv) obj);
        }
        return null;
    }

    public static InterfaceC0411oq m6633(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m6570((C0362mv) obj);
        }
        return null;
    }

    public static int m6634(Object obj, int i) {
        if (m6574() >= 0) {
            return m6586((C0383np) obj, i);
        }
        return 0;
    }

    public static boolean m6635(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m6581((C0362mv) obj);
        }
        return false;
    }

    public static void m6636(Object obj) {
        if (abf.m2500() > 0) {
            m6599((C0377nj) obj);
        }
    }

    public static boolean m6637(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m6563((C0354mn) obj);
        }
        return false;
    }

    public static void m1149(Object obj, boolean z, int i, Object obj2, int i2) {
        if (gggy.m4365() >= 0) {
            m6579((C0377nj) obj, z, i, (C0409oo) obj2, i2);
        }
    }

    public static InterfaceC0381nn m6638(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m6593((C0362mv) obj);
        }
        return null;
    }

    public static ExecutorService m6639() {
        if (C0447yc.m8786() > 0) {
            return m6604();
        }
        return null;
    }

    public static void m6640(Object obj) {
        if (C0447yc.m8786() >= 0) {
            m6601((C0380nm) obj);
        }
    }

    public static String m6641(Object obj) {
        if (m6574() >= 0) {
            return m6596((C0362mv) obj);
        }
        return null;
    }

    public static boolean m6642() {
        if (abe.m2321() <= 0) {
            return m6605();
        }
        return false;
    }

    public static void m6643(Object obj, int i, Object obj2, Object obj3) {
        if (C0448yd.m9074() < 0) {
            m6569((C0377nj) obj, i, (EnumC0346mf) obj2, (byte[]) obj3);
        }
    }

    public static int m6644(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m6585((C0377nj) obj);
        }
        return 0;
    }

    public static void m6645(Object obj) {
        if (abd.m2166() < 0) {
            m6584((C0380nm) obj);
        }
    }

    public static Socket m6646(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m6582((C0362mv) obj);
        }
        return null;
    }

    public static void m6647(Object obj, Object obj2, Object obj3) {
        if (C0447yc.m8786() >= 0) {
            m6578((C0354mn) obj, (EnumC0346mf) obj2, (EnumC0346mf) obj3);
        }
    }

    public static C0365my m6648(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m6562((C0354mn) obj);
        }
        return null;
    }

    public static int m6649(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m6589((C0354mn) obj);
        }
        return 0;
    }

    public static void m6650(Object obj) {
        if (C0459zf.m11053() >= 0) {
            m6565((C0377nj) obj);
        }
    }

    public static C0373nf m6651(Object obj, int i, Object obj2, boolean z) {
        if (C0453yj.m10032() > 0) {
            return m6598((C0354mn) obj, i, (List) obj2, z);
        }
        return null;
    }

    public static C0383np m6652(Object obj, int i, int i2) {
        if (abf.m2500() > 0) {
            return m6572((C0383np) obj, i, i2);
        }
        return null;
    }

    public static C0383np m6653(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m6591((C0354mn) obj);
        }
        return null;
    }

    public static String m6654(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m6603((C0354mn) obj);
        }
        return null;
    }

    public static void m6655(Object obj, boolean z, int i, int i2) {
        if (C0456zb.m10484() <= 0) {
            m6561((C0377nj) obj, z, i, i2);
        }
    }

    public static void m6656(Object obj, int i, Object obj2) {
        if (C0453yj.m10032() > 0) {
            m6611((C0377nj) obj, i, (EnumC0346mf) obj2);
        }
    }

    public static void m6657(Object obj, int i, int i2, Object obj2) {
        if (C0456zb.m10484() <= 0) {
            m6583((C0377nj) obj, i, i2, (List) obj2);
        }
    }

    public static long m6658(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m6590((C0373nf) obj);
        }
        return 0L;
    }

    public static C0377nj m6659(Object obj) {
        if (abe.m2321() <= 0) {
            return m6594((C0354mn) obj);
        }
        return null;
    }

    void m1150a(int i, long j) {
        abd.m2125(C0458ze.m10835(), new C0356mp(this, C0455za.m10082(), new Object[]{C0450yf.m9391(this), abd.m2028(i)}, i, j));
    }

    void m1151a(int i, EnumC0346mf enumC0346mf) {
        abd.m2125(C0447yc.m8649(this), new C0361mu(this, C0453yj.m9983(), new Object[]{C0450yf.m9391(this), abd.m2028(i)}, i, enumC0346mf));
    }

    void m1152a(int i, InterfaceC0411oq interfaceC0411oq, int i2, boolean z) throws IOException {
        C0409oo c0409oo = new C0409oo();
        m6612(interfaceC0411oq, i2);
        C0458ze.m10843(interfaceC0411oq, c0409oo, i2);
        if (C0455za.m10042(c0409oo) != i2) {
            throw new IOException(abc.m1925(adds.m2680(C0460zg.m11407(C0458ze.m10777(new StringBuilder(), C0455za.m10042(c0409oo)), C0450yf.m9564()), i2)));
        }
        abd.m2125(C0447yc.m8649(this), new C0360mt(this, C0445ya.m8214(), new Object[]{C0450yf.m9391(this), abd.m2028(i)}, i, c0409oo, i2, z));
    }

    void m1153a(int i, List<C0347mg> list) {
        synchronized (this) {
            if (C0461zs.m11513(C0455za.m10091(this), abd.m2028(i))) {
                C0448yd.m8934(this, i, abf.m2596());
            } else {
                C0452yh.m9790(C0455za.m10091(this), abd.m2028(i));
                abd.m2125(C0447yc.m8649(this), new C0358mr(this, C0452yh.m9621(), new Object[]{C0450yf.m9391(this), abd.m2028(i)}, i, list));
            }
        }
    }

    public void m1154a(int r113, boolean r114, com.google.android.material.card2.C0409oo r115, long r116) {
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.material.card2.C0354mn.m1154a(int, boolean, com.google.android.material.card2.oo, long):void");
    }

    public void m1155a(EnumC0346mf enumC0346mf) {
        synchronized (m6568(this)) {
            synchronized (this) {
                if (abe.m2393(this)) {
                    return;
                }
                this.f1135so = true;
                C0453yj.m10027(m6568(this), C0447yc.m8743(this), enumC0346mf, C0446yb.m8601());
            }
        }
    }

    void m1156a(EnumC0346mf enumC0346mf, EnumC0346mf enumC0346mf2) throws IOException {
        IOException iOException;
        C0373nf[] c0373nfArr;
        C0380nm[] c0380nmArr;
        if (!abf.m2563() && C0455za.m10268(this)) {
            throw new AssertionError();
        }
        try {
            adds.m2886(this, enumC0346mf);
            iOException = null;
        } catch (IOException e) {
            iOException = e;
        }
        synchronized (this) {
            if (C0455za.m10254(abd.m2092(this))) {
                c0373nfArr = null;
            } else {
                C0373nf[] c0373nfArr2 = (C0373nf[]) C0460zg.m11360(C0457zc.m10625(abd.m2092(this)), new C0373nf[C0461zs.m11616(abd.m2092(this))]);
                m6592(abd.m2092(this));
                c0373nfArr = c0373nfArr2;
            }
            if (C0448yd.m8886(this) != null) {
                C0380nm[] c0380nmArr2 = (C0380nm[]) C0460zg.m11360(C0457zc.m10625(C0448yd.m8886(this)), new C0380nm[C0461zs.m11616(C0448yd.m8886(this))]);
                this.f1130sj = null;
                c0380nmArr = c0380nmArr2;
            } else {
                c0380nmArr = null;
            }
        }
        if (c0373nfArr != null) {
            IOException iOException2 = iOException;
            for (C0373nf c0373nf : c0373nfArr) {
                try {
                    m6613(c0373nf, enumC0346mf2);
                } catch (IOException e2) {
                    if (iOException2 != null) {
                        iOException2 = e2;
                    }
                }
            }
            iOException = iOException2;
        }
        if (c0380nmArr != null) {
            for (C0380nm c0380nm : c0380nmArr) {
                abf.m2417(c0380nm);
            }
        }
        try {
            C0453yj.m9825(m6568(this));
            e = iOException;
        } catch (IOException e3) {
            e = e3;
            if (iOException != null) {
                e = iOException;
            }
        }
        try {
            C0456zb.m10350(C0446yb.m8496(this));
        } catch (IOException e4) {
            e = e4;
        }
        if (e != null) {
            throw e;
        }
    }

    void m1157a(boolean z, int i, int i2, C0380nm c0380nm) {
        synchronized (m6568(this)) {
            if (c0380nm != null) {
                abf.m2583(c0380nm);
                C0448yd.m9072(m6568(this), z, i, i2);
            } else {
                C0448yd.m9072(m6568(this), z, i, i2);
            }
            throw th;
        }
    }

    public C0373nf m1158b(List<C0347mg> list, boolean z) {
        return abd.m2183(this, 0, list, z);
    }

    void m1159b(int i, EnumC0346mf enumC0346mf) {
        C0459zf.m11144(m6568(this), i, enumC0346mf);
    }

    void m1160b(int i, List<C0347mg> list, boolean z) {
        abd.m2125(C0447yc.m8649(this), new C0359ms(this, abd.m2023(), new Object[]{C0450yf.m9391(this), abd.m2028(i)}, i, list, z));
    }

    void m1161b(boolean z, int i, int i2, C0380nm c0380nm) {
        abd.m2125(C0458ze.m10835(), new C0357mq(this, C0445ya.m8345(), new Object[]{C0450yf.m9391(this), abd.m2028(i), abd.m2028(i2)}, z, i, i2, c0380nm));
    }

    void m1162c(int i, EnumC0346mf enumC0346mf) {
        abd.m2125(C0458ze.m10835(), new C0355mo(this, C0456zb.m10460(), new Object[]{C0450yf.m9391(this), abd.m2028(i)}, i, enumC0346mf));
    }

    @Override
    public void close() {
        C0455za.m10147(this, gggy.m4362(), C0456zb.m10363());
    }

    public int m1163eA() {
        int iM9003;
        synchronized (this) {
            iM9003 = C0448yd.m9003(C0449ye.m9195(this), Integer.MAX_VALUE);
        }
        return iM9003;
    }

    public void m1164eB() {
        C0458ze.m10918(this, true);
    }

    public boolean m1165ez() {
        boolean zM2393;
        synchronized (this) {
            zM2393 = abe.m2393(this);
        }
        return zM2393;
    }

    public void flush() {
        C0458ze.m10910(m6568(this));
    }

    void m1166g(long j) {
        this.f1120rZ = C0459zf.m11157(this) + j;
        if (j > 0) {
            abe.m2339(this);
        }
    }

    void m1167n(boolean z) {
        if (z) {
            C0452yh.m9641(m6568(this));
            C0461zs.m11473(m6568(this), C0456zb.m10276(this));
            int iM11568 = C0461zs.m11568(C0456zb.m10276(this));
            if (iM11568 != 65535) {
                C0449ye.m9141(m6568(this), 0, iM11568 - 65535);
            }
        }
        C0448yd.m8995(new Thread(m6607(this)));
    }

    C0373nf m1168t(int i) {
        C0373nf c0373nf;
        synchronized (this) {
            c0373nf = (C0373nf) adds.m2889(abd.m2092(this), abd.m2028(i));
        }
        return c0373nf;
    }

    boolean m1169u(int i) {
        return i != 0 && (i & 1) == 0;
    }

    C0380nm m1170v(int i) {
        C0380nm c0380nm;
        synchronized (this) {
            c0380nm = C0448yd.m8886(this) != null ? (C0380nm) abf.m2577(C0448yd.m8886(this), abd.m2028(i)) : null;
        }
        return c0380nm;
    }

    C0373nf m1171w(int i) {
        C0373nf c0373nf;
        synchronized (this) {
            c0373nf = (C0373nf) abf.m2577(abd.m2092(this), abd.m2028(i));
            abe.m2339(this);
        }
        return c0373nf;
    }
}
