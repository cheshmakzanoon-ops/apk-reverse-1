package com.google.android.gms.measurement.internal;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;
import java.util.concurrent.atomic.AtomicReference;

final class zzky implements Runnable {
    private final AtomicReference zza;
    private final zzo zzb;
    private final zzkp zzc;

    zzky(zzkp zzkpVar, AtomicReference atomicReference, zzo zzoVar) {
        this.zzc = zzkpVar;
        this.zza = atomicReference;
        this.zzb = zzoVar;
    }

    @Override
    public final void run() {
        synchronized (this.zza) {
            try {
                try {
                    if (!this.zzc.zzk().zzm().zzh()) {
                        this.zzc.zzj().zzv().zza("Analytics storage consent denied; will not get app instance id");
                        this.zzc.zzm().zza((String) null);
                        this.zzc.zzk().zze.zza(null);
                        this.zza.set(null);
                        this.zza.notify();
                        return;
                    }
                    zzfk zzfkVar = this.zzc.zzb;
                    if (zzfkVar == null) {
                        this.zzc.zzj().zzg().zza("Failed to get app instance id");
                        this.zza.notify();
                        return;
                    }
                    Preconditions.checkNotNull(this.zzb);
                    this.zza.set(zzfkVar.zzb(this.zzb));
                    String str = (String) this.zza.get();
                    if (str != null) {
                        this.zzc.zzm().zza(str);
                        this.zzc.zzk().zze.zza(str);
                    }
                    this.zzc.zzal();
                    this.zza.notify();
                } catch (RemoteException e) {
                    this.zzc.zzj().zzg().zza("Failed to get app instance id", e);
                    this.zza.notify();
                }
            } catch (Throwable th) {
                this.zza.notify();
                throw th;
            }
        }
    }
}
