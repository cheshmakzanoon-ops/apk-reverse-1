package com.google.android.gms.tasks;

import java.util.concurrent.CancellationException;

final class zzo implements Runnable {
    final Task zza;
    final zzp zzb;

    zzo(zzp zzpVar, Task task) {
        this.zzb = zzpVar;
        this.zza = task;
    }

    @Override
    public final void run() {
        try {
            Task taskThen = this.zzb.zzb.then(this.zza.getResult());
            if (taskThen == null) {
                this.zzb.onFailure(new NullPointerException("Continuation returned null"));
                return;
            }
            taskThen.addOnSuccessListener(TaskExecutors.zza, this.zzb);
            taskThen.addOnFailureListener(TaskExecutors.zza, this.zzb);
            taskThen.addOnCanceledListener(TaskExecutors.zza, this.zzb);
        } catch (RuntimeExecutionException e) {
            if (e.getCause() instanceof Exception) {
                this.zzb.onFailure((Exception) e.getCause());
            } else {
                this.zzb.onFailure(e);
            }
        } catch (CancellationException unused) {
            this.zzb.onCanceled();
        } catch (Exception e2) {
            this.zzb.onFailure(e2);
        }
    }
}
