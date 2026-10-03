package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.games.GamesStatusUtils;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzci implements RemoteCall {
    static final zzci zza = new zzci();

    private zzci() {
    }

    @Override
    public final void accept(Object obj, Object obj2) {
        TaskCompletionSource taskCompletionSource = (TaskCompletionSource) obj2;
        try {
            taskCompletionSource.setResult(((com.google.android.gms.games.internal.zzam) ((com.google.android.gms.games.internal.zzah) obj).getService()).zzw());
        } catch (SecurityException e) {
            GamesStatusUtils.zza(taskCompletionSource, e);
        }
    }
}
