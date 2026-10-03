package com.google.android.gms.internal.measurement;

import android.os.Bundle;
import java.util.concurrent.atomic.AtomicReference;

public final class zzcs extends zzcy {
    private final AtomicReference<Bundle> zza = new AtomicReference<>();
    private boolean zzb;

    public final Bundle zza(long j) {
        Bundle bundle;
        synchronized (this.zza) {
            if (!this.zzb) {
                try {
                    this.zza.wait(j);
                } catch (InterruptedException unused) {
                    return null;
                }
            }
            bundle = this.zza.get();
        }
        return bundle;
    }

    public final Long zzb(long j) {
        return (Long) zza(zza(j), Long.class);
    }

    public static <T> T zza(android.os.Bundle r3, java.lang.Class<T> r4) {
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.gms.internal.measurement.zzcs.zza(android.os.Bundle, java.lang.Class):java.lang.Object");
    }

    public final String zzc(long j) {
        return (String) zza(zza(j), String.class);
    }

    @Override
    public final void zza(Bundle bundle) {
        synchronized (this.zza) {
            try {
                this.zza.set(bundle);
                this.zzb = true;
                this.zza.notify();
            } catch (Throwable th) {
                this.zza.notify();
                throw th;
            }
        }
    }
}
