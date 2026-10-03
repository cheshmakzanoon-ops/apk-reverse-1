package com.google.android.material.card2;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.util.logging.Logger;

public final class C0418ox {

    static final Logger f1319vx = C0460zg.m11225(C0456zb.m10455(C0418ox.class));

    private C0418ox() {
    }

    private static InterfaceC0428pg m1437a(OutputStream outputStream, C0430pi c0430pi) {
        if (outputStream == null) {
            throw new IllegalArgumentException(C0456zb.m10307());
        }
        if (c0430pi == null) {
            throw new IllegalArgumentException(C0445ya.m8268());
        }
        return new C0419oy(c0430pi, outputStream);
    }

    public static InterfaceC0429ph m1438a(InputStream inputStream) {
        return C0446yb.m8526(inputStream, new C0430pi());
    }

    private static InterfaceC0429ph m1439a(InputStream inputStream, C0430pi c0430pi) {
        if (inputStream == null) {
            throw new IllegalArgumentException(adds.m2731());
        }
        if (c0430pi == null) {
            throw new IllegalArgumentException(C0445ya.m8268());
        }
        return new C0420oz(c0430pi, inputStream);
    }

    static boolean m1440a(AssertionError assertionError) {
        return (m7926(assertionError) == null || C0453yj.m9832(assertionError) == null || !C0446yb.m8589(C0453yj.m9832(assertionError), abf.m2556())) ? false : true;
    }

    public static InterfaceC0410op m1441b(InterfaceC0428pg interfaceC0428pg) {
        return new C0423pb(interfaceC0428pg);
    }

    public static InterfaceC0428pg m1442b(Socket socket) throws IOException {
        if (socket == null) {
            throw new IllegalArgumentException(abf.m2650());
        }
        if (C0445ya.m8277(socket) == null) {
            throw new IOException(C0449ye.m9114());
        }
        C0404oj c0404ojM1771 = abc.m1771(socket);
        return C0449ye.m9192(c0404ojM1771, abd.m2095(C0445ya.m8277(socket), c0404ojM1771));
    }

    public static InterfaceC0411oq m1443c(InterfaceC0429ph interfaceC0429ph) {
        return new C0424pc(interfaceC0429ph);
    }

    public static InterfaceC0429ph m1444c(Socket socket) throws IOException {
        if (socket == null) {
            throw new IllegalArgumentException(abf.m2650());
        }
        if (C0456zb.m10294(socket) == null) {
            throw new IOException(C0457zc.m10609());
        }
        C0404oj c0404ojM1771 = abc.m1771(socket);
        return C0458ze.m10930(c0404ojM1771, C0446yb.m8526(C0456zb.m10294(socket), c0404ojM1771));
    }

    private static C0404oj m1445d(Socket socket) {
        return new C0422pa(socket);
    }

    public static C0404oj m7925(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return m1445d((Socket) obj);
        }
        return null;
    }

    public static Throwable m7926(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return C0598.m11897(obj);
        }
        return null;
    }

    public static InterfaceC0428pg m7927(Object obj, Object obj2) {
        if (C0453yj.m10013() >= 0) {
            return m1437a((OutputStream) obj, (C0430pi) obj2);
        }
        return null;
    }

    public static int m7928() {
        if (C0459zf.m11062() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static InterfaceC0429ph m7929(Object obj, Object obj2) {
        if (C0459zf.m11062() >= 0) {
            return m1439a((InputStream) obj, (C0430pi) obj2);
        }
        return null;
    }

    public static InterfaceC0428pg m7930(Object obj, Object obj2) {
        if (m7928() > 0) {
            return m7927((OutputStream) obj, (C0430pi) obj2);
        }
        return null;
    }

    public static C0404oj m7931(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m7925((Socket) obj);
        }
        return null;
    }

    public static InterfaceC0429ph m7932(Object obj, Object obj2) {
        if (C0460zg.m11293() > 0) {
            return m7929((InputStream) obj, (C0430pi) obj2);
        }
        return null;
    }
}
