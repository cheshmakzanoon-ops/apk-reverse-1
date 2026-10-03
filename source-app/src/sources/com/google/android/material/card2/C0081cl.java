package com.google.android.material.card2;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.ParsePosition;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

public final class C0081cl extends AbstractC0022ah<Date> {

    public static final InterfaceC0024aj f129bx = new C0082cm();

    private final List<DateFormat> f130by = new ArrayList();

    public C0081cl() {
        C0460zg.m11251(abf.m2553(this), C0461zs.m11562(2, 2, C0446yb.m8554()));
        if (!m3275(C0452yh.m9731(), C0446yb.m8554())) {
            C0460zg.m11251(abf.m2553(this), C0448yd.m9085(2, 2));
        }
        if (C0456zb.m10411()) {
            C0460zg.m11251(abf.m2553(this), C0458ze.m10845(2, 2));
        }
    }

    private Date m333e(String str) {
        Date dateM11150;
        synchronized (this) {
            Iterator itM9883 = C0453yj.m9883(abf.m2553(this));
            try {
                while (C0455za.m10104(itM9883)) {
                    try {
                        dateM11150 = C0447yc.m8780((DateFormat) m3277(itM9883), str);
                    } catch (ParseException e) {
                    }
                }
                dateM11150 = C0459zf.m11150(str, new ParsePosition(0));
            } catch (ParseException e2) {
                throw new C0018ad(str, e2);
            }
        }
        return dateM11150;
    }

    public static boolean m3275(Object obj, Object obj2) {
        if (C0460zg.m11287() > 0) {
            return C0598.m11893(obj, obj2);
        }
        return false;
    }

    public static Date m3276(Object obj, Object obj2) {
        if (abc.m1845() <= 0) {
            return ((C0081cl) obj).m333e((String) obj2);
        }
        return null;
    }

    public static Object m3277(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static List m3278(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0081cl) obj).f130by;
        }
        return null;
    }

    public static Date m3279(Object obj, Object obj2) {
        if (C0458ze.m10926() < 0) {
            return m3276((C0081cl) obj, (String) obj2);
        }
        return null;
    }

    public static List m3280(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m3278((C0081cl) obj);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, Date date) {
        C0450yf.m9565(this, c0155fe, date);
    }

    public void a2(C0155fe c0155fe, Date date) {
        synchronized (this) {
            try {
                if (date == null) {
                    C0457zc.m10630(c0155fe);
                } else {
                    C0457zc.m10576(c0155fe, abd.m2048((DateFormat) gggy.m4400(abf.m2553(this), 0), date));
                }
            } catch (Throwable th) {
                throw th;
            }
        }
    }

    @Override
    public Date mo227b(C0152fb c0152fb) {
        return C0459zf.m11154(this, c0152fb);
    }

    public Date m334j(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) != C0452yh.m9757()) {
            return C0461zs.m11613(this, C0460zg.m11347(c0152fb));
        }
        C0459zf.m11132(c0152fb);
        return null;
    }
}
