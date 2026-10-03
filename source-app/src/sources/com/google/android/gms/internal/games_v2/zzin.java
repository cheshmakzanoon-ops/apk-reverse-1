package com.google.android.gms.internal.games_v2;

import java.util.concurrent.Executor;

enum zzin implements Executor {
    INSTANCE;

    @Override
    public final void execute(Runnable runnable) {
        runnable.run();
    }

    @Override
    public final String toString() {
        return "MoreExecutors.directExecutor()";
    }
}
