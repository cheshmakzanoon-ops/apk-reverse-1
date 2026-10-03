package com.google.android.material.card2;

import javax.annotation.Nullable;

public final class C0305kt {

    @Nullable
    public final C0290ke f912ou;

    @Nullable
    public final C0286ka f913ov;

    C0305kt(C0286ka c0286ka, C0290ke c0290ke) {
        this.f913ov = c0286ka;
        this.f912ou = c0290ke;
    }

    public static boolean m970a(C0290ke c0290ke, C0286ka c0286ka) {
        switch (C0450yf.m9549(c0290ke)) {
            case 200:
            case 203:
            case 204:
            case 300:
            case 301:
            case 308:
            case 404:
            case 405:
            case 410:
            case 414:
            case 501:
                break;
            case 302:
            case 307:
                if (C0457zc.m10588(c0290ke, C0453yj.m10019()) == null && C0455za.m10158(gggy.m4455(c0290ke)) == -1 && !gggy.m4425(gggy.m4455(c0290ke)) && !C0447yc.m8639(gggy.m4455(c0290ke))) {
                    return false;
                }
                break;
            default:
                return false;
        }
        return (C0455za.m10174(gggy.m4455(c0290ke)) || C0455za.m10174(abd.m2085(c0286ka))) ? false : true;
    }
}
