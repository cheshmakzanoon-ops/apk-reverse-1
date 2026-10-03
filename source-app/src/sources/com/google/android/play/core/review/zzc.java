package com.google.android.play.core.review;

import android.os.Bundle;
import android.os.Handler;
import android.os.ResultReceiver;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzc extends ResultReceiver {
    final TaskCompletionSource zza;

    zzc(zzd zzdVar, Handler handler, TaskCompletionSource taskCompletionSource) {
        super(handler);
        this.zza = taskCompletionSource;
    }

    @Override
    public final void onReceiveResult(int i, Bundle bundle) {
        this.zza.trySetResult(null);
    }
}
