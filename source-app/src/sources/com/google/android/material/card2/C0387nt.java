package com.google.android.material.card2;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.security.cert.X509Certificate;
import java.util.List;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.X509TrustManager;

class C0387nt extends C0396ob {

    private final C0390nw f1240uc = m7421();

    private final C0395oa<Socket> f1241ud;

    private final C0395oa<Socket> f1242ue;

    private final C0395oa<Socket> f1243uf;

    private final C0395oa<Socket> f1244ug;

    private final Class<?> f1245uh;

    C0387nt(Class<?> cls, C0395oa<Socket> c0395oa, C0395oa<Socket> c0395oa2, C0395oa<Socket> c0395oa3, C0395oa<Socket> c0395oa4) {
        this.f1245uh = cls;
        this.f1244ug = c0395oa;
        this.f1243uf = c0395oa2;
        this.f1241ud = c0395oa3;
        this.f1242ue = c0395oa4;
    }

    private boolean m1271a(String str, Class<?> cls, Object obj) {
        try {
            return C0453yj.m10033((Boolean) C0446yb.m8446(C0461zs.m11528(cls, C0455za.m10133(), new Class[0]), obj, new Object[0]));
        } catch (NoSuchMethodException e) {
            return super.mo1281ai(str);
        }
    }

    private boolean m1272b(String str, Class<?> cls, Object obj) {
        try {
            return C0453yj.m10033((Boolean) C0446yb.m8446(C0461zs.m11528(cls, C0455za.m10133(), new Class[]{String.class}), obj, new Object[]{str}));
        } catch (NoSuchMethodException e) {
            return m7448(this, str, cls, obj);
        }
    }

    public static C0396ob m1273fc() {
        Class clsM9289;
        C0395oa c0395oa;
        C0395oa c0395oa2;
        try {
            try {
                clsM9289 = C0449ye.m9289(C0453yj.m10029());
            } catch (ClassNotFoundException e) {
                clsM9289 = C0449ye.m9289(C0460zg.m11307());
            }
            C0395oa c0395oa3 = new C0395oa(null, abd.m2060(), C0448yd.m9025());
            C0395oa c0395oa4 = new C0395oa(null, C0452yh.m9615(), String.class);
            if (m7455()) {
                c0395oa2 = new C0395oa(byte[].class, abe.m2330(), new Class[0]);
                c0395oa = new C0395oa(null, abe.m2248(), byte[].class);
            } else {
                c0395oa = null;
                c0395oa2 = null;
            }
            return new C0387nt(clsM9289, c0395oa3, c0395oa4, c0395oa2, c0395oa);
        } catch (ClassNotFoundException e2) {
            return null;
        }
    }

    private static boolean m1274fd() {
        if (C0449ye.m9239(C0459zf.m11013()) != null) {
            return true;
        }
        try {
            C0449ye.m9289(m7438());
            return true;
        } catch (ClassNotFoundException e) {
            return false;
        }
    }

    public static C0390nw m7421() {
        if (gggy.m4269() < 0) {
            return m7468();
        }
        return null;
    }

    public static boolean m7422(Object obj, Object obj2) {
        if (C0460zg.m11287() > 0) {
            return ((C0395oa) obj).m1300l(obj2);
        }
        return false;
    }

    public static C0390nw m7423(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return m7461(obj);
        }
        return null;
    }

    public static C0395oa m7424(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0387nt) obj).f1242ue;
        }
        return null;
    }

    public static boolean m7425(Object obj, Object obj2, Object obj3, Object obj4) {
        if (gggy.m4269() < 0) {
            return ((C0387nt) obj).m1271a((String) obj2, (Class<?>) obj3, obj4);
        }
        return false;
    }

    public static boolean m7426(Object obj, Object obj2) {
        if (C0457zc.m10735() < 0) {
            return m7463(obj, obj2);
        }
        return false;
    }

    public static Object m7427(Object obj, Object obj2) {
        if (gggy.m4269() < 0) {
            return ((C0390nw) obj).m1288aj((String) obj2);
        }
        return null;
    }

    public static boolean m7428() {
        if (gggy.m4269() <= 0) {
            return m1274fd();
        }
        return false;
    }

    public static C0395oa m7429(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0387nt) obj).f1243uf;
        }
        return null;
    }

    public static Object m7430(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m10013() >= 0) {
            return m7466(obj, obj2, obj3);
        }
        return null;
    }

    public static boolean m7431(Object obj, Object obj2) {
        if (adds.m2755() >= 0) {
            return ((C0390nw) obj).m1289k(obj2);
        }
        return false;
    }

    public static Object m7432(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10735() <= 0) {
            return m7459(obj, obj2, obj3);
        }
        return null;
    }

    public static C0390nw m7433(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0387nt) obj).f1240uc;
        }
        return null;
    }

    public static C0390nw m7434() {
        if (gggy.m4269() < 0) {
            return C0390nw.m1287fe();
        }
        return null;
    }

    public static int m7435() {
        if (abc.m1845() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static void m7436(Object obj, int i, Object obj2, Object obj3) {
        if (C0459zf.m11062() >= 0) {
            ((C0387nt) obj).mo1276a(i, (String) obj2, (Throwable) obj3);
        }
    }

    public static Method m7437(Object obj, Object obj2, Object obj3) {
        if (C0452yh.m9798() > 0) {
            return C0598.m11845(obj, obj2, obj3);
        }
        return null;
    }

    public static String m7438() {
        if (C0448yd.m9079() <= 0) {
            return C0598.m11808();
        }
        return null;
    }

    public static boolean m7439(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0450yf.m9352() < 0) {
            return ((C0387nt) obj).m1272b((String) obj2, (Class) obj3, obj4);
        }
        return false;
    }

    public static boolean m7440(Object obj, Object obj2) {
        if (abd.m2162() >= 0) {
            return m7467(obj, obj2);
        }
        return false;
    }

    public static C0395oa m7441(Object obj) {
        if (abf.m2510() < 0) {
            return m7462(obj);
        }
        return null;
    }

    public static C0395oa m7442(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0387nt) obj).f1241ud;
        }
        return null;
    }

    public static byte[] m7443(Object obj) {
        if (abf.m2510() <= 0) {
            return m1304g((List) obj);
        }
        return null;
    }

    public static boolean m7444(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0453yj.m10013() > 0) {
            return m7456(obj, obj2, obj3, obj4);
        }
        return false;
    }

    public static Object m7445(Object obj, Object obj2) {
        if (C0458ze.m10932() > 0) {
            return m7464(obj, obj2);
        }
        return null;
    }

    public static void m7446(Object obj, int i, Object obj2, Object obj3) {
        if (C0457zc.m10735() <= 0) {
            m7469(obj, i, obj2, obj3);
        }
    }

    public static Object m7447(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10735() <= 0) {
            return ((C0395oa) obj).m1299d(obj2, (Object[]) obj3);
        }
        return null;
    }

    public static boolean m7448(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0461zs.m11510() <= 0) {
            return m7458(obj, obj2, obj3, obj4);
        }
        return false;
    }

    public static C0395oa m7449(Object obj) {
        if (abd.m2162() >= 0) {
            return m7460(obj);
        }
        return null;
    }

    public static C0395oa m7450(Object obj) {
        if (abe.m2308() < 0) {
            return m7457(obj);
        }
        return null;
    }

    public static byte[] m7451(Object obj) {
        if (C0451yg.m9580() > 0) {
            return m7470(obj);
        }
        return null;
    }

    public static C0395oa m7452(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0387nt) obj).f1244ug;
        }
        return null;
    }

    public static C0395oa m7453(Object obj) {
        if (abd.m2162() > 0) {
            return m7465(obj);
        }
        return null;
    }

    public static Object m7454(Object obj, Object obj2, Object obj3) {
        if (abe.m2308() <= 0) {
            return ((C0395oa) obj).m1298c(obj2, (Object[]) obj3);
        }
        return null;
    }

    public static boolean m7455() {
        if (C0461zs.m11510() < 0) {
            return m1275();
        }
        return false;
    }

    public static boolean m7456(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0460zg.m11293() >= 0) {
            return m7439((C0387nt) obj, (String) obj2, (Class) obj3, obj4);
        }
        return false;
    }

    public static C0395oa m7457(Object obj) {
        if (abd.m2021() >= 0) {
            return m7452((C0387nt) obj);
        }
        return null;
    }

    public static boolean m7458(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0448yd.m9015() < 0) {
            return m7425((C0387nt) obj, (String) obj2, (Class) obj3, obj4);
        }
        return false;
    }

    public static Object m7459(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9074() <= 0) {
            return m7454((C0395oa) obj, obj2, (Object[]) obj3);
        }
        return null;
    }

    public static boolean m1275() {
        if (C0459zf.m11053() >= 0) {
            return m7428();
        }
        return false;
    }

    public static C0395oa m7460(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m7442((C0387nt) obj);
        }
        return null;
    }

    public static C0390nw m7461(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m7433((C0387nt) obj);
        }
        return null;
    }

    public static C0395oa m7462(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m7424((C0387nt) obj);
        }
        return null;
    }

    public static boolean m7463(Object obj, Object obj2) {
        if (abf.m2500() >= 0) {
            return m7431((C0390nw) obj, obj2);
        }
        return false;
    }

    public static Object m7464(Object obj, Object obj2) {
        if (C0453yj.m9945() <= 0) {
            return m7427((C0390nw) obj, (String) obj2);
        }
        return null;
    }

    public static C0395oa m7465(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m7429((C0387nt) obj);
        }
        return null;
    }

    public static Object m7466(Object obj, Object obj2, Object obj3) {
        if (abe.m2321() <= 0) {
            return m7447((C0395oa) obj, obj2, (Object[]) obj3);
        }
        return null;
    }

    public static boolean m7467(Object obj, Object obj2) {
        if (abd.m2166() <= 0) {
            return m7422((C0395oa) obj, obj2);
        }
        return false;
    }

    public static C0390nw m7468() {
        if (C0453yj.m9966() >= 0) {
            return m7434();
        }
        return null;
    }

    public static void m7469(Object obj, int i, Object obj2, Object obj3) {
        if (C0445ya.m8330() >= 0) {
            m7436((C0387nt) obj, i, (String) obj2, (Throwable) obj3);
        }
    }

    public static byte[] m7470(Object obj) {
        if (m7435() > 0) {
            return m7443((List) obj);
        }
        return null;
    }

    @Override
    public void mo1276a(int i, String str, Throwable th) {
        int iM10520;
        String strM1925 = str;
        int i2 = i == 5 ? 5 : 3;
        if (th != null) {
            strM1925 = abc.m1925(C0460zg.m11407(abe.m2346(C0460zg.m11407(new StringBuilder(), strM1925), '\n'), C0458ze.m10812(th)));
        }
        int i3 = 0;
        int iM4397 = gggy.m4397(strM1925);
        while (i3 < iM4397) {
            int iM10546 = C0457zc.m10546(strM1925, 10, i3);
            if (iM10546 == -1) {
                iM10546 = iM4397;
            }
            while (true) {
                iM10520 = C0456zb.m10520(iM10546, i3 + 4000);
                abd.m2150(i2, C0455za.m10057(), C0447yc.m8745(strM1925, i3, iM10520));
                if (iM10520 >= iM10546) {
                    break;
                } else {
                    i3 = iM10520;
                }
            }
            i3 = iM10520 + 1;
        }
    }

    @Override
    public void mo1277a(String str, Object obj) {
        if (m7426(m7423(this), obj)) {
            return;
        }
        m7446(this, 5, str, null);
    }

    @Override
    public void mo1278a(Socket socket, InetSocketAddress inetSocketAddress, int i) throws IOException {
        try {
            C0452yh.m9737(socket, inetSocketAddress, i);
        } catch (AssertionError e) {
            if (!C0456zb.m10287(e)) {
                throw e;
            }
            throw new IOException(e);
        } catch (ClassCastException e2) {
            if (abd.m2050() != 26) {
                throw e2;
            }
            IOException iOException = new IOException(C0445ya.m8262());
            abc.m1866(iOException, e2);
            throw iOException;
        } catch (SecurityException e3) {
            IOException iOException2 = new IOException(C0445ya.m8262());
            abc.m1866(iOException2, e3);
            throw iOException2;
        }
    }

    @Override
    public void mo1279a(SSLSocket sSLSocket, String str, List<EnumC0282jx> list) {
        if (str != null) {
            m7432(m7450(this), sSLSocket, new Object[]{C0450yf.m9568(true)});
            m7432(m7453(this), sSLSocket, new Object[]{str});
        }
        if (m7441(this) == null || !m7440(m7441(this), sSLSocket)) {
            return;
        }
        m7430(m7441(this), sSLSocket, new Object[]{m7451(list)});
    }

    @Override
    public Object mo1280ah(String str) {
        return m7445(m7423(this), str);
    }

    @Override
    public boolean mo1281ai(String str) {
        try {
            Class clsM9289 = C0449ye.m9289(gggy.m4285());
            return m7444(this, str, clsM9289, C0446yb.m8446(C0461zs.m11528(clsM9289, abc.m1897(), new Class[0]), null, new Object[0]));
        } catch (ClassNotFoundException e) {
            return super.mo1281ai(str);
        } catch (IllegalAccessException e2) {
            e = e2;
            throw C0445ya.m8385(C0456zb.m10317(), e);
        } catch (IllegalArgumentException e3) {
            e = e3;
            throw C0445ya.m8385(C0456zb.m10317(), e);
        } catch (NoSuchMethodException e4) {
            return super.mo1281ai(str);
        } catch (InvocationTargetException e5) {
            e = e5;
            throw C0445ya.m8385(C0456zb.m10317(), e);
        }
    }

    @Override
    public AbstractC0400of mo1282b(X509TrustManager x509TrustManager) {
        try {
            Class clsM9289 = C0449ye.m9289(abd.m2046());
            return new C0388nu(C0461zs.m11478(gggy.m4382(clsM9289, new Class[]{X509TrustManager.class}), new Object[]{x509TrustManager}), C0461zs.m11528(clsM9289, abd.m2196(), new Class[]{X509Certificate[].class, String.class, String.class}));
        } catch (Exception e) {
            return super.mo1282b(x509TrustManager);
        }
    }

    @Override
    public InterfaceC0403oi mo1283c(X509TrustManager x509TrustManager) {
        try {
            Method methodM7437 = m7437(gggy.m4399(x509TrustManager), abf.m2531(), new Class[]{X509Certificate.class});
            C0455za.m10162(methodM7437, true);
            return new C0389nv(x509TrustManager, methodM7437);
        } catch (NoSuchMethodException e) {
            return super.mo1283c(x509TrustManager);
        }
    }

    @Override
    public String mo1284d(SSLSocket sSLSocket) {
        byte[] bArr;
        if (m7449(this) == null) {
            return null;
        }
        if (!m7440(m7449(this), sSLSocket) || (bArr = (byte[]) m7430(m7449(this), sSLSocket, new Object[0])) == null) {
            return null;
        }
        return new String(bArr, abc.m1850());
    }
}
