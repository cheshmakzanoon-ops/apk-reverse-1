package com.google.android.material.card2;

import java.sql.Timestamp;
import java.util.Date;

class C0127ed extends AbstractC0022ah<Timestamp> {

    final AbstractC0022ah f236dA;

    final C0126ec f237dz;

    C0127ed(C0126ec c0126ec, AbstractC0022ah abstractC0022ah) {
        this.f237dz = c0126ec;
        this.f236dA = abstractC0022ah;
    }

    public static Timestamp m3607(Object obj, Object obj2) {
        if (abf.m2510() <= 0) {
            return ((C0127ed) obj).m409B((C0152fb) obj2);
        }
        return null;
    }

    public static void m3608(Object obj, Object obj2, Object obj3) {
        if (adds.m2755() > 0) {
            ((C0127ed) obj).a2((C0155fe) obj2, (Timestamp) obj3);
        }
    }

    public static Timestamp m3609(Object obj, Object obj2) {
        if (C0449ye.m9220() < 0) {
            return m3614(obj, obj2);
        }
        return null;
    }

    public static void m3610(Object obj, Object obj2, Object obj3) {
        if (C0450yf.m9352() <= 0) {
            m3615(obj, obj2, obj3);
        }
    }

    public static AbstractC0022ah m3611(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0127ed) obj).f236dA;
        }
        return null;
    }

    public static AbstractC0022ah m3612(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return m3613(obj);
        }
        return null;
    }

    public static AbstractC0022ah m3613(Object obj) {
        if (abf.m2500() > 0) {
            return m3611((C0127ed) obj);
        }
        return null;
    }

    public static Timestamp m3614(Object obj, Object obj2) {
        if (abd.m2021() > 0) {
            return m3607((C0127ed) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3615(Object obj, Object obj2, Object obj3) {
        if (abd.m2021() >= 0) {
            m3608((C0127ed) obj, (C0155fe) obj2, (Timestamp) obj3);
        }
    }

    public Timestamp m409B(C0152fb c0152fb) {
        Date date = (Date) C0447yc.m8683(m3612(this), c0152fb);
        if (date != null) {
            return new Timestamp(C0461zs.m11479(date));
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, Timestamp timestamp) {
        m3610(this, c0155fe, timestamp);
    }

    public void a2(C0155fe c0155fe, Timestamp timestamp) {
        C0457zc.m10586(m3612(this), c0155fe, timestamp);
    }

    @Override
    public Timestamp mo227b(C0152fb c0152fb) {
        return m3609(this, c0152fb);
    }
}
