package com.google.android.gms.tasks;

final class zzs implements OnTokenCanceledListener {
    final TaskCompletionSource zza;

    zzs(TaskCompletionSource taskCompletionSource) {
        this.zza = taskCompletionSource;
    }

    @Override
    public final void onCanceled() {
        this.zza.zza.zzc();
    }
}
