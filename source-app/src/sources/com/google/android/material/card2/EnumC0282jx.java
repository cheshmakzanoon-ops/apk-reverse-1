package com.google.android.material.card2;

import java.io.IOException;

public enum EnumC0282jx {
    f796mV(C0458ze.m10915(f1428short, 8, 8, 651)),
    f797mW(C0457zc.m10560(f1428short, 24, 8, 736)),
    f799mY(C0459zf.m11207(f1428short, 38, 8, 2830)),
    f798mX(C0456zb.m10478(f1428short, 52, 2, 1641));


    private static final short[] f1428short = {1871, 1875, 1875, 1879, 1880, 1846, 1880, 1847, 739, 767, 767, 763, 676, 698, 677, 699, 1105, 1101, 1101, 1097, 1094, 1064, 1094, 1064, 648, 660, 660, 656, 719, 721, 718, 721, 1837, 1838, 1850, 1831, 1825, 1869, 2941, 2942, 2922, 2935, 2849, 2877, 2848, 2879, 3154, 3150, 3150, 3146, 3141, 3112, 1537, 1627, 3175, 3164, 3159, 3146, 3138, 3159, 3153, 3142, 3159, 3158, 3090, 3138, 3136, 3165, 3142, 3165, 3153, 3165, 3166, 3080, 3090};

    private final String f800mZ;

    EnumC0282jx(String str) {
        this.f800mZ = str;
    }

    public static EnumC0282jx m834M(String str) throws IOException {
        if (str.equals(f796mV.f800mZ)) {
            return f796mV;
        }
        if (str.equals(f797mW.f800mZ)) {
            return f797mW;
        }
        if (str.equals(f798mX.f800mZ)) {
            return f798mX;
        }
        if (str.equals(f799mY.f800mZ)) {
            return f799mY;
        }
        throw new IOException(C0456zb.m10478(f1428short, 54, 21, 3122) + str);
    }

    @Override
    public String toString() {
        return this.f800mZ;
    }
}
