package com.google.android.material.card2;

import java.io.IOException;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.util.logging.Logger;
import javax.annotation.Nullable;

final class C0422pa extends C0404oj {

    final Socket f1325vC;

    C0422pa(Socket socket) {
        this.f1325vC = socket;
    }

    public static Logger m7998() {
        if (C0446yb.m8415() < 0) {
            return C0418ox.f1319vx;
        }
        return null;
    }

    public static Socket m7999(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0422pa) obj).f1325vC;
        }
        return null;
    }

    public static Logger m8000() {
        if (C0459zf.m11062() > 0) {
            return m8004();
        }
        return null;
    }

    public static boolean m8001(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return C0418ox.m1440a((AssertionError) obj);
        }
        return false;
    }

    public static boolean m8002(Object obj) {
        if (adds.m2755() > 0) {
            return m8005(obj);
        }
        return false;
    }

    public static Socket m8003(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return m8006(obj);
        }
        return null;
    }

    public static Logger m8004() {
        if (C0448yd.m9074() <= 0) {
            return m7998();
        }
        return null;
    }

    public static boolean m8005(Object obj) {
        if (C0447yc.m8786() > 0) {
            return m8001((AssertionError) obj);
        }
        return false;
    }

    public static Socket m8006(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m7999((C0422pa) obj);
        }
        return null;
    }

    @Override
    protected IOException mo1225e(@Nullable IOException iOException) {
        SocketTimeoutException socketTimeoutException = new SocketTimeoutException(abf.m2593());
        if (iOException != null) {
            C0457zc.m10598(socketTimeoutException, iOException);
        }
        return socketTimeoutException;
    }

    @Override
    protected void mo1227eS() {
        try {
            C0456zb.m10350(m8003(this));
        } catch (AssertionError e) {
            if (!m8002(e)) {
                throw e;
            }
            C0455za.m10051(m8000(), C0455za.m10136(), abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0452yh.m9695()), m8003(this))), e);
        } catch (Exception e2) {
            C0455za.m10051(m8000(), C0455za.m10136(), abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0452yh.m9695()), m8003(this))), e2);
        }
    }
}
