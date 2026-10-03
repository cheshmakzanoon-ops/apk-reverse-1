package com.google.android.material.card2;

public abstract class EnumC0019ae {

    private static final EnumC0019ae[] f28N;

    public static final EnumC0019ae f30P;

    private static final short[] f1419short = {2974, 2975, 2972, 2971, 2959, 2966, 2958, 1469, 1466, 1468, 1447, 1440, 1449};

    public static final EnumC0019ae f29O = new C0020af(adds.m2884(f1419short, 0, 7, 3034), 0);

    static {
        final int i = 1;
        final String strM9031 = C0448yd.m9031(f1419short, 7, 6, 1518);
        f30P = new EnumC0019ae(strM9031, i) {
            {
                C0020af c0020af = null;
            }
        };
        f28N = new EnumC0019ae[]{f29O, f30P};
    }

    private EnumC0019ae(String str, int i) {
        super(str, i);
    }

    EnumC0019ae(String str, int i, C0020af c0020af) {
        this(str, i);
    }

    public static EnumC0019ae valueOf(String str) {
        return (EnumC0019ae) Enum.valueOf(EnumC0019ae.class, str);
    }

    public static EnumC0019ae[] values() {
        return (EnumC0019ae[]) f28N.clone();
    }
}
