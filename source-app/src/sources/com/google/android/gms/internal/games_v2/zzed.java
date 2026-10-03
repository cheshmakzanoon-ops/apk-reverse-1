package com.google.android.gms.internal.games_v2;

import android.os.RemoteException;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzed implements zzap {
    private final String zza;
    private final boolean zzb;

    zzed(String str, boolean z) {
        this.zza = str;
        this.zzb = z;
    }

    @Override
    public final Task zza(GoogleApi googleApi) {
        TaskApiCall.Builder builder = TaskApiCall.builder();
        final String str = this.zza;
        final boolean z = this.zzb;
        return googleApi.doRead(builder.run(new RemoteCall() {
            @Override
            public final void accept(Object obj, Object obj2) throws RemoteException {
                ((com.google.android.gms.games.internal.zzah) obj).zzs((TaskCompletionSource) obj2, str, z);
            }
        }).setMethodKey(6711).build());
    }
}
