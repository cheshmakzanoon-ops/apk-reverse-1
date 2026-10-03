package com.google.android.material.card2;

import java.util.Locale;
import java.util.StringTokenizer;

class C0129ef extends AbstractC0022ah<Locale> {
    C0129ef() {
    }

    public static Locale m3623(Object obj, Object obj2) {
        if (C0452yh.m9798() >= 0) {
            return ((C0129ef) obj).m411D((C0152fb) obj2);
        }
        return null;
    }

    public static Locale m3624(Object obj, Object obj2) {
        if (C0445ya.m8222() >= 0) {
            return m3628(obj, obj2);
        }
        return null;
    }

    public static void m3625(Object obj, Object obj2, Object obj3) {
        if (C0447yc.m8635() >= 0) {
            m3627(obj, obj2, obj3);
        }
    }

    public static void m3626(Object obj, Object obj2, Object obj3) {
        if (C0456zb.m10326() <= 0) {
            ((C0129ef) obj).a2((C0155fe) obj2, (Locale) obj3);
        }
    }

    public static void m3627(Object obj, Object obj2, Object obj3) {
        if (abd.m2021() > 0) {
            m3626((C0129ef) obj, (C0155fe) obj2, (Locale) obj3);
        }
    }

    public static Locale m3628(Object obj, Object obj2) {
        if (abe.m2321() < 0) {
            return m3623((C0129ef) obj, (C0152fb) obj2);
        }
        return null;
    }

    public Locale m411D(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        StringTokenizer stringTokenizer = new StringTokenizer(C0460zg.m11347(c0152fb), C0459zf.m11019());
        String strM2712 = C0458ze.m10938(stringTokenizer) ? adds.m2712(stringTokenizer) : null;
        String strM2713 = C0458ze.m10938(stringTokenizer) ? adds.m2712(stringTokenizer) : null;
        String strM2714 = C0458ze.m10938(stringTokenizer) ? adds.m2712(stringTokenizer) : null;
        if (strM2713 == null && strM2714 == null) {
            return new Locale(strM2712);
        }
        return strM2714 == null ? new Locale(strM2712, strM2713) : new Locale(strM2712, strM2713, strM2714);
    }

    @Override
    public void mo225a(C0155fe c0155fe, Locale locale) {
        m3625(this, c0155fe, locale);
    }

    public void a2(C0155fe c0155fe, Locale locale) {
        C0457zc.m10576(c0155fe, locale == null ? null : C0447yc.m8684(locale));
    }

    @Override
    public Locale mo227b(C0152fb c0152fb) {
        return m3624(this, c0152fb);
    }
}
