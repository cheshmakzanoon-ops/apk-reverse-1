package com.google.android.gms.games.internal.p000v2.resolution;

import android.content.Intent;
import android.os.Bundle;
import android.os.Looper;
import android.os.ResultReceiver;
import com.google.android.gms.internal.games_v2.zzfr;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zza extends ResultReceiver {
    private final TaskCompletionSource zza;

    public zza() {
        super(new zzfr(Looper.getMainLooper()));
        this.zza = new TaskCompletionSource();
    }

    @Override
    protected final void onReceiveResult(int i, Bundle bundle) {
        Intent intent;
        super.onReceiveResult(i, bundle);
        boolean z = i == -1;
        Boolean boolValueOf = Boolean.valueOf(z);
        if (bundle == null || (intent = (Intent) bundle.getParcelable("resultData")) == null) {
            intent = new Intent();
        }
        boolValueOf.getClass();
        this.zza.trySetResult(z ? zzc.zza(intent) : zzc.zzb(intent));
    }

    public final Task zza() {
        return this.zza.getTask();
    }
}
