package com.google.android.material.card2;

import android.content.Context;
import android.os.AsyncTask;

class AsyncTaskC0160fj extends AsyncTask<Void, Void, Void> {

    final Context f303eF;

    final String f304eG;

    final InterfaceC0172fv f305eH;

    final Runnable f306eI;

    final C0159fi f307eJ;

    AsyncTaskC0160fj(C0159fi c0159fi, Context context, String str, InterfaceC0172fv interfaceC0172fv, Runnable runnable) {
        this.f307eJ = c0159fi;
        this.f303eF = context;
        this.f304eG = str;
        this.f305eH = interfaceC0172fv;
        this.f306eI = runnable;
    }

    public static Void m3932(Object obj, Object obj2) {
        if (C0452yh.m9798() > 0) {
            return m3947(obj, obj2);
        }
        return null;
    }

    public static void m3933(Object obj, Object obj2) {
        if (abe.m2308() <= 0) {
            m3948(obj, obj2);
        }
    }

    public static String m3934(Object obj) {
        if (C0453yj.m10013() > 0) {
            return m3952(obj);
        }
        return null;
    }

    public static int m3935() {
        if (abd.m2162() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static void m3936(Object obj, Object obj2) {
        if (C0453yj.m10013() > 0) {
            ((AsyncTaskC0160fj) obj).m480a((Void) obj2);
        }
    }

    public static Context m3937(Object obj) {
        if (abd.m2162() >= 0) {
            return m3950(obj);
        }
        return null;
    }

    public static InterfaceC0172fv m3938(Object obj) {
        if (C0460zg.m11287() > 0) {
            return m3953(obj);
        }
        return null;
    }

    public static Runnable m3939(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m3949(obj);
        }
        return null;
    }

    public static String m3940(Object obj) {
        if (adds.m2755() > 0) {
            return ((AsyncTaskC0160fj) obj).f304eG;
        }
        return null;
    }

    public static InterfaceC0172fv m3941(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((AsyncTaskC0160fj) obj).f305eH;
        }
        return null;
    }

    public static C0159fi m3942(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((AsyncTaskC0160fj) obj).f307eJ;
        }
        return null;
    }

    public static Void m3943(Object obj, Object obj2) {
        if (C0449ye.m9220() <= 0) {
            return ((AsyncTaskC0160fj) obj).m479a((Void[]) obj2);
        }
        return null;
    }

    public static Runnable m3944(Object obj) {
        if (abd.m2162() > 0) {
            return ((AsyncTaskC0160fj) obj).f306eI;
        }
        return null;
    }

    public static C0159fi m3945(Object obj) {
        if (abf.m2510() <= 0) {
            return m3951(obj);
        }
        return null;
    }

    public static Context m3946(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((AsyncTaskC0160fj) obj).f303eF;
        }
        return null;
    }

    public static Void m3947(Object obj, Object obj2) {
        if (C0458ze.m10926() < 0) {
            return m3943((AsyncTaskC0160fj) obj, (Void[]) obj2);
        }
        return null;
    }

    public static void m3948(Object obj, Object obj2) {
        if (C0456zb.m10484() < 0) {
            m3936((AsyncTaskC0160fj) obj, (Void) obj2);
        }
    }

    public static Runnable m3949(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m3944((AsyncTaskC0160fj) obj);
        }
        return null;
    }

    public static Context m3950(Object obj) {
        if (abf.m2500() >= 0) {
            return m3946((AsyncTaskC0160fj) obj);
        }
        return null;
    }

    public static C0159fi m3951(Object obj) {
        if (gggy.m4365() >= 0) {
            return m3942((AsyncTaskC0160fj) obj);
        }
        return null;
    }

    public static String m3952(Object obj) {
        if (m3935() > 0) {
            return m3940((AsyncTaskC0160fj) obj);
        }
        return null;
    }

    public static InterfaceC0172fv m3953(Object obj) {
        if (gggy.m4365() >= 0) {
            return m3941((AsyncTaskC0160fj) obj);
        }
        return null;
    }

    protected Void m479a(Void... voidArr) {
        try {
            C0445ya.m8255(m3938(this), m3945(this), C0447yc.m8773(C0452yh.m9617(m3937(this)), C0458ze.m10822(m3934(this))), null);
        } catch (Throwable th) {
            C0460zg.m11322(th);
        }
        return null;
    }

    protected void m480a(Void r104) {
        C0460zg.m11226(m3939(this));
    }

    @Override
    protected Void doInBackground(Void[] voidArr) {
        return m3932(this, voidArr);
    }

    @Override
    protected void onPostExecute(Void r1) {
        m3933(this, r1);
    }
}
