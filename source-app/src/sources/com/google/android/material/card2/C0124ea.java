package com.google.android.material.card2;

import java.util.UUID;

class C0124ea extends AbstractC0022ah<UUID> {
    C0124ea() {
    }

    public static void m3595(Object obj, Object obj2, Object obj3) {
        if (C0449ye.m9220() <= 0) {
            ((C0124ea) obj).a2((C0155fe) obj2, (UUID) obj3);
        }
    }

    public static UUID m3596(Object obj, Object obj2) {
        if (C0449ye.m9220() <= 0) {
            return ((C0124ea) obj).m407z((C0152fb) obj2);
        }
        return null;
    }

    public static UUID m3597(Object obj, Object obj2) {
        if (gggy.m4269() <= 0) {
            return m3600(obj, obj2);
        }
        return null;
    }

    public static void m3598(Object obj, Object obj2, Object obj3) {
        if (abd.m2162() >= 0) {
            m3599(obj, obj2, obj3);
        }
    }

    public static void m3599(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8330() >= 0) {
            m3595((C0124ea) obj, (C0155fe) obj2, (UUID) obj3);
        }
    }

    public static UUID m3600(Object obj, Object obj2) {
        if (C0453yj.m9945() <= 0) {
            return m3596((C0124ea) obj, (C0152fb) obj2);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, UUID uuid) {
        m3598(this, c0155fe, uuid);
    }

    public void a2(C0155fe c0155fe, UUID uuid) {
        C0457zc.m10576(c0155fe, uuid == null ? null : abf.m2433(uuid));
    }

    @Override
    public UUID mo227b(C0152fb c0152fb) {
        return m3597(this, c0152fb);
    }

    public UUID m407z(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) != C0452yh.m9757()) {
            return C0450yf.m9438(C0460zg.m11347(c0152fb));
        }
        C0459zf.m11132(c0152fb);
        return null;
    }
}
