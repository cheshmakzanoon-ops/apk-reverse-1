package com.google.android.gms.common.internal;

import android.app.PendingIntent;
import android.os.Bundle;
import com.google.android.gms.common.ConnectionResult;

abstract class zza extends zzc {
    public final int zza;
    public final Bundle zzb;
    final BaseGmsClient zzc;

    protected zza(BaseGmsClient baseGmsClient, int i, Bundle bundle) {
        super(baseGmsClient, true);
        j$.util.Objects.requireNonNull(baseGmsClient);
        this.zzc = baseGmsClient;
        this.zza = i;
        this.zzb = bundle;
    }

    protected abstract boolean zza();

    protected abstract void zzb(ConnectionResult connectionResult);

    @Override
    protected final void zzc(Object obj) {
        int i = this.zza;
        if (i != 0) {
            this.zzc.zzd(1, null);
            Bundle bundle = this.zzb;
            zzb(new ConnectionResult(i, bundle != null ? (PendingIntent) bundle.getParcelable(BaseGmsClient.KEY_PENDING_INTENT) : null));
        } else {
            if (zza()) {
                return;
            }
            this.zzc.zzd(1, null);
            zzb(new ConnectionResult(8, null));
        }
    }
}
