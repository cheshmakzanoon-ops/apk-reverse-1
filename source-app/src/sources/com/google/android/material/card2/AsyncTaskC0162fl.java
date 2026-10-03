package com.google.android.material.card2;

import android.content.Context;
import android.os.AsyncTask;

class AsyncTaskC0162fl extends AsyncTask<Void, Void, Void> {

    final Context f308eK;

    final String f309eL;

    final InterfaceC0172fv f310eM;

    final Runnable f311eN;

    final C0161fk f312eO;

    AsyncTaskC0162fl(C0161fk c0161fk, Context context, String str, InterfaceC0172fv interfaceC0172fv, Runnable runnable) {
        this.f312eO = c0161fk;
        this.f308eK = context;
        this.f309eL = str;
        this.f310eM = interfaceC0172fv;
        this.f311eN = runnable;
    }

    public static Runnable m3956(Object obj) {
        if (gggy.m4269() < 0) {
            return m3971(obj);
        }
        return null;
    }

    public static InterfaceC0172fv m3957(Object obj) {
        if (gggy.m4269() < 0) {
            return ((AsyncTaskC0162fl) obj).f310eM;
        }
        return null;
    }

    public static int m3958() {
        if (C0460zg.m11287() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static void m3959(Object obj, Object obj2) {
        if (C0451yg.m9580() > 0) {
            ((AsyncTaskC0162fl) obj).m482a((Void) obj2);
        }
    }

    public static void m3960(Object obj, Object obj2) {
        if (C0449ye.m9220() <= 0) {
            m3973(obj, obj2);
        }
    }

    public static String m3961(Object obj) {
        if (abe.m2308() < 0) {
            return m3977(obj);
        }
        return null;
    }

    public static Context m3962(Object obj) {
        if (abf.m2510() < 0) {
            return ((AsyncTaskC0162fl) obj).f308eK;
        }
        return null;
    }

    public static C0161fk m3963(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((AsyncTaskC0162fl) obj).f312eO;
        }
        return null;
    }

    public static String m3964(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((AsyncTaskC0162fl) obj).f309eL;
        }
        return null;
    }

    public static InterfaceC0172fv m3965(Object obj) {
        if (C0453yj.m10013() > 0) {
            return m3975(obj);
        }
        return null;
    }

    public static C0161fk m3966(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m3976(obj);
        }
        return null;
    }

    public static Context m3967(Object obj) {
        if (gggy.m4269() <= 0) {
            return m3974(obj);
        }
        return null;
    }

    public static Runnable m3968(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((AsyncTaskC0162fl) obj).f311eN;
        }
        return null;
    }

    public static Void m3969(Object obj, Object obj2) {
        if (gggy.m4269() < 0) {
            return ((AsyncTaskC0162fl) obj).m481a((Void[]) obj2);
        }
        return null;
    }

    public static Void m3970(Object obj, Object obj2) {
        if (abc.m1845() < 0) {
            return m3972(obj, obj2);
        }
        return null;
    }

    public static Runnable m3971(Object obj) {
        if (abd.m2166() < 0) {
            return m3968((AsyncTaskC0162fl) obj);
        }
        return null;
    }

    public static Void m3972(Object obj, Object obj2) {
        if (C0456zb.m10484() < 0) {
            return m3969((AsyncTaskC0162fl) obj, (Void[]) obj2);
        }
        return null;
    }

    public static void m3973(Object obj, Object obj2) {
        if (abd.m2166() < 0) {
            m3959((AsyncTaskC0162fl) obj, (Void) obj2);
        }
    }

    public static Context m3974(Object obj) {
        if (m3958() > 0) {
            return m3962((AsyncTaskC0162fl) obj);
        }
        return null;
    }

    public static InterfaceC0172fv m3975(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m3957((AsyncTaskC0162fl) obj);
        }
        return null;
    }

    public static C0161fk m3976(Object obj) {
        if (abe.m2321() <= 0) {
            return m3963((AsyncTaskC0162fl) obj);
        }
        return null;
    }

    public static String m3977(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m3964((AsyncTaskC0162fl) obj);
        }
        return null;
    }

    protected Void m481a(Void... voidArr) {
        try {
            C0445ya.m8255(m3965(this), m3966(this), C0457zc.m10676(C0452yh.m9617(m3967(this)), C0458ze.m10822(m3961(this))), null);
        } catch (Throwable th) {
            C0460zg.m11322(th);
        }
        return null;
    }

    protected void m482a(Void r104) {
        C0460zg.m11226(m3956(this));
    }

    @Override
    protected Void doInBackground(Void[] voidArr) {
        return m3970(this, voidArr);
    }

    @Override
    protected void onPostExecute(Void r1) {
        m3960(this, r1);
    }
}
