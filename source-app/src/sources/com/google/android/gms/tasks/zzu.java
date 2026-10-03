package com.google.android.gms.tasks;

import android.os.Handler;
import android.os.Looper;
import java.util.concurrent.Executor;

final class zzu implements Executor {
    private final Handler zza = new com.google.android.gms.internal.tasks.zza(Looper.getMainLooper());

    @Override
    public final void execute(Runnable runnable) {
        this.zza.post(runnable);
    }
}
