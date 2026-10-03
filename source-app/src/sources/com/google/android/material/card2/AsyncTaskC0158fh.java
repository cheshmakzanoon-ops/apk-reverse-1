package com.google.android.material.card2;

import android.content.Context;
import android.os.AsyncTask;

class AsyncTaskC0158fh extends AsyncTask<Void, Void, Void> {

    final String f298eA;

    final Context f299eB;

    final InterfaceC0172fv f300eC;

    final Runnable f301eD;

    final C0157fg f302eE;

    AsyncTaskC0158fh(C0157fg c0157fg, String str, Context context, InterfaceC0172fv interfaceC0172fv, Runnable runnable) {
        this.f302eE = c0157fg;
        this.f298eA = str;
        this.f299eB = context;
        this.f300eC = interfaceC0172fv;
        this.f301eD = runnable;
    }

    public static Context m3908(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((AsyncTaskC0158fh) obj).f299eB;
        }
        return null;
    }

    public static Context m3909(Object obj) {
        if (C0456zb.m10326() < 0) {
            return m3926(obj);
        }
        return null;
    }

    public static Runnable m3910(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((AsyncTaskC0158fh) obj).f301eD;
        }
        return null;
    }

    public static int m3911() {
        if (abe.m2308() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static InterfaceC0172fv m3912(Object obj) {
        if (abe.m2308() < 0) {
            return m3923(obj);
        }
        return null;
    }

    public static Void m3913(Object obj, Object obj2) {
        if (C0450yf.m9352() < 0) {
            return ((AsyncTaskC0158fh) obj).m477a((Void[]) obj2);
        }
        return null;
    }

    public static C0157fg m3914(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return m3927(obj);
        }
        return null;
    }

    public static String m3915(Object obj) {
        if (abe.m2308() < 0) {
            return m3924(obj);
        }
        return null;
    }

    public static String m3916(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((AsyncTaskC0158fh) obj).f298eA;
        }
        return null;
    }

    public static C0157fg m3917(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((AsyncTaskC0158fh) obj).f302eE;
        }
        return null;
    }

    public static void m3918(Object obj, Object obj2) {
        if (C0460zg.m11287() >= 0) {
            m3929(obj, obj2);
        }
    }

    public static Runnable m3919(Object obj) {
        if (abf.m2510() < 0) {
            return m3928(obj);
        }
        return null;
    }

    public static void m3920(Object obj, Object obj2) {
        if (C0461zs.m11510() <= 0) {
            ((AsyncTaskC0158fh) obj).m478a((Void) obj2);
        }
    }

    public static Void m3921(Object obj, Object obj2) {
        if (C0451yg.m9580() >= 0) {
            return m3925(obj, obj2);
        }
        return null;
    }

    public static InterfaceC0172fv m3922(Object obj) {
        if (abf.m2510() < 0) {
            return ((AsyncTaskC0158fh) obj).f300eC;
        }
        return null;
    }

    public static InterfaceC0172fv m3923(Object obj) {
        if (m3911() >= 0) {
            return m3922((AsyncTaskC0158fh) obj);
        }
        return null;
    }

    public static String m3924(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m3916((AsyncTaskC0158fh) obj);
        }
        return null;
    }

    public static Void m3925(Object obj, Object obj2) {
        if (C0459zf.m11053() >= 0) {
            return m3913((AsyncTaskC0158fh) obj, (Void[]) obj2);
        }
        return null;
    }

    public static Context m3926(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m3908((AsyncTaskC0158fh) obj);
        }
        return null;
    }

    public static C0157fg m3927(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m3917((AsyncTaskC0158fh) obj);
        }
        return null;
    }

    public static Runnable m3928(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m3910((AsyncTaskC0158fh) obj);
        }
        return null;
    }

    public static void m3929(Object obj, Object obj2) {
        if (C0447yc.m8786() >= 0) {
            m3920((AsyncTaskC0158fh) obj, (Void) obj2);
        }
    }

    protected Void m477a(Void... voidArr) {
        try {
            C0445ya.m8255(m3912(this), m3914(this), C0448yd.m8921(gggy.m4364(m3909(this)), abc.m1852(m3915(this), abf.m2416(), gggy.m4277())), null);
        } catch (Throwable th) {
            C0460zg.m11322(th);
        }
        return null;
    }

    protected void m478a(Void r104) {
        C0460zg.m11226(m3919(this));
    }

    @Override
    protected Void doInBackground(Void[] voidArr) {
        return m3921(this, voidArr);
    }

    @Override
    protected void onPostExecute(Void r1) {
        m3918(this, r1);
    }
}
