package com.google.android.material.card2;

import android.os.AsyncTask;
import java.io.InputStream;

final class AsyncTaskC0178ga extends AsyncTask<Void, Void, Void> {

    final AbstractC0179gb f361fK;

    final String f362fL;

    final Runnable f363fM;

    AsyncTaskC0178ga(AbstractC0179gb abstractC0179gb, String str, Runnable runnable) {
        this.f361fK = abstractC0179gb;
        this.f362fL = str;
        this.f363fM = runnable;
    }

    public static void m4201(Object obj, Object obj2) {
        if (abe.m2308() < 0) {
            m4218(obj, obj2);
        }
    }

    public static String m4202(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((AsyncTaskC0178ga) obj).f362fL;
        }
        return null;
    }

    public static void m4203(Object obj, Object obj2) {
        if (abd.m2162() > 0) {
            ((AsyncTaskC0178ga) obj).m519a((Void) obj2);
        }
    }

    public static AbstractC0179gb m4204(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((AsyncTaskC0178ga) obj).f361fK;
        }
        return null;
    }

    public static void m4205(Object obj, Object obj2, Object obj3, Object obj4) {
        if (gggy.m4269() <= 0) {
            ((AbstractC0179gb) obj).mo496a((InterfaceC0171fu) obj2, (InputStream) obj3, (String) obj4);
        }
    }

    public static String m4206(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return m4215(obj);
        }
        return null;
    }

    public static Runnable m4207(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((AsyncTaskC0178ga) obj).f363fM;
        }
        return null;
    }

    public static AbstractC0179gb m4208(Object obj) {
        if (C0458ze.m10932() > 0) {
            return m4216(obj);
        }
        return null;
    }

    public static Void m4209(Object obj, Object obj2) {
        if (abe.m2308() <= 0) {
            return ((AsyncTaskC0178ga) obj).m518a((Void[]) obj2);
        }
        return null;
    }

    public static Void m4210(Object obj, Object obj2) {
        if (C0445ya.m8222() >= 0) {
            return m4213(obj, obj2);
        }
        return null;
    }

    public static Runnable m4211(Object obj) {
        if (abc.m1845() < 0) {
            return m4214(obj);
        }
        return null;
    }

    public static void m4212(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0445ya.m8222() >= 0) {
            m4217(obj, obj2, obj3, obj4);
        }
    }

    public static Void m4213(Object obj, Object obj2) {
        if (C0457zc.m10555() > 0) {
            return m4209((AsyncTaskC0178ga) obj, (Void[]) obj2);
        }
        return null;
    }

    public static Runnable m4214(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m4207((AsyncTaskC0178ga) obj);
        }
        return null;
    }

    public static String m4215(Object obj) {
        if (abd.m2021() > 0) {
            return m4202((AsyncTaskC0178ga) obj);
        }
        return null;
    }

    public static AbstractC0179gb m4216(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m4204((AsyncTaskC0178ga) obj);
        }
        return null;
    }

    public static void m4217(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0460zg.m11293() >= 0) {
            m4205((AbstractC0179gb) obj, (InterfaceC0171fu) obj2, (InputStream) obj3, (String) obj4);
        }
    }

    public static void m4218(Object obj, Object obj2) {
        if (C0459zf.m11053() > 0) {
            m4203((AsyncTaskC0178ga) obj, (Void) obj2);
        }
    }

    protected Void m518a(Void... voidArr) {
        m4212(m4208(this), null, null, m4206(this));
        return null;
    }

    protected void m519a(Void r104) {
        C0460zg.m11226(m4211(this));
    }

    @Override
    protected Void doInBackground(Void[] voidArr) {
        return m4210(this, voidArr);
    }

    @Override
    protected void onPostExecute(Void r1) {
        m4201(this, r1);
    }
}
