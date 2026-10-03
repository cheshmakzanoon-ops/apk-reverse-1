package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzez implements RemoteCall {
    static final zzez zza = new zzez();

    private zzez() {
    }

    @Override
    public final void accept(Object obj, Object obj2) {
        ((TaskCompletionSource) obj2).setResult(Integer.valueOf(((com.google.android.gms.games.internal.zzam) ((com.google.android.gms.games.internal.zzah) obj).getService()).zzF()));
    }
}
