package com.google.android.material.card2;

import java.util.Calendar;
import java.util.GregorianCalendar;

class C0128ee extends AbstractC0022ah<Calendar> {
    C0128ee() {
    }

    public static void m3616(Object obj, Object obj2, Object obj3) {
        if (C0451yg.m9580() >= 0) {
            m3622(obj, obj2, obj3);
        }
    }

    public static Calendar m3617(Object obj, Object obj2) {
        if (abd.m2162() >= 0) {
            return m3621(obj, obj2);
        }
        return null;
    }

    public static void m3618(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8222() >= 0) {
            ((C0128ee) obj).a2((C0155fe) obj2, (Calendar) obj3);
        }
    }

    public static Calendar m3619(Object obj, Object obj2) {
        if (C0449ye.m9220() < 0) {
            return ((C0128ee) obj).m410C((C0152fb) obj2);
        }
        return null;
    }

    public static String m3620() {
        if (C0461zs.m11510() <= 0) {
            return C0598.m11868();
        }
        return null;
    }

    public static Calendar m3621(Object obj, Object obj2) {
        if (C0453yj.m9945() < 0) {
            return m3619((C0128ee) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3622(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8330() >= 0) {
            m3618((C0128ee) obj, (C0155fe) obj2, (Calendar) obj3);
        }
    }

    public Calendar m410C(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        C0456zb.m10454(c0152fb);
        int i = 0;
        int i2 = 0;
        int i3 = 0;
        int i4 = 0;
        int i5 = 0;
        int i6 = 0;
        while (abe.m2401(c0152fb) != C0455za.m10079()) {
            String strM4313 = gggy.m4313(c0152fb);
            int iM11572 = C0461zs.m11572(c0152fb);
            if (C0452yh.m9583(abe.m2376(), strM4313)) {
                i = iM11572;
            } else if (C0452yh.m9583(m3620(), strM4313)) {
                i2 = iM11572;
            } else if (C0452yh.m9583(abc.m1751(), strM4313)) {
                i3 = iM11572;
            } else if (C0452yh.m9583(adds.m2709(), strM4313)) {
                i4 = iM11572;
            } else if (C0452yh.m9583(C0461zs.m11606(), strM4313)) {
                i5 = iM11572;
            } else if (C0452yh.m9583(C0449ye.m9147(), strM4313)) {
                i6 = iM11572;
            }
        }
        C0459zf.m11135(c0152fb);
        return new GregorianCalendar(i, i2, i3, i4, i5, i6);
    }

    @Override
    public void mo225a(C0155fe c0155fe, Calendar calendar) {
        m3616(this, c0155fe, calendar);
    }

    public void a2(C0155fe c0155fe, Calendar calendar) {
        if (calendar == null) {
            C0457zc.m10630(c0155fe);
            return;
        }
        C0447yc.m8775(c0155fe);
        C0453yj.m9830(c0155fe, abe.m2376());
        C0448yd.m9067(c0155fe, C0458ze.m10882(calendar, 1));
        C0453yj.m9830(c0155fe, m3620());
        C0448yd.m9067(c0155fe, C0458ze.m10882(calendar, 2));
        C0453yj.m9830(c0155fe, abc.m1751());
        C0448yd.m9067(c0155fe, C0458ze.m10882(calendar, 5));
        C0453yj.m9830(c0155fe, adds.m2709());
        C0448yd.m9067(c0155fe, C0458ze.m10882(calendar, 11));
        C0453yj.m9830(c0155fe, C0461zs.m11606());
        C0448yd.m9067(c0155fe, C0458ze.m10882(calendar, 12));
        C0453yj.m9830(c0155fe, C0449ye.m9147());
        C0448yd.m9067(c0155fe, C0458ze.m10882(calendar, 13));
        C0458ze.m10945(c0155fe);
    }

    @Override
    public Calendar mo227b(C0152fb c0152fb) {
        return m3617(this, c0152fb);
    }
}
