package com.google.android.gms.common.api.internal;

import android.app.Dialog;

final class zan extends zabw {
    final Dialog zaa;
    final zao zab;

    zan(zao zaoVar, Dialog dialog) {
        this.zab = zaoVar;
        this.zaa = dialog;
    }

    @Override
    public final void zaa() {
        this.zab.zaa.zad();
        if (this.zaa.isShowing()) {
            this.zaa.dismiss();
        }
    }
}
