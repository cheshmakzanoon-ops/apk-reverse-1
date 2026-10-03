package com.google.android.material.card2;

import java.lang.reflect.Field;
import java.util.Locale;

public abstract class EnumC0069c implements InterfaceC0258j {

    private static final EnumC0069c[] f108b;

    public static final EnumC0069c f110d;

    public static final EnumC0069c f111e;

    public static final EnumC0069c f112f;

    public static final EnumC0069c f113g;

    public static final EnumC0069c f114h;

    private static final short[] f1420short = {770, 783, 782, 773, 799, 770, 799, 786, 1324, 1321, 1321, 1340, 1323, 1318, 1338, 1336, 1332, 1340, 1333, 1318, 1338, 1336, 1322, 1340, 267, 270, 270, 283, 268, 257, 285, 287, 275, 283, 274, 257, 285, 287, 269, 283, 257, 265, 279, 266, 278, 257, 269, 270, 287, 285, 283, 269, 1093, 1094, 1118, 1100, 1115, 1110, 1098, 1096, 1114, 1100, 1110, 1118, 1088, 1117, 1089, 1110, 1116, 1095, 1101, 1100, 1115, 1114, 1098, 1094, 1115, 1100, 1114, 1874, 1873, 1865, 1883, 1868, 1857, 1885, 1887, 1869, 1883, 1857, 1865, 1879, 1866, 1878, 1857, 1882, 1887, 1869, 1878, 1883, 1869, 528, 531, 523, 537, 526, 515, 543, 541, 527, 537, 515, 523, 533, 520, 532, 515, 536, 531, 520, 527};

    public static final EnumC0069c f109c = new C0096d(C0447yc.m8718(f1420short, 0, 8, 843), 0);

    static {
        final int i = 4;
        final int i2 = 3;
        final int i3 = 2;
        final int i4 = 1;
        final String strM1781 = abc.m1781(f1420short, 8, 16, 1401);
        f113g = new EnumC0069c(strM1781, i4) {
            {
                C0096d c0096d = null;
            }

            @Override
            public String mo382a(Field field) {
                return m326a(field.getName());
            }
        };
        final String strM9924 = C0453yj.m9924(f1420short, 24, 28, 350);
        f114h = new EnumC0069c(strM9924, i3) {

            private static final short[] f1421short = {2847};

            {
                C0096d c0096d = null;
            }

            @Override
            public String mo382a(Field field) {
                return m326a(m327a(field.getName(), C0455za.m10121(f1421short, 0, 1, 2879)));
            }
        };
        final String strM9579 = C0451yg.m9579(f1420short, 52, 27, 1033);
        f112f = new EnumC0069c(strM9579, i2) {

            private static final short[] f1423short = {566};

            {
                C0096d c0096d = null;
            }

            @Override
            public String mo382a(Field field) {
                return m327a(field.getName(), C0455za.m10121(f1423short, 0, 1, 617)).toLowerCase(Locale.ENGLISH);
            }
        };
        final String strM8463 = C0446yb.m8463(f1420short, 79, 22, 1822);
        f110d = new EnumC0069c(strM8463, i) {

            private static final short[] f1425short = {2756};

            {
                C0096d c0096d = null;
            }

            @Override
            public String mo382a(Field field) {
                return m327a(field.getName(), abd.m2070(f1425short, 0, 1, 2793)).toLowerCase(Locale.ENGLISH);
            }
        };
        final String strM8464 = C0446yb.m8463(f1420short, 101, 20, 604);
        final int i5 = 5;
        f111e = new EnumC0069c(strM8464, i5) {

            private static final short[] f1426short = {2301};

            {
                C0096d c0096d = null;
            }

            @Override
            public String mo382a(Field field) {
                return m327a(field.getName(), abc.m1781(f1426short, 0, 1, 2259)).toLowerCase(Locale.ENGLISH);
            }
        };
        f108b = new EnumC0069c[]{f109c, f113g, f114h, f112f, f110d, f111e};
    }

    private EnumC0069c(String str, int i) {
        super(str, i);
    }

    EnumC0069c(String str, int i, C0096d c0096d) {
        this(str, i);
    }

    static String m326a(String str) {
        int length = str.length();
        int i = 0;
        while (!Character.isLetter(str.charAt(i)) && i < length - 1) {
            i++;
        }
        char cCharAt = str.charAt(i);
        if (Character.isUpperCase(cCharAt)) {
            return str;
        }
        char upperCase = Character.toUpperCase(cCharAt);
        return i == 0 ? upperCase + str.substring(1) : str.substring(0, i) + upperCase + str.substring(i + 1);
    }

    static String m327a(String str, String str2) {
        StringBuilder sb = new StringBuilder();
        int length = str.length();
        for (int i = 0; i < length; i++) {
            char cCharAt = str.charAt(i);
            if (Character.isUpperCase(cCharAt) && sb.length() != 0) {
                sb.append(str2);
            }
            sb.append(cCharAt);
        }
        return sb.toString();
    }

    public static EnumC0069c valueOf(String str) {
        return (EnumC0069c) Enum.valueOf(EnumC0069c.class, str);
    }

    public static EnumC0069c[] values() {
        return (EnumC0069c[]) f108b.clone();
    }
}
