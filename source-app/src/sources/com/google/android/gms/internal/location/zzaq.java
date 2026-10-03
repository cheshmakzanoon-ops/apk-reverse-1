package com.google.android.gms.internal.location;

import com.google.android.gms.common.api.internal.ListenerHolder;
import com.google.android.gms.location.LocationAvailability;
import com.google.android.gms.location.LocationCallback;

final class zzaq implements ListenerHolder.Notifier<LocationCallback> {
    final LocationAvailability zza;

    zzaq(zzar zzarVar, LocationAvailability locationAvailability) {
        this.zza = locationAvailability;
    }

    @Override
    public final void notifyListener(LocationCallback locationCallback) {
        locationCallback.onLocationAvailability(this.zza);
    }

    @Override
    public final void onNotifyListenerFailed() {
    }
}
