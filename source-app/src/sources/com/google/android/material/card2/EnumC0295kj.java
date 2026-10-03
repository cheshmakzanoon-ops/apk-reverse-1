package com.google.android.material.card2;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public enum EnumC0295kj {
    f882nQ(C0457zc.m10560(f1429short, 7, 7, 1965)),
    f881nP(C0456zb.m10478(f1429short, 21, 7, 1802)),
    f880nO(C0457zc.m10560(f1429short, 35, 7, 646)),
    f879nN(abd.m2070(f1429short, 49, 5, 431)),
    f878nM(C0456zb.m10478(f1429short, 61, 5, 1656));


    private static final short[] f1429short = {2209, 2233, 2214, 2218, 2244, 2218, 2246, 2041, 2017, 2046, 2011, 1948, 1923, 1950, 1979, 1955, 1980, 1968, 2014, 1968, 2013, 1886, 1862, 1881, 1916, 1851, 1828, 1848, 1259, 1267, 1260, 1248, 1166, 1248, 1166, 722, 714, 725, 752, 695, 680, 695, 1420, 1428, 1419, 1415, 1513, 1415, 1512, 507, 483, 508, 473, 414, 3086, 3086, 3089, 3074, 3182, 3074, 3181, 1579, 1579, 1588, 1550, 1611, 2659, 2648, 2643, 2638, 2630, 2643, 2645, 2626, 2643, 2642, 2582, 2658, 2682, 2661, 2582, 2624, 2643, 2628, 2629, 2655, 2649, 2648, 2572, 2582, 474, 450, 477, 504, 447, 416, 445, 763, 739, 764, 729, 670, 641, 669, 1669, 1693, 1666, 1703, 1760, 1791, 1760, 1516, 1524, 1515, 1486, 1417, 1532, 1532, 1507, 1497, 1436};

    final String f883nR;

    EnumC0295kj(String str) {
        this.f883nR = str;
    }

    public static EnumC0295kj m925R(String str) {
        byte b = -1;
        switch (str.hashCode()) {
            case -503070503:
                if (str.equals(C0450yf.m9476(f1429short, 104, 7, 1745))) {
                    b = 2;
                }
                break;
            case -503070502:
                if (str.equals(abc.m1781(f1429short, 97, 7, 687))) {
                    b = 1;
                }
                break;
            case -503070501:
                if (str.equals(C0455za.m10121(f1429short, 90, 7, 398))) {
                    b = 0;
                }
                break;
            case 79201641:
                if (str.equals(C0445ya.m8198(f1429short, 116, 5, 1455))) {
                    b = 4;
                }
                break;
            case 79923350:
                if (str.equals(C0447yc.m8718(f1429short, 111, 5, 1464))) {
                    b = 3;
                }
                break;
        }
        switch (b) {
            case 0:
                return f882nQ;
            case 1:
                return f881nP;
            case 2:
                return f880nO;
            case 3:
                return f879nN;
            case 4:
                return f878nM;
            default:
                throw new IllegalArgumentException(C0447yc.m8718(f1429short, 66, 24, 2614) + str);
        }
    }

    static List<EnumC0295kj> m926a(String... strArr) {
        ArrayList arrayList = new ArrayList(strArr.length);
        for (String str : strArr) {
            arrayList.add(m925R(str));
        }
        return Collections.unmodifiableList(arrayList);
    }
}
