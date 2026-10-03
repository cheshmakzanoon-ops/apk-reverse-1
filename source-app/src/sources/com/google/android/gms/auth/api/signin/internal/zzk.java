package com.google.android.gms.auth.api.signin.internal;

import android.os.RemoteException;
import com.google.android.gms.common.api.Status;

final class zzk extends zzd {
    private final zzl zzcg;

    zzk(zzl zzlVar) {
        this.zzcg = zzlVar;
    }

    @Override
    public final void zze(Status status) throws RemoteException {
        this.zzcg.setResult(status);
    }
}
