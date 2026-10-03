package com.google.firebase.analytics.connector.internal;

import com.google.android.gms.measurement.api.AppMeasurementSdk;
import com.google.firebase.analytics.connector.AnalyticsConnector;
import java.util.Set;

public final class zzg implements zza {
    private AnalyticsConnector.AnalyticsConnectorListener zza;
    private AppMeasurementSdk zzb;
    private zzf zzc;

    @Override
    public final AnalyticsConnector.AnalyticsConnectorListener zza() {
        return this.zza;
    }

    @Override
    public final void zza(Set<String> set) {
    }

    @Override
    public final void zzb() {
    }

    public zzg(AppMeasurementSdk appMeasurementSdk, AnalyticsConnector.AnalyticsConnectorListener analyticsConnectorListener) {
        this.zza = analyticsConnectorListener;
        this.zzb = appMeasurementSdk;
        zzf zzfVar = new zzf(this);
        this.zzc = zzfVar;
        this.zzb.registerOnMeasurementEventListener(zzfVar);
    }
}
