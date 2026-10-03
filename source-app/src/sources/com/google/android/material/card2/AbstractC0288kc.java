package com.google.android.material.card2;

import java.nio.charset.Charset;
import javax.annotation.Nullable;

public abstract class AbstractC0288kc {
    public static AbstractC0288kc m883a(@Nullable C0278jt c0278jt, String str) {
        C0278jt c0278jtM8204 = c0278jt;
        Charset charsetM1850 = abc.m1850();
        if (c0278jtM8204 != null && (charsetM1850 = C0445ya.m8347(c0278jtM8204)) == null) {
            charsetM1850 = abc.m1850();
            c0278jtM8204 = C0445ya.m8204(abc.m1925(C0460zg.m11407(abd.m2090(new StringBuilder(), c0278jtM8204), gggy.m4299())));
        }
        return C0449ye.m9174(c0278jtM8204, C0457zc.m10721(str, charsetM1850));
    }

    public static AbstractC0288kc m884a(@Nullable C0278jt c0278jt, byte[] bArr) {
        return C0450yf.m9566(c0278jt, bArr, 0, bArr.length);
    }

    public static AbstractC0288kc m885a(@Nullable C0278jt c0278jt, byte[] bArr, int i, int i2) {
        if (bArr == null) {
            throw new NullPointerException(C0460zg.m11321());
        }
        C0450yf.m9366(bArr.length, i, i2);
        return new C0289kd(c0278jt, i2, bArr, i);
    }

    public abstract void mo709a(InterfaceC0410op interfaceC0410op);

    public long mo710cf() {
        return -1L;
    }

    @Nullable
    public abstract C0278jt mo711cg();
}
