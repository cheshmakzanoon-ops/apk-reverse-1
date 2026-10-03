package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzdf implements RemoteCall {
    static final zzdf zza = new zzdf();

    private zzdf() {
    }

    @Override
    public final void accept(Object obj, Object obj2) {
        ((TaskCompletionSource) obj2).setResult(((com.google.android.gms.games.internal.zzam) ((com.google.android.gms.games.internal.zzah) obj).getService()).zzv());
    }
}
