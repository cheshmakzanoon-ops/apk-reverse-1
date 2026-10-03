package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzbc {
    private final zzav zza;
    private final TaskCompletionSource zzb;

    public zzbc(zzav zzavVar, TaskCompletionSource taskCompletionSource) {
        this.zza = zzavVar;
        this.zzb = taskCompletionSource;
    }

    public final void zza(GoogleApi googleApi) {
        this.zza.zza(googleApi).addOnCompleteListener(zzio.zza(), new OnCompleteListener() {
            @Override
            public final void onComplete(Task task) {
                this.zza.zzc(task);
            }
        });
    }

    public final void zzb(Exception exc) {
        this.zzb.setException(exc);
    }

    final void zzc(Task task) {
        if (task.isSuccessful()) {
            this.zzb.setResult(task.getResult());
            return;
        }
        TaskCompletionSource taskCompletionSource = this.zzb;
        Exception exception = task.getException();
        zzfw.zza(exception);
        taskCompletionSource.setException(exception);
    }
}
