package com.google.android.gms.games.internal;

import com.google.android.gms.common.api.internal.BaseImplementation;
import com.google.android.gms.common.internal.Preconditions;

class zzae extends zza {
    private final BaseImplementation.ResultHolder zza;

    zzae(BaseImplementation.ResultHolder resultHolder) {
        this.zza = (BaseImplementation.ResultHolder) Preconditions.checkNotNull(resultHolder, "Holder must not be null");
    }

    final void zzt(Object obj) {
        this.zza.setResult(obj);
    }
}
