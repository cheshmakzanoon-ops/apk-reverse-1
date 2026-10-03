package com.google.android.gms.internal.location;

import android.app.PendingIntent;
import android.os.RemoteException;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationRequest;

final class zzu extends zzx {
    final LocationRequest zza;
    final PendingIntent zzb;

    zzu(zzz zzzVar, GoogleApiClient googleApiClient, LocationRequest locationRequest, PendingIntent pendingIntent) {
        super(googleApiClient);
        this.zza = locationRequest;
        this.zzb = pendingIntent;
    }

    @Override
    protected final void doExecute(Api.AnyClient anyClient) throws RemoteException {
        ((zzaz) anyClient).zzE(this.zza, this.zzb, new zzy(this));
    }
}
