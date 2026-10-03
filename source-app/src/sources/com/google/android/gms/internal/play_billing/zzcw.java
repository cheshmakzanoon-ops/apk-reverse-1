package com.google.android.gms.internal.play_billing;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

final class zzcw implements Runnable {
    final Future zza;
    final zzcv zzb;

    zzcw(Future future, zzcv zzcvVar) {
        this.zza = future;
        this.zzb = zzcvVar;
    }

    @Override
    public final void run() {
        Object obj;
        Throwable thZza;
        Future future = this.zza;
        if ((future instanceof zzdi) && (thZza = zzdj.zza((zzdi) future)) != null) {
            this.zzb.zza(thZza);
            return;
        }
        try {
            boolean zIsDone = future.isDone();
            boolean z = false;
            Future future2 = future;
            if (!zIsDone) {
                throw new IllegalStateException(zzbm.zzb("Future was expected to be done: %s", future));
            }
            while (true) {
                try {
                    obj = future2.get();
                    break;
                } catch (InterruptedException unused) {
                    z = true;
                    future2 = future2;
                } catch (Throwable th) {
                    if (z) {
                        Thread.currentThread().interrupt();
                    }
                    throw th;
                }
            }
            if (z) {
                Thread.currentThread().interrupt();
            }
            this.zzb.zzb(obj);
        } catch (ExecutionException e) {
            this.zzb.zza(e.getCause());
        } catch (Throwable th2) {
            this.zzb.zza(th2);
        }
    }

    public final String toString() {
        zzbf zzbfVarZza = zzbh.zza(this);
        zzbfVarZza.zza(this.zzb);
        return zzbfVarZza.toString();
    }
}
