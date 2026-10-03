package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzea implements RemoteCall {
    static final zzea zza = new zzea();

    private zzea() {
    }

    @Override
    public final void accept(Object obj, Object obj2) {
        ((TaskCompletionSource) obj2).setResult(((com.google.android.gms.games.internal.zzah) obj).zzq());
    }
}
