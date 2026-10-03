package com.android.billingclient.api;

import androidx.core.util.Consumer;
import com.google.android.gms.internal.play_billing.zzjd;
import j$.util.Objects;
import java.util.concurrent.TimeoutException;

final class zzcs implements com.google.android.gms.internal.play_billing.zzcv {
    final Consumer zza;
    final Runnable zzb;
    final zzcw zzc;
    final int zzd;

    zzcs(zzcw zzcwVar, int i, Consumer consumer, Runnable runnable) {
        this.zzd = i;
        this.zza = consumer;
        this.zzb = runnable;
        Objects.requireNonNull(zzcwVar);
        this.zzc = zzcwVar;
    }

    public final void zza(Throwable th) {
        if (th instanceof TimeoutException) {
            this.zzc.zzaN(zzjd.zzaX, 28, zzdc.zzE);
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClientTesting", "Asynchronous call to Billing Override Service timed out.", th);
        } else {
            this.zzc.zzaN(zzjd.zzaQ, 28, zzdc.zzE);
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClientTesting", "An error occurred while retrieving billing override.", th);
        }
        this.zzb.run();
    }

    public final void zzb(Object obj) {
        Integer num = (Integer) obj;
        int iIntValue = num.intValue();
        zzcw zzcwVar = this.zzc;
        if (!zzcw.zzaK(iIntValue)) {
            this.zzb.run();
        } else {
            this.zza.accept(zzcwVar.zzaL(this.zzd, num.intValue()));
        }
    }
}
