package com.google.android.gms.location;

import com.google.android.gms.tasks.TaskCompletionSource;

final class zzaj extends LocationCallback {
    final TaskCompletionSource zza;
    final FusedLocationProviderClient zzb;

    zzaj(FusedLocationProviderClient fusedLocationProviderClient, TaskCompletionSource taskCompletionSource) {
        this.zzb = fusedLocationProviderClient;
        this.zza = taskCompletionSource;
    }

    @Override
    public final void onLocationAvailability(LocationAvailability locationAvailability) {
    }

    @Override
    public final void onLocationResult(LocationResult locationResult) {
        this.zza.trySetResult(locationResult.getLastLocation());
        this.zzb.removeLocationUpdates(this);
    }
}
