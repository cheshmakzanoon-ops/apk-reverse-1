package com.google.android.gms.internal.base;

import android.graphics.drawable.Drawable;

final class zaj extends Drawable.ConstantState {
    int zaa;
    int zab;

    zaj(zaj zajVar) {
        if (zajVar != null) {
            this.zaa = zajVar.zaa;
            this.zab = zajVar.zab;
        }
    }

    @Override
    public final int getChangingConfigurations() {
        return this.zaa;
    }

    @Override
    public final Drawable newDrawable() {
        return new zak(this);
    }
}
