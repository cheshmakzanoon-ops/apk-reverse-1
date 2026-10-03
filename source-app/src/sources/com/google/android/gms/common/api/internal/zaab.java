package com.google.android.gms.common.api.internal;

import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.Status;

final class zaab implements PendingResult.StatusListener {
    final BasePendingResult zaa;
    final zaad zab;

    zaab(zaad zaadVar, BasePendingResult basePendingResult) {
        this.zab = zaadVar;
        this.zaa = basePendingResult;
    }

    @Override
    public final void onComplete(Status status) {
        this.zab.zaa.remove(this.zaa);
    }
}
