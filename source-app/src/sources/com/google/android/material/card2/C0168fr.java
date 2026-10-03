package com.google.android.material.card2;

import android.graphics.Bitmap;

public class C0168fr extends C0169fs<String, Bitmap> {
    public C0168fr(int i) {
        super(i);
    }

    public static int m4038(Object obj, Object obj2, Object obj3) {
        if (C0456zb.m10326() <= 0) {
            return ((C0168fr) obj).m489a((String) obj2, (Bitmap) obj3);
        }
        return 0;
    }

    public static int m4039(Object obj, Object obj2, Object obj3) {
        if (abe.m2321() <= 0) {
            return m4038((C0168fr) obj, (String) obj2, (Bitmap) obj3);
        }
        return 0;
    }

    protected int m489a(String str, Bitmap bitmap) {
        return adds.m2898(bitmap) * C0459zf.m11037(bitmap);
    }

    @Override
    protected int mo490b(String str, Bitmap bitmap) {
        return C0448yd.m8877(this, str, bitmap);
    }
}
