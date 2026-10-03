package com.google.android.gms.common.util.concurrent;

import android.os.Handler;
import android.os.Looper;
import com.google.android.gms.internal.common.zzg;
import java.util.concurrent.Executor;

public class HandlerExecutor implements Executor {
    private final Handler zza;

    public HandlerExecutor(Looper looper) {
        this.zza = new zzg(looper);
    }

    @Override
    public final void execute(Runnable runnable) {
        this.zza.post(runnable);
    }
}
