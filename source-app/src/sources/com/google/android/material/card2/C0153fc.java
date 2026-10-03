package com.google.android.material.card2;

class C0153fc extends AbstractC0055bm {
    C0153fc() {
    }

    public static int m3850(Object obj) {
        if (C0458ze.m10932() > 0) {
            return m3858(obj);
        }
        return 0;
    }

    public static int m3851(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0152fb) obj).f269ed;
        }
        return 0;
    }

    public static int m3852(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return m3856(obj);
        }
        return 0;
    }

    public static String m3853(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0152fb) obj).m453J();
        }
        return null;
    }

    public static int m3854(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0152fb) obj).m454av();
        }
        return 0;
    }

    public static String m3855(Object obj) {
        if (abd.m2162() > 0) {
            return m3857(obj);
        }
        return null;
    }

    public static int m3856(Object obj) {
        if (gggy.m4365() > 0) {
            return m3854((C0152fb) obj);
        }
        return 0;
    }

    public static String m3857(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m3853((C0152fb) obj);
        }
        return null;
    }

    public static int m3858(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m3851((C0152fb) obj);
        }
        return 0;
    }

    @Override
    public void mo301g(C0152fb c0152fb) {
        if (c0152fb instanceof C0084co) {
            C0453yj.m9932((C0084co) c0152fb);
            return;
        }
        int iM3850 = m3850(c0152fb);
        if (iM3850 == 0) {
            iM3850 = m3852(c0152fb);
        }
        if (iM3850 == 13) {
            c0152fb.f269ed = 9;
        } else if (iM3850 == 12) {
            c0152fb.f269ed = 8;
        } else {
            if (iM3850 != 14) {
                throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0458ze.m10805()), abe.m2401(c0152fb)), m3855(c0152fb))));
            }
            c0152fb.f269ed = 10;
        }
    }
}
