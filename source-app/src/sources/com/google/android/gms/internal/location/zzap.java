package com.google.android.gms.internal.location;

import com.google.android.gms.common.api.internal.ListenerHolder;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationResult;

final class zzap implements ListenerHolder.Notifier<LocationCallback> {
    final LocationResult zza;

    zzap(zzar zzarVar, LocationResult locationResult) {
        this.zza = locationResult;
    }

    @Override
    public final void notifyListener(LocationCallback locationCallback) {
        locationCallback.onLocationResult(this.zza);
    }

    @Override
    public final void onNotifyListenerFailed() {
    }
}
