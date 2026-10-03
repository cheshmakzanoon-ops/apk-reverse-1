package com.google.android.gms.internal.base;

import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.drawable.Drawable;

final class zai extends Drawable {
    private static final zai zaa = new zai();
    private static final zah zab = new zah(null);

    private zai() {
    }

    @Override
    public final void draw(Canvas canvas) {
    }

    @Override
    public final Drawable.ConstantState getConstantState() {
        return zab;
    }

    @Override
    public final int getOpacity() {
        return -2;
    }

    @Override
    public final void setAlpha(int i) {
    }

    @Override
    public final void setColorFilter(ColorFilter colorFilter) {
    }
}
