package com.android.billingclient.api;

import android.content.ComponentName;
import android.content.ServiceConnection;
import android.os.IBinder;
import j$.util.Objects;

final class zzcu implements ServiceConnection {
    final zzcw zza;

    zzcu(zzcw zzcwVar, zzcv zzcvVar) {
        Objects.requireNonNull(zzcwVar);
        this.zza = zzcwVar;
    }

    @Override
    public final void onServiceConnected(ComponentName componentName, IBinder iBinder) {
        com.google.android.gms.internal.play_billing.zzc.zzn("BillingClientTesting", "Billing Override Service connected.");
        zzcw zzcwVar = this.zza;
        zzcwVar.zzc = com.google.android.gms.internal.play_billing.zzax.zzb(iBinder);
        zzcwVar.zzb = 2;
        zzcwVar.zzaO(26);
    }

    @Override
    public final void onServiceDisconnected(ComponentName componentName) {
        com.google.android.gms.internal.play_billing.zzc.zzo("BillingClientTesting", "Billing Override Service disconnected.");
        zzcw zzcwVar = this.zza;
        zzcwVar.zzc = null;
        zzcwVar.zzb = 0;
    }
}
