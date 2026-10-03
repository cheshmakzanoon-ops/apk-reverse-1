package com.android.billingclient.api;

import android.content.Context;
import com.google.android.datatransport.Encoding;
import com.google.android.datatransport.Event;
import com.google.android.datatransport.Transformer;
import com.google.android.datatransport.Transport;
import com.google.android.datatransport.cct.CCTDestination;
import com.google.android.datatransport.runtime.TransportRuntime;
import com.google.android.gms.internal.play_billing.zzkh;

final class zzdn {
    private boolean zza;
    private Transport zzb;

    zzdn(Context context) {
        try {
            TransportRuntime.initialize(context);
            this.zzb = TransportRuntime.getInstance().newFactory(CCTDestination.INSTANCE).getTransport("PLAY_BILLING_LIBRARY", zzkh.class, Encoding.m1060of("proto"), new Transformer() {
                @Override
                public final Object apply(Object obj) {
                    return ((zzkh) obj).zzQ();
                }
            });
        } catch (Throwable unused) {
            this.zza = true;
        }
    }

    public final void zza(zzkh zzkhVar) {
        if (this.zza) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingLogger", "Skipping logging since initialization failed.");
            return;
        }
        try {
            this.zzb.send(Event.ofData(zzkhVar));
        } catch (Throwable unused) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingLogger", "logging failed.");
        }
    }
}
