package com.google.android.material.card2;

import java.io.IOException;
import java.lang.ref.Reference;
import java.net.Socket;
import java.util.List;

public final class C0319lg {

    static final boolean f985pM;

    public final C0239ih f986pN;

    public final InterfaceC0245in f987pO;

    private final Object f988pP;

    private boolean f989pQ;

    private InterfaceC0324ll f990pR;

    private C0314lb f991pS;

    private final C0253iv f992pT;

    public final AbstractC0264jf f993pU;

    private int f994pV;

    private boolean f995pW;

    private boolean f996pX;

    private C0318lf f997pY;

    private final C0317le f998pZ;

    private C0294ki f999pu;

    static {
        f985pM = !C0460zg.m11342(C0319lg.class);
    }

    public C0319lg(C0253iv c0253iv, C0239ih c0239ih, InterfaceC0245in interfaceC0245in, AbstractC0264jf abstractC0264jf, Object obj) {
        this.f992pT = c0253iv;
        this.f986pN = c0239ih;
        this.f987pO = interfaceC0245in;
        this.f993pU = abstractC0264jf;
        this.f998pZ = new C0317le(c0239ih, C0461zs.m11566(this), interfaceC0245in, abstractC0264jf);
        this.f988pP = obj;
    }

    private C0314lb m1028a(int i, int i2, int i3, boolean z) throws Throwable {
        Socket socketM8353;
        C0314lb c0314lb;
        C0314lb c0314lbM9154;
        C0314lb c0314lbM9155;
        C0294ki c0294kiM2083;
        boolean z2 = false;
        C0314lb c0314lbM9156 = null;
        C0294ki c0294kiM2809 = null;
        synchronized (abd.m2121(this)) {
            if (C0456zb.m10495(this)) {
                throw new IllegalStateException(C0458ze.m10798());
            }
            if (C0449ye.m9249(this) != null) {
                throw new IllegalStateException(C0445ya.m8270());
            }
            if (C0455za.m10257(this)) {
                throw new IOException(C0453yj.m9968());
            }
            C0314lb c0314lbM9157 = C0449ye.m9154(this);
            socketM8353 = C0445ya.m8353(this);
            if (C0449ye.m9154(this) != null) {
                c0314lbM9156 = C0449ye.m9154(this);
                c0314lbM9157 = null;
            }
            c0314lb = !C0461zs.m11489(this) ? null : c0314lbM9157;
            if (c0314lbM9156 == null) {
                C0459zf.m11131(adds.m2768(), abd.m2121(this), C0446yb.m8453(this), this, null);
                if (C0449ye.m9154(this) != null) {
                    z2 = true;
                    c0314lbM9154 = C0449ye.m9154(this);
                } else {
                    c0294kiM2809 = adds.m2809(this);
                    c0314lbM9154 = c0314lbM9156;
                }
            } else {
                c0314lbM9154 = c0314lbM9156;
            }
        }
        C0455za.m10140(socketM8353);
        if (c0314lb != null) {
            C0450yf.m9442(C0460zg.m11398(this), gggy.m4297(this), c0314lb);
        }
        if (z2) {
            adds.m2684(C0460zg.m11398(this), gggy.m4297(this), c0314lbM9154);
        }
        if (c0314lbM9154 != null) {
            return c0314lbM9154;
        }
        boolean z3 = false;
        if (c0294kiM2809 == null && (C0450yf.m9471(this) == null || !C0457zc.m10751(C0450yf.m9471(this)))) {
            z3 = true;
            this.f997pY = C0446yb.m8495(C0459zf.m11005(this));
        }
        synchronized (abd.m2121(this)) {
            try {
                if (C0455za.m10257(this)) {
                    throw new IOException(C0453yj.m9968());
                }
                if (!z3) {
                    c0314lbM9155 = c0314lbM9154;
                    break;
                }
                List listM8251 = C0445ya.m8251(C0450yf.m9471(this));
                int iM6053 = m6053(listM8251);
                int i4 = 0;
                while (true) {
                    if (i4 >= iM6053) {
                        c0314lbM9155 = c0314lbM9154;
                        break;
                    }
                    C0294ki c0294ki = (C0294ki) gggy.m4400(listM8251, i4);
                    C0459zf.m11131(adds.m2768(), abd.m2121(this), C0446yb.m8453(this), this, c0294ki);
                    if (C0449ye.m9154(this) != null) {
                        z2 = true;
                        C0314lb c0314lbM9158 = C0449ye.m9154(this);
                        this.f999pu = c0294ki;
                        c0314lbM9155 = c0314lbM9158;
                        break;
                    }
                    i4++;
                }
                if (!z2) {
                    if (c0294kiM2809 == null) {
                        try {
                            c0294kiM2083 = abd.m2083(C0450yf.m9471(this));
                        } catch (Throwable th) {
                            th = th;
                            throw th;
                        }
                    } else {
                        c0294kiM2083 = c0294kiM2809;
                    }
                    this.f999pu = c0294kiM2083;
                    this.f994pV = 0;
                    c0314lbM9155 = new C0314lb(abd.m2121(this), c0294kiM2083);
                    adds.m2856(this, c0314lbM9155, false);
                }
                if (z2) {
                    adds.m2684(C0460zg.m11398(this), gggy.m4297(this), c0314lbM9155);
                    return c0314lbM9155;
                }
                C0459zf.m10983(c0314lbM9155, i, i2, i3, z, gggy.m4297(this), C0460zg.m11398(this));
                C0447yc.m8621(C0461zs.m11566(this), C0452yh.m9728(c0314lbM9155));
                Socket socketM2210 = null;
                synchronized (abd.m2121(this)) {
                    this.f996pX = true;
                    C0455za.m10195(adds.m2768(), abd.m2121(this), c0314lbM9155);
                    if (C0459zf.m11096(c0314lbM9155)) {
                        socketM2210 = abe.m2210(adds.m2768(), abd.m2121(this), C0446yb.m8453(this), this);
                        c0314lbM9155 = C0449ye.m9154(this);
                    }
                }
                C0455za.m10140(socketM2210);
                adds.m2684(C0460zg.m11398(this), gggy.m4297(this), c0314lbM9155);
                return c0314lbM9155;
            } catch (Throwable th2) {
                th = th2;
            }
        }
    }

    private C0314lb m1029a(int i, int i2, int i3, boolean z, boolean z2) {
        C0314lb c0314lbM11188;
        while (true) {
            c0314lbM11188 = C0459zf.m11188(this, i, i2, i3, z);
            synchronized (abd.m2121(this)) {
                if (C0450yf.m9525(c0314lbM11188) != 0) {
                    if (gggy.m4337(c0314lbM11188, z2)) {
                        break;
                    }
                    C0461zs.m11544(this);
                } else {
                    break;
                }
            }
        }
        return c0314lbM11188;
    }

    private Socket m1030a(boolean z, boolean z2, boolean z3) {
        Socket socketM10803;
        if (!C0455za.m10093() && !C0455za.m10268(abd.m2121(this))) {
            throw new AssertionError();
        }
        if (z3) {
            this.f990pR = null;
        }
        if (z2) {
            this.f995pW = true;
        }
        if (C0449ye.m9154(this) == null) {
            return null;
        }
        if (z) {
            C0449ye.m9154(this).f965ps = true;
        }
        if (C0449ye.m9249(this) != null) {
            return null;
        }
        if (!C0456zb.m10495(this) && !C0445ya.m8282(C0449ye.m9154(this))) {
            return null;
        }
        C0447yc.m8759(this, C0449ye.m9154(this));
        if (C0452yh.m9618(C0457zc.m10705(C0449ye.m9154(this)))) {
            C0449ye.m9154(this).f964pr = abc.m1830();
            if (m6060(adds.m2768(), abd.m2121(this), C0449ye.m9154(this))) {
                socketM10803 = C0458ze.m10803(C0449ye.m9154(this));
            } else {
                socketM10803 = null;
            }
        } else {
            socketM10803 = null;
        }
        this.f991pS = null;
        return socketM10803;
    }

    private void m1031c(C0314lb c0314lb) {
        int iM6053 = m6053(C0457zc.m10705(c0314lb));
        for (int i = 0; i < iM6053; i++) {
            if (gggy.m4348((Reference) gggy.m4400(C0457zc.m10705(c0314lb), i)) == this) {
                abc.m1794(C0457zc.m10705(c0314lb), i);
                return;
            }
        }
        throw new IllegalStateException();
    }

    private Socket m1032dW() {
        if (!C0455za.m10093() && !C0455za.m10268(abd.m2121(this))) {
            throw new AssertionError();
        }
        C0314lb c0314lbM9154 = C0449ye.m9154(this);
        if (c0314lbM9154 == null || !C0445ya.m8282(c0314lbM9154)) {
            return null;
        }
        return C0447yc.m8835(this, false, false, true);
    }

    private C0315lc m1033dX() {
        return C0457zc.m10581(adds.m2768(), abd.m2121(this));
    }

    public static boolean m6051() {
        if (abc.m1845() < 0) {
            return f985pM;
        }
        return false;
    }

    public static C0314lb m6052(Object obj, int i, int i2, int i3, boolean z) {
        if (C0457zc.m10735() < 0) {
            return ((C0319lg) obj).m1028a(i, i2, i3, z);
        }
        return null;
    }

    public static int m6053(Object obj) {
        if (abc.m1845() <= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static Socket m6054(Object obj, boolean z, boolean z2, boolean z3) {
        if (C0456zb.m10326() <= 0) {
            return ((C0319lg) obj).m1030a(z, z2, z3);
        }
        return null;
    }

    public static boolean m6055(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0319lg) obj).f989pQ;
        }
        return false;
    }

    public static C0253iv m6056(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0319lg) obj).f992pT;
        }
        return null;
    }

    public static void m6057(Object obj, Object obj2) {
        if (C0459zf.m11062() >= 0) {
            ((C0319lg) obj).m1031c((C0314lb) obj2);
        }
    }

    public static C0318lf m6058(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0319lg) obj).f997pY;
        }
        return null;
    }

    public static boolean m6059(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0319lg) obj).f996pX;
        }
        return false;
    }

    public static boolean m6060(Object obj, Object obj2, Object obj3) {
        if (C0459zf.m11062() >= 0) {
            return C0598.m11843(obj, obj2, obj3);
        }
        return false;
    }

    public static Object m6061(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0319lg) obj).f988pP;
        }
        return null;
    }

    public static InterfaceC0324ll m6062(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0319lg) obj).f990pR;
        }
        return null;
    }

    public static C0317le m6063(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0319lg) obj).f998pZ;
        }
        return null;
    }

    public static C0314lb m6064(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0319lg) obj).f991pS;
        }
        return null;
    }

    public static Socket m6065(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0319lg) obj).m1032dW();
        }
        return null;
    }

    public static String m6066(Object obj) {
        if (C0448yd.m9079() < 0) {
            return C0598.m11905(obj);
        }
        return null;
    }

    public static C0314lb m6067(Object obj, int i, int i2, int i3, boolean z, boolean z2) {
        if (C0460zg.m11287() >= 0) {
            return ((C0319lg) obj).m1029a(i, i2, i3, z, z2);
        }
        return null;
    }

    public static boolean m6068(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0319lg) obj).f995pW;
        }
        return false;
    }

    public static int m6069(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0319lg) obj).f994pV;
        }
        return 0;
    }

    public static C0315lc m6070(Object obj) {
        if (C0458ze.m10932() > 0) {
            return ((C0319lg) obj).m1033dX();
        }
        return null;
    }

    public static C0294ki m6071(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0319lg) obj).f999pu;
        }
        return null;
    }

    public static int m6072(Object obj) {
        if (abe.m2308() <= 0) {
            return C0598.m11906(obj);
        }
        return 0;
    }

    public static Object m6073(Object obj) {
        if (abd.m2021() >= 0) {
            return m6061((C0319lg) obj);
        }
        return null;
    }

    public static C0314lb m6074(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m6064((C0319lg) obj);
        }
        return null;
    }

    public static void m6075(Object obj, Object obj2) {
        if (abf.m2500() > 0) {
            m6057((C0319lg) obj, (C0314lb) obj2);
        }
    }

    public static C0294ki m6076(Object obj) {
        if (gggy.m4365() >= 0) {
            return m6071((C0319lg) obj);
        }
        return null;
    }

    public static boolean m6077(Object obj) {
        if (abe.m2321() <= 0) {
            return m6059((C0319lg) obj);
        }
        return false;
    }

    public static Socket m6078(Object obj, boolean z, boolean z2, boolean z3) {
        if (C0448yd.m9015() < 0) {
            return m6054((C0319lg) obj, z, z2, z3);
        }
        return null;
    }

    public static boolean m6079() {
        if (C0447yc.m8786() > 0) {
            return m6051();
        }
        return false;
    }

    public static C0253iv m6080(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m6056((C0319lg) obj);
        }
        return null;
    }

    public static int m6081(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m6069((C0319lg) obj);
        }
        return 0;
    }

    public static boolean m6082(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m6068((C0319lg) obj);
        }
        return false;
    }

    public static C0317le m6083(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m6063((C0319lg) obj);
        }
        return null;
    }

    public static C0318lf m6084(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m6058((C0319lg) obj);
        }
        return null;
    }

    public static C0315lc m6085(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m6070((C0319lg) obj);
        }
        return null;
    }

    public static Socket m6086(Object obj) {
        if (abe.m2321() < 0) {
            return m6065((C0319lg) obj);
        }
        return null;
    }

    public static C0314lb m6087(Object obj, int i, int i2, int i3, boolean z, boolean z2) {
        if (C0453yj.m10032() >= 0) {
            return m6067((C0319lg) obj, i, i2, i3, z, z2);
        }
        return null;
    }

    public static InterfaceC0324ll m6088(Object obj) {
        if (abf.m2500() >= 0) {
            return m6062((C0319lg) obj);
        }
        return null;
    }

    public static C0314lb m6089(Object obj, int i, int i2, int i3, boolean z) {
        if (C0453yj.m10032() > 0) {
            return m6052((C0319lg) obj, i, i2, i3, z);
        }
        return null;
    }

    public static boolean m6090(Object obj) {
        if (gggy.m4365() >= 0) {
            return m6055((C0319lg) obj);
        }
        return false;
    }

    public InterfaceC0324ll m1034a(C0279ju c0279ju, InterfaceC0277js interfaceC0277js, boolean z) {
        try {
            InterfaceC0324ll interfaceC0324llM9363 = C0450yf.m9363(C0453yj.m9839(this, C0460zg.m11370(interfaceC0277js), m6072(interfaceC0277js), C0460zg.m11245(interfaceC0277js), C0447yc.m8796(c0279ju), z), c0279ju, interfaceC0277js, this);
            synchronized (abd.m2121(this)) {
                this.f990pR = interfaceC0324llM9363;
            }
            return interfaceC0324llM9363;
        } catch (IOException e) {
            throw new C0316ld(e);
        }
    }

    public void m1035a(C0314lb c0314lb, boolean z) {
        if (!C0455za.m10093() && !C0455za.m10268(abd.m2121(this))) {
            throw new AssertionError();
        }
        if (C0449ye.m9154(this) != null) {
            throw new IllegalStateException();
        }
        this.f991pS = c0314lb;
        this.f996pX = z;
        C0460zg.m11251(C0457zc.m10705(c0314lb), new C0320lh(this, abe.m2215(this)));
    }

    public void m1036a(boolean z, InterfaceC0324ll interfaceC0324ll, long j, IOException iOException) {
        C0314lb c0314lbM9154;
        Socket socketM8835;
        boolean zM10495;
        C0449ye.m9318(C0460zg.m11398(this), gggy.m4297(this), j);
        synchronized (abd.m2121(this)) {
            if (interfaceC0324ll != null) {
                if (interfaceC0324ll == C0449ye.m9249(this)) {
                    if (!z) {
                        C0314lb c0314lbM9155 = C0449ye.m9154(this);
                        c0314lbM9155.f971py = C0450yf.m9525(c0314lbM9155) + 1;
                    }
                    c0314lbM9154 = C0449ye.m9154(this);
                    socketM8835 = C0447yc.m8835(this, z, false, true);
                    if (C0449ye.m9154(this) != null) {
                        c0314lbM9154 = null;
                    }
                    zM10495 = C0456zb.m10495(this);
                }
            }
            throw new IllegalStateException(abc.m1925(abd.m2090(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), abd.m2027()), C0449ye.m9249(this)), C0458ze.m10957()), interfaceC0324ll)));
        }
        C0455za.m10140(socketM8835);
        if (c0314lbM9154 != null) {
            C0450yf.m9442(C0460zg.m11398(this), gggy.m4297(this), c0314lbM9154);
        }
        if (iOException != null) {
            C0446yb.m8439(C0460zg.m11398(this), gggy.m4297(this), iOException);
        } else if (zM10495) {
            C0447yc.m8698(C0460zg.m11398(this), gggy.m4297(this));
        }
    }

    public void m1037c(IOException iOException) {
        Socket socketM8835;
        C0314lb c0314lb;
        boolean z = false;
        synchronized (abd.m2121(this)) {
            if (iOException instanceof C0384nq) {
                C0384nq c0384nq = (C0384nq) iOException;
                if (C0461zs.m11462(c0384nq) == adds.m2844()) {
                    this.f994pV = C0445ya.m8284(this) + 1;
                }
                if (C0461zs.m11462(c0384nq) != adds.m2844() || C0445ya.m8284(this) > 1) {
                    this.f999pu = null;
                    z = true;
                }
            } else if (C0449ye.m9154(this) != null && (!C0459zf.m11096(C0449ye.m9154(this)) || (iOException instanceof C0345me))) {
                if (C0450yf.m9525(C0449ye.m9154(this)) == 0) {
                    if (adds.m2809(this) != null && iOException != null) {
                        C0449ye.m9191(C0459zf.m11005(this), adds.m2809(this), iOException);
                    }
                    this.f999pu = null;
                    z = true;
                } else {
                    z = true;
                }
            }
            C0314lb c0314lbM9154 = C0449ye.m9154(this);
            socketM8835 = C0447yc.m8835(this, z, false, true);
            c0314lb = (C0449ye.m9154(this) == null && C0461zs.m11489(this)) ? c0314lbM9154 : null;
        }
        C0455za.m10140(socketM8835);
        if (c0314lb != null) {
            C0450yf.m9442(C0460zg.m11398(this), gggy.m4297(this), c0314lb);
        }
    }

    public Socket m1038d(C0314lb c0314lb) {
        if (!C0455za.m10093() && !C0455za.m10268(abd.m2121(this))) {
            throw new AssertionError();
        }
        if (C0449ye.m9249(this) != null || m6053(C0457zc.m10705(C0449ye.m9154(this))) != 1) {
            throw new IllegalStateException();
        }
        Reference reference = (Reference) gggy.m4400(C0457zc.m10705(C0449ye.m9154(this)), 0);
        Socket socketM8835 = C0447yc.m8835(this, true, false, false);
        this.f991pS = c0314lb;
        C0460zg.m11251(C0457zc.m10705(c0314lb), reference);
        return socketM8835;
    }

    public InterfaceC0324ll m1039dY() {
        InterfaceC0324ll interfaceC0324llM9249;
        synchronized (abd.m2121(this)) {
            interfaceC0324llM9249 = C0449ye.m9249(this);
        }
        return interfaceC0324llM9249;
    }

    public C0314lb m1040dZ() {
        C0314lb c0314lbM9154;
        synchronized (this) {
            c0314lbM9154 = C0449ye.m9154(this);
        }
        return c0314lbM9154;
    }

    public boolean m1041ea() {
        return adds.m2809(this) != null || (C0450yf.m9471(this) != null && C0457zc.m10751(C0450yf.m9471(this))) || C0449ye.m9210(C0459zf.m11005(this));
    }

    public void m1042eb() {
        C0314lb c0314lbM9154;
        Socket socketM8835;
        synchronized (abd.m2121(this)) {
            c0314lbM9154 = C0449ye.m9154(this);
            socketM8835 = C0447yc.m8835(this, true, false, false);
            if (C0449ye.m9154(this) != null) {
                c0314lbM9154 = null;
            }
        }
        C0455za.m10140(socketM8835);
        if (c0314lbM9154 != null) {
            C0450yf.m9442(C0460zg.m11398(this), gggy.m4297(this), c0314lbM9154);
        }
    }

    public void m1043ec() {
        C0314lb c0314lbM9154;
        Socket socketM8835;
        synchronized (abd.m2121(this)) {
            c0314lbM9154 = C0449ye.m9154(this);
            socketM8835 = C0447yc.m8835(this, false, true, false);
            if (C0449ye.m9154(this) != null) {
                c0314lbM9154 = null;
            }
        }
        C0455za.m10140(socketM8835);
        if (c0314lbM9154 != null) {
            C0450yf.m9442(C0460zg.m11398(this), gggy.m4297(this), c0314lbM9154);
        }
    }

    public String toString() {
        C0314lb c0314lbM9803 = C0452yh.m9803(this);
        return c0314lbM9803 != null ? C0446yb.m8567(c0314lbM9803) : m6066(C0446yb.m8453(this));
    }
}
