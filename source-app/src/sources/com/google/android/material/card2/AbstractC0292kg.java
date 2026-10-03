package com.google.android.material.card2;

import java.io.Closeable;
import java.nio.charset.Charset;
import javax.annotation.Nullable;

public abstract class AbstractC0292kg implements Closeable {
    public static AbstractC0292kg m914a(@Nullable C0278jt c0278jt, long j, InterfaceC0411oq interfaceC0411oq) {
        if (interfaceC0411oq == null) {
            throw new NullPointerException(gggy.m4409());
        }
        return new C0293kh(c0278jt, j, interfaceC0411oq);
    }

    public static AbstractC0292kg m915b(@Nullable C0278jt c0278jt, byte[] bArr) {
        return C0460zg.m11411(c0278jt, bArr.length, C0453yj.m9824(new C0409oo(), bArr));
    }

    private Charset m916cJ() {
        C0278jt c0278jtM9238 = C0449ye.m9238(this);
        return c0278jtM9238 != null ? C0460zg.m11390(c0278jtM9238, abc.m1850()) : abc.m1850();
    }

    public static Charset m5727(Object obj) {
        if (C0458ze.m10932() > 0) {
            return ((AbstractC0292kg) obj).m916cJ();
        }
        return null;
    }

    public static int m5728() {
        if (C0449ye.m9220() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static Charset m5729(Object obj) {
        if (m5728() > 0) {
            return m5727((AbstractC0292kg) obj);
        }
        return null;
    }

    public abstract long mo917cf();

    @Nullable
    public abstract C0278jt mo918cg();

    @Override
    public void close() {
        C0455za.m10070(C0455za.m10183(this));
    }

    public abstract InterfaceC0411oq mo919dt();

    public final String m920du() {
        InterfaceC0411oq interfaceC0411oqM10183 = C0455za.m10183(this);
        try {
            return C0456zb.m10327(interfaceC0411oqM10183, C0457zc.m10580(interfaceC0411oqM10183, C0452yh.m9756(this)));
        } finally {
            C0455za.m10070(interfaceC0411oqM10183);
        }
    }
}
