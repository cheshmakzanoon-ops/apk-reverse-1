package com.google.android.gms.games.internal;

import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.BaseImplementation;
import com.google.android.gms.common.internal.BaseGmsClient;

final class zzl implements BaseImplementation.ResultHolder {
    final BaseGmsClient.SignOutCallbacks zza;

    zzl(BaseGmsClient.SignOutCallbacks signOutCallbacks) {
        this.zza = signOutCallbacks;
    }

    @Override
    public final void setFailedResult(Status status) {
        this.zza.onSignOutComplete();
    }

    @Override
    public final void setResult(Object obj) {
        this.zza.onSignOutComplete();
    }
}
