package com.unity3d.player;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.LayerDrawable;
import android.view.View;

public final class C1140o extends View {

    final int f470a;

    final int f471b;

    Bitmap f472c;

    Bitmap f473d;

    static class AnonymousClass1 {

        static final int[] f474a;

        static {
            int[] iArr = new int[a.m676a().length];
            f474a = iArr;
            try {
                iArr[a.f475a - 1] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                f474a[a.f476b - 1] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                f474a[a.f477c - 1] = 3;
            } catch (NoSuchFieldError unused3) {
            }
        }
    }

    static final class a {

        public static final int f475a = 1;

        public static final int f476b = 2;

        public static final int f477c = 3;

        private static final int[] f478d = {1, 2, 3};

        public static int[] m676a() {
            return (int[]) f478d.clone();
        }
    }

    public C1140o(Context context, int i) {
        super(context);
        this.f470a = i;
        int identifier = getResources().getIdentifier("unity_static_splash", "drawable", getContext().getPackageName());
        this.f471b = identifier;
        if (identifier != 0) {
            forceLayout();
        }
    }

    @Override
    public final void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        Bitmap bitmap = this.f472c;
        if (bitmap != null) {
            bitmap.recycle();
            this.f472c = null;
        }
        Bitmap bitmap2 = this.f473d;
        if (bitmap2 != null) {
            bitmap2.recycle();
            this.f473d = null;
        }
    }

    @Override
    public final void onLayout(boolean z, int i, int i2, int i3, int i4) {
        if (this.f471b == 0) {
            return;
        }
        if (this.f472c == null) {
            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inScaled = false;
            this.f472c = BitmapFactory.decodeResource(getResources(), this.f471b, options);
        }
        int width = this.f472c.getWidth();
        int height = this.f472c.getHeight();
        int width2 = getWidth();
        int height2 = getHeight();
        if (width2 == 0 || height2 == 0) {
            return;
        }
        float f = width / height;
        float f2 = width2;
        float f3 = height2;
        boolean z2 = f2 / f3 <= f;
        int[] iArr = AnonymousClass1.f474a;
        int i5 = this.f470a;
        int i6 = iArr[i5 - 1];
        if (i6 == 1) {
            if (width2 < width) {
                height = (int) (f2 / f);
                width = width2;
            }
            if (height2 < height) {
                width = (int) (f3 * f);
                height = height2;
            }
        } else if (i6 == 2 || i6 == 3) {
            if ((i5 == a.f477c) ^ z2) {
                height = (int) (f2 / f);
                width = width2;
            } else {
                width = (int) (f3 * f);
                height = height2;
            }
        }
        Bitmap bitmap = this.f473d;
        if (bitmap != null) {
            if (bitmap.getWidth() == width && this.f473d.getHeight() == height) {
                return;
            }
            Bitmap bitmap2 = this.f473d;
            if (bitmap2 != this.f472c) {
                bitmap2.recycle();
                this.f473d = null;
            }
        }
        Bitmap bitmapCreateScaledBitmap = Bitmap.createScaledBitmap(this.f472c, width, height, true);
        this.f473d = bitmapCreateScaledBitmap;
        bitmapCreateScaledBitmap.setDensity(getResources().getDisplayMetrics().densityDpi);
        ColorDrawable colorDrawable = new ColorDrawable(-16777216);
        BitmapDrawable bitmapDrawable = new BitmapDrawable(getResources(), this.f473d);
        bitmapDrawable.setGravity(17);
        setBackground(new LayerDrawable(new Drawable[]{colorDrawable, bitmapDrawable}));
    }
}
