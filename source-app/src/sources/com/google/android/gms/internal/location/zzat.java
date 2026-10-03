package com.google.android.gms.internal.location;

import android.location.Location;
import com.google.android.gms.common.api.internal.ListenerHolder;
import com.google.android.gms.location.LocationListener;

final class zzat implements ListenerHolder.Notifier<LocationListener> {
    final Location zza;

    zzat(zzau zzauVar, Location location) {
        this.zza = location;
    }

    @Override
    public final void notifyListener(LocationListener locationListener) {
        locationListener.onLocationChanged(this.zza);
    }

    @Override
    public final void onNotifyListenerFailed() {
    }
}
