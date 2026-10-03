package com.google.android.gms.common.api.internal;

final class zabn implements Runnable {
    final int zaa;
    final zabq zab;

    zabn(zabq zabqVar, int i) {
        this.zab = zabqVar;
        this.zaa = i;
    }

    @Override
    public final void run() {
        this.zab.zaI(this.zaa);
    }
}
