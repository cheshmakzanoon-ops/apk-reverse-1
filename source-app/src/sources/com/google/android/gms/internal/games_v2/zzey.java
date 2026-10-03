package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzey implements RemoteCall {
    static final zzey zza = new zzey();

    private zzey() {
    }

    @Override
    public final void accept(Object obj, Object obj2) {
        ((TaskCompletionSource) obj2).setResult(Integer.valueOf(((com.google.android.gms.games.internal.zzam) ((com.google.android.gms.games.internal.zzah) obj).getService()).zzG()));
    }
}
