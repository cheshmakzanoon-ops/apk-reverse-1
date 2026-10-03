package com.google.android.material.card2;

import java.util.List;
import javax.annotation.Nullable;

public final class C0268jj extends AbstractC0288kc {

    private static final C0278jt f697lC = C0445ya.m8204(C0453yj.m9967());

    private final List<String> f698lD;

    private final List<String> f699lE;

    C0268jj(List<String> list, List<String> list2) {
        this.f698lD = C0456zb.m10446(list);
        this.f699lE = C0456zb.m10446(list2);
    }

    private long m708a(@Nullable InterfaceC0410op interfaceC0410op, boolean z) {
        long jM10042 = 0;
        C0409oo c0409oo = z ? new C0409oo() : C0461zs.m11595(interfaceC0410op);
        int iM5135 = m5135(gggy.m4449(this));
        for (int i = 0; i < iM5135; i++) {
            if (i > 0) {
                C0447yc.m8844(c0409oo, 38);
            }
            C0457zc.m10684(c0409oo, (String) gggy.m4400(gggy.m4449(this), i));
            C0447yc.m8844(c0409oo, 61);
            C0457zc.m10684(c0409oo, (String) gggy.m4400(adds.m2815(this), i));
        }
        if (z) {
            jM10042 = C0455za.m10042(c0409oo);
            C0461zs.m11454(c0409oo);
        }
        return jM10042;
    }

    public static List m5131(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0268jj) obj).f699lE;
        }
        return null;
    }

    public static List m5132(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0268jj) obj).f698lD;
        }
        return null;
    }

    public static long m5133(Object obj, Object obj2, boolean z) {
        if (C0452yh.m9798() > 0) {
            return ((C0268jj) obj).m708a((InterfaceC0410op) obj2, z);
        }
        return 0L;
    }

    public static C0278jt m5134() {
        if (C0457zc.m10735() < 0) {
            return f697lC;
        }
        return null;
    }

    public static int m5135(Object obj) {
        if (abd.m2162() > 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static List m5136(Object obj) {
        if (abd.m2021() > 0) {
            return m5132((C0268jj) obj);
        }
        return null;
    }

    public static long m5137(Object obj, Object obj2, boolean z) {
        if (C0458ze.m10926() <= 0) {
            return m5133((C0268jj) obj, (InterfaceC0410op) obj2, z);
        }
        return 0L;
    }

    public static List m5138(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m5131((C0268jj) obj);
        }
        return null;
    }

    public static C0278jt m5139() {
        if (C0448yd.m9015() < 0) {
            return m5134();
        }
        return null;
    }

    @Override
    public void mo709a(InterfaceC0410op interfaceC0410op) {
        C0452yh.m9726(this, interfaceC0410op, false);
    }

    @Override
    public long mo710cf() {
        return C0452yh.m9726(this, null, true);
    }

    @Override
    public C0278jt mo711cg() {
        return abe.m2223();
    }
}
