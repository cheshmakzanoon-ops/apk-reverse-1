package com.google.android.material.card2;

import java.net.ProtocolException;

public final class C0333lu {

    public final String f1028qA;

    public final EnumC0282jx f1029qB;

    public final int f1030qz;

    public C0333lu(EnumC0282jx enumC0282jx, int i, String str) {
        this.f1029qB = enumC0282jx;
        this.f1030qz = i;
        this.f1028qA = str;
    }

    public static C0333lu m1084ae(String str) throws ProtocolException {
        EnumC0282jx enumC0282jxM2783;
        String strM1972;
        int i = 9;
        if (C0458ze.m10811(str, abe.m2341())) {
            if (gggy.m4397(str) < 9 || C0446yb.m8419(str, 8) != ' ') {
                throw new ProtocolException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2538()), str)));
            }
            int iM8419 = C0446yb.m8419(str, 7) - '0';
            if (iM8419 == 0) {
                enumC0282jxM2783 = adds.m2783();
            } else {
                if (iM8419 != 1) {
                    throw new ProtocolException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2538()), str)));
                }
                enumC0282jxM2783 = C0459zf.m11198();
            }
        } else {
            if (!C0458ze.m10811(str, C0446yb.m8516())) {
                throw new ProtocolException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2538()), str)));
            }
            enumC0282jxM2783 = adds.m2783();
            i = 4;
        }
        if (gggy.m4397(str) < i + 3) {
            throw new ProtocolException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2538()), str)));
        }
        try {
            int iM8889 = C0448yd.m8889(C0447yc.m8745(str, i, i + 3));
            String strM4277 = gggy.m4277();
            if (gggy.m4397(str) <= i + 3) {
                strM1972 = strM4277;
            } else {
                if (C0446yb.m8419(str, i + 3) != ' ') {
                    throw new ProtocolException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2538()), str)));
                }
                strM1972 = abc.m1972(str, i + 4);
            }
            return new C0333lu(enumC0282jxM2783, iM8889, strM1972);
        } catch (NumberFormatException e) {
            throw new ProtocolException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2538()), str)));
        }
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        C0460zg.m11407(sb, C0458ze.m10974(this) == adds.m2783() ? adds.m2749() : C0456zb.m10302());
        adds.m2680(abe.m2346(sb, ' '), C0453yj.m9911(this));
        if (C0447yc.m8616(this) != null) {
            C0460zg.m11407(abe.m2346(sb, ' '), C0447yc.m8616(this));
        }
        return abc.m1925(sb);
    }
}
