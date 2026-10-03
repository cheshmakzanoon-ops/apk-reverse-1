package com.google.android.material.card2;

import javax.annotation.Nullable;

public final class C0330lr extends AbstractC0292kg {

    private final long f1020qu;

    @Nullable
    private final String f1021qv;

    private final InterfaceC0411oq f1022qw;

    public C0330lr(@Nullable String str, long j, InterfaceC0411oq interfaceC0411oq) {
        this.f1021qv = str;
        this.f1020qu = j;
        this.f1022qw = interfaceC0411oq;
    }

    public static long m6156(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0330lr) obj).f1020qu;
        }
        return 0L;
    }

    public static InterfaceC0411oq m6157(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0330lr) obj).f1022qw;
        }
        return null;
    }

    public static int m6158() {
        if (abd.m2162() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static String m6159(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0330lr) obj).f1021qv;
        }
        return null;
    }

    public static String m6160(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m6159((C0330lr) obj);
        }
        return null;
    }

    public static InterfaceC0411oq m6161(Object obj) {
        if (m6158() >= 0) {
            return m6157((C0330lr) obj);
        }
        return null;
    }

    public static long m6162(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m6156((C0330lr) obj);
        }
        return 0L;
    }

    @Override
    public long mo917cf() {
        return C0447yc.m8778(this);
    }

    @Override
    public C0278jt mo918cg() {
        if (C0459zf.m11158(this) != null) {
            return C0445ya.m8204(C0459zf.m11158(this));
        }
        return null;
    }

    @Override
    public InterfaceC0411oq mo919dt() {
        return C0455za.m10264(this);
    }
}
