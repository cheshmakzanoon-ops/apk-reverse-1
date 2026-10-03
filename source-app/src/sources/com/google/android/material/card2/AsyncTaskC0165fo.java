package com.google.android.material.card2;

import android.os.AsyncTask;
import java.io.File;
import java.net.URI;

class AsyncTaskC0165fo extends AsyncTask<Void, Void, Void> {

    final InterfaceC0172fv f314eQ;

    final String f315eR;

    final Runnable f316eS;

    final C0164fn f317eT;

    AsyncTaskC0165fo(C0164fn c0164fn, InterfaceC0172fv interfaceC0172fv, String str, Runnable runnable) {
        this.f317eT = c0164fn;
        this.f314eQ = interfaceC0172fv;
        this.f315eR = str;
        this.f316eS = runnable;
    }

    public static Runnable m3982(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((AsyncTaskC0165fo) obj).f316eS;
        }
        return null;
    }

    public static InterfaceC0172fv m3983(Object obj) {
        if (abe.m2308() < 0) {
            return ((AsyncTaskC0165fo) obj).f314eQ;
        }
        return null;
    }

    public static Void m3984(Object obj, Object obj2) {
        if (abe.m2308() < 0) {
            return ((AsyncTaskC0165fo) obj).m484a((Void[]) obj2);
        }
        return null;
    }

    public static Runnable m3985(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return m3999(obj);
        }
        return null;
    }

    public static String m3986(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((AsyncTaskC0165fo) obj).f315eR;
        }
        return null;
    }

    public static void m3987(Object obj, Object obj2) {
        if (C0449ye.m9220() <= 0) {
            ((AsyncTaskC0165fo) obj).m485a((Void) obj2);
        }
    }

    public static Void m3988(Object obj, Object obj2) {
        if (abf.m2510() <= 0) {
            return m3994(obj, obj2);
        }
        return null;
    }

    public static C0164fn m3989(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m3998(obj);
        }
        return null;
    }

    public static String m3990(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m3997(obj);
        }
        return null;
    }

    public static InterfaceC0172fv m3991(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return m3995(obj);
        }
        return null;
    }

    public static C0164fn m3992(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((AsyncTaskC0165fo) obj).f317eT;
        }
        return null;
    }

    public static void m3993(Object obj, Object obj2) {
        if (gggy.m4269() <= 0) {
            m3996(obj, obj2);
        }
    }

    public static Void m3994(Object obj, Object obj2) {
        if (C0448yd.m9074() < 0) {
            return m3984((AsyncTaskC0165fo) obj, (Void[]) obj2);
        }
        return null;
    }

    public static InterfaceC0172fv m3995(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m3983((AsyncTaskC0165fo) obj);
        }
        return null;
    }

    public static void m3996(Object obj, Object obj2) {
        if (C0453yj.m9996() <= 0) {
            m3987((AsyncTaskC0165fo) obj, (Void) obj2);
        }
    }

    public static String m3997(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m3986((AsyncTaskC0165fo) obj);
        }
        return null;
    }

    public static C0164fn m3998(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m3992((AsyncTaskC0165fo) obj);
        }
        return null;
    }

    public static Runnable m3999(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m3982((AsyncTaskC0165fo) obj);
        }
        return null;
    }

    protected Void m484a(Void... voidArr) {
        try {
            C0445ya.m8255(m3991(this), m3989(this), null, C0461zs.m11569(new File(new URI(m3990(this)))));
        } catch (Throwable th) {
            C0460zg.m11322(th);
        }
        return null;
    }

    protected void m485a(Void r104) {
        C0460zg.m11226(m3985(this));
    }

    @Override
    protected Void doInBackground(Void[] voidArr) {
        return m3988(this, voidArr);
    }

    @Override
    protected void onPostExecute(Void r1) {
        m3993(this, r1);
    }
}
