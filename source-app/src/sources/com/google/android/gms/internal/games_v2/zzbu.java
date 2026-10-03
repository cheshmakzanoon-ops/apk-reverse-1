package com.google.android.gms.internal.games_v2;

import android.app.Activity;
import android.app.Application;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.wrappers.InstantApps;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzbu implements zzbr {
    private final Application zza;
    private final com.google.android.gms.games.internal.zzf zzb;
    private final zzax zzc;

    zzbu(Application application, com.google.android.gms.games.internal.zzf zzfVar, zzax zzaxVar) {
        this.zza = application;
        this.zzb = zzfVar;
        this.zzc = zzaxVar;
    }

    private final zzk zzc() {
        Activity activityZzd = this.zzb.zzd();
        if (activityZzd != null) {
            return zzj.zza(activityZzd, this.zzc.zzb);
        }
        zzax zzaxVar = this.zzc;
        return zzj.zza(zzaxVar.zza, zzaxVar.zzb);
    }

    @Override
    public final Task zza(final zzq zzqVar) {
        final boolean z = false;
        if (zzqVar.zzc() == 0 && !InstantApps.isInstantApp(this.zza)) {
            z = true;
        }
        Task taskZza = zzc().zza(zzqVar, z);
        final TaskCompletionSource taskCompletionSource = new TaskCompletionSource();
        taskZza.continueWithTask(zzio.zza(), new Continuation() {
            @Override
            public final Object then(Task task) {
                return this.zza.zzb(zzqVar, z, task);
            }
        }).addOnCompleteListener(zzio.zza(), new OnCompleteListener() {
            @Override
            public final void onComplete(Task task) {
                TaskCompletionSource taskCompletionSource2 = taskCompletionSource;
                if (task.isSuccessful()) {
                    taskCompletionSource2.trySetResult(zzbv.zza(((zzs) task.getResult()).zza()));
                    return;
                }
                Exception exception = task.getException();
                if (exception instanceof ApiException) {
                    taskCompletionSource2.trySetResult(zzbv.zzb(((ApiException) exception).getStatus()));
                } else {
                    zzfw.zza(exception);
                    taskCompletionSource2.trySetException(exception);
                }
            }
        });
        return taskCompletionSource.getTask();
    }

    final Task zzb(zzq zzqVar, boolean z, Task task) {
        if (!task.isSuccessful()) {
            Exception exception = task.getException();
            if ((exception instanceof ApiException) && ((ApiException) exception).getStatusCode() == 20) {
                zzfn.zza("GamesAuthenticator", "Service connection suspended during the first sign-in attempt. Trying again.");
                return zzc().zza(zzqVar, z);
            }
        }
        return task;
    }
}
