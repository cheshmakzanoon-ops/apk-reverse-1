package com.google.android.gms.internal.location;

import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.BaseImplementation;

final class zzy extends zzah {
    private final BaseImplementation.ResultHolder<Status> zza;

    public zzy(BaseImplementation.ResultHolder<Status> resultHolder) {
        this.zza = resultHolder;
    }

    @Override
    public final void zzb(zzaa zzaaVar) {
        this.zza.setResult(zzaaVar.getStatus());
    }

    @Override
    public final void zzc() {
    }
}
