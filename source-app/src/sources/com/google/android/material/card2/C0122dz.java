package com.google.android.material.card2;

import java.net.InetAddress;

class C0122dz extends AbstractC0022ah<InetAddress> {
    C0122dz() {
    }

    public static void m3589(Object obj, Object obj2, Object obj3) {
        if (abd.m2162() > 0) {
            ((C0122dz) obj).a2((C0155fe) obj2, (InetAddress) obj3);
        }
    }

    public static InetAddress m3590(Object obj, Object obj2) {
        if (abe.m2308() < 0) {
            return m3593(obj, obj2);
        }
        return null;
    }

    public static InetAddress m3591(Object obj, Object obj2) {
        if (adds.m2755() >= 0) {
            return ((C0122dz) obj).m406y((C0152fb) obj2);
        }
        return null;
    }

    public static void m3592(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m10013() >= 0) {
            m3594(obj, obj2, obj3);
        }
    }

    public static InetAddress m3593(Object obj, Object obj2) {
        if (C0456zb.m10484() < 0) {
            return m3591((C0122dz) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3594(Object obj, Object obj2, Object obj3) {
        if (C0459zf.m11053() >= 0) {
            m3589((C0122dz) obj, (C0155fe) obj2, (InetAddress) obj3);
        }
    }

    @Override
    public void mo225a(C0155fe c0155fe, InetAddress inetAddress) {
        m3592(this, c0155fe, inetAddress);
    }

    public void a2(C0155fe c0155fe, InetAddress inetAddress) {
        C0457zc.m10576(c0155fe, inetAddress == null ? null : C0452yh.m9783(inetAddress));
    }

    @Override
    public InetAddress mo227b(C0152fb c0152fb) {
        return m3590(this, c0152fb);
    }

    public InetAddress m406y(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) != C0452yh.m9757()) {
            return abe.m2332(C0460zg.m11347(c0152fb));
        }
        C0459zf.m11132(c0152fb);
        return null;
    }
}
