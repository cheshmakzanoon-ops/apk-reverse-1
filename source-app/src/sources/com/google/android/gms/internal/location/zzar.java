package com.google.android.gms.internal.location;

import com.google.android.gms.common.api.internal.ListenerHolder;
import com.google.android.gms.location.LocationAvailability;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationResult;

final class zzar extends com.google.android.gms.location.zzaz {
    private final ListenerHolder<LocationCallback> zza;

    zzar(ListenerHolder<LocationCallback> listenerHolder) {
        this.zza = listenerHolder;
    }

    public final synchronized void zzc() {
        this.zza.clear();
    }

    @Override
    public final void zzd(LocationResult locationResult) {
        this.zza.notifyListener(new zzap(this, locationResult));
    }

    @Override
    public final void zze(LocationAvailability locationAvailability) {
        this.zza.notifyListener(new zzaq(this, locationAvailability));
    }
}
