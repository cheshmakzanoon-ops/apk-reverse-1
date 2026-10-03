package com.google.firebase.analytics.connector.internal;

import android.os.Bundle;
import com.google.android.gms.measurement.api.AppMeasurementSdk;

final class zzf implements AppMeasurementSdk.OnEventListener {
    private final zzg zza;

    public zzf(zzg zzgVar) {
        this.zza = zzgVar;
    }

    @Override
    public final void onEvent(String str, String str2, Bundle bundle, long j) {
        if (str == null || !zzb.zze(str2)) {
            return;
        }
        Bundle bundle2 = new Bundle();
        bundle2.putString(AppMeasurementSdk.ConditionalUserProperty.NAME, str2);
        bundle2.putLong("timestampInMillis", j);
        bundle2.putBundle("params", bundle);
        this.zza.zza.onMessageTriggered(3, bundle2);
    }
}
