package com.google.android.material.card2;

import android.content.Context;
import android.os.AsyncTask;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Iterator;
import org.apache.http.NameValuePair;

class AsyncTaskC0167fq extends AsyncTask<Void, Void, Void> {

    final String f319eV;

    final Context f320eW;

    final InterfaceC0172fv f321eX;

    final Runnable f322eY;

    final C0166fp f323eZ;

    AsyncTaskC0167fq(C0166fp c0166fp, String str, Context context, InterfaceC0172fv interfaceC0172fv, Runnable runnable) {
        this.f323eZ = c0166fp;
        this.f319eV = str;
        this.f320eW = context;
        this.f321eX = interfaceC0172fv;
        this.f322eY = runnable;
    }

    public static void m4004(Object obj, Object obj2) {
        if (abe.m2308() < 0) {
            m4032(obj, obj2);
        }
    }

    public static C0166fp m4005(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((AsyncTaskC0167fq) obj).f323eZ;
        }
        return null;
    }

    public static String m4006(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return m4028(obj);
        }
        return null;
    }

    public static Context m4007(Object obj) {
        if (C0456zb.m10326() < 0) {
            return m4033(obj);
        }
        return null;
    }

    public static String m4008(Object obj) {
        if (C0452yh.m9798() > 0) {
            return m4027(obj);
        }
        return null;
    }

    public static Runnable m4009(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return m4035(obj);
        }
        return null;
    }

    public static Context m4010(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((AsyncTaskC0167fq) obj).f320eW;
        }
        return null;
    }

    public static void m4011(Object obj, Object obj2) {
        if (abe.m2308() < 0) {
            C0174fx.m505a((String) obj, (Object[]) obj2);
        }
    }

    public static InterfaceC0180gc m4012(Object obj) {
        if (C0458ze.m10932() > 0) {
            return C0459zf.m11183((C0166fp) obj);
        }
        return null;
    }

    public static InterfaceC0172fv m4013(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((AsyncTaskC0167fq) obj).f321eX;
        }
        return null;
    }

    public static Iterator m4014(Object obj) {
        if (C0445ya.m8222() > 0) {
            return C0598.m11895(obj);
        }
        return null;
    }

    public static void m4015(Object obj, Object obj2) {
        if (C0456zb.m10326() <= 0) {
            m4031(obj, obj2);
        }
    }

    public static InterfaceC0180gc m4016(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return m4036(obj);
        }
        return null;
    }

    public static InterfaceC0172fv m4017(Object obj) {
        if (abf.m2510() < 0) {
            return m4034(obj);
        }
        return null;
    }

    public static int m4018() {
        if (C0457zc.m10735() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static void m4019(Object obj, Object obj2) {
        if (C0445ya.m8222() >= 0) {
            ((AsyncTaskC0167fq) obj).m488a((Void) obj2);
        }
    }

    public static String m4020(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return m4030(obj);
        }
        return null;
    }

    public static Void m4021(Object obj, Object obj2) {
        if (C0446yb.m8415() <= 0) {
            return ((AsyncTaskC0167fq) obj).m487a((Void[]) obj2);
        }
        return null;
    }

    public static String m4022(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((AsyncTaskC0167fq) obj).f319eV;
        }
        return null;
    }

    public static Runnable m4023(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((AsyncTaskC0167fq) obj).f322eY;
        }
        return null;
    }

    public static Object m4024(Object obj) {
        if (C0449ye.m9220() < 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static C0166fp m4025(Object obj) {
        if (gggy.m4269() <= 0) {
            return m4037(obj);
        }
        return null;
    }

    public static Void m4026(Object obj, Object obj2) {
        if (C0448yd.m9079() < 0) {
            return m4029(obj, obj2);
        }
        return null;
    }

    public static String m4027(Object obj) {
        if (C0447yc.m8786() > 0) {
            return m4022((AsyncTaskC0167fq) obj);
        }
        return null;
    }

    public static String m4028(Object obj) {
        if (C0447yc.m8786() > 0) {
            return abe.m2229((NameValuePair) obj);
        }
        return null;
    }

    public static Void m4029(Object obj, Object obj2) {
        if (C0447yc.m8786() >= 0) {
            return m4021((AsyncTaskC0167fq) obj, (Void[]) obj2);
        }
        return null;
    }

    public static String m4030(Object obj) {
        if (C0448yd.m9074() < 0) {
            return C0457zc.m10638((NameValuePair) obj);
        }
        return null;
    }

    public static void m4031(Object obj, Object obj2) {
        if (C0445ya.m8330() >= 0) {
            m4019((AsyncTaskC0167fq) obj, (Void) obj2);
        }
    }

    public static void m4032(Object obj, Object obj2) {
        if (C0459zf.m11053() >= 0) {
            m4011((String) obj, (Object[]) obj2);
        }
    }

    public static Context m4033(Object obj) {
        if (abf.m2500() > 0) {
            return m4010((AsyncTaskC0167fq) obj);
        }
        return null;
    }

    public static InterfaceC0172fv m4034(Object obj) {
        if (abd.m2021() >= 0) {
            return m4013((AsyncTaskC0167fq) obj);
        }
        return null;
    }

    public static Runnable m4035(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m4023((AsyncTaskC0167fq) obj);
        }
        return null;
    }

    public static InterfaceC0180gc m4036(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m4012((C0166fp) obj);
        }
        return null;
    }

    public static C0166fp m4037(Object obj) {
        if (m4018() > 0) {
            return m4005((AsyncTaskC0167fq) obj);
        }
        return null;
    }

    protected Void m487a(Void... voidArr) {
        HttpURLConnection httpURLConnection;
        ArrayList arrayListM9640;
        try {
            String strM4008 = m4008(this);
            while (true) {
                httpURLConnection = (HttpURLConnection) C0461zs.m11621(new URL(strM4008));
                C0446yb.m8531(httpURLConnection, true);
                if (m4016(m4025(this)) != null && (arrayListM9640 = C0452yh.m9640(m4016(m4025(this)), m4007(this), m4008(this))) != null) {
                    Iterator itM4014 = m4014(arrayListM9640);
                    while (C0455za.m10104(itM4014)) {
                        NameValuePair nameValuePair = (NameValuePair) m4024(itM4014);
                        adds.m2784(httpURLConnection, m4020(nameValuePair), m4006(nameValuePair));
                    }
                }
                if (C0449ye.m9221(httpURLConnection) != 302 && C0449ye.m9221(httpURLConnection) != 301) {
                    break;
                }
                strM4008 = abc.m1930(httpURLConnection, C0446yb.m8523());
            }
            if (C0449ye.m9221(httpURLConnection) != 200) {
                m4004(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), abd.m2052()), C0449ye.m9221(httpURLConnection))), new Object[0]);
            } else {
                C0445ya.m8255(m4017(this), m4025(this), C0461zs.m11445(httpURLConnection), null);
            }
        } catch (Throwable th) {
            C0460zg.m11322(th);
        }
        return null;
    }

    protected void m488a(Void r104) {
        C0460zg.m11226(m4009(this));
    }

    @Override
    protected Void doInBackground(Void[] voidArr) {
        return m4026(this, voidArr);
    }

    @Override
    protected void onPostExecute(Void r1) {
        m4015(this, r1);
    }
}
