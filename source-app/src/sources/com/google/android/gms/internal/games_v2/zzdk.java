package com.google.android.gms.internal.games_v2;

import android.os.RemoteException;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzdk implements zzap {
    private final String zza;
    private final int zzb;
    private final int zzc;
    private final int zzd;
    private final boolean zze;

    zzdk(String str, int i, int i2, int i3, boolean z) {
        this.zza = str;
        this.zzb = i;
        this.zzc = i2;
        this.zzd = i3;
        this.zze = z;
    }

    @Override
    public final Task zza(GoogleApi googleApi) {
        TaskApiCall.Builder builder = TaskApiCall.builder();
        final String str = this.zza;
        final int i = this.zzb;
        final int i2 = this.zzc;
        final int i3 = this.zzd;
        final boolean z = this.zze;
        return googleApi.doRead(builder.run(new RemoteCall() {
            @Override
            public final void accept(Object obj, Object obj2) throws RemoteException {
                ((com.google.android.gms.games.internal.zzah) obj).zzy((TaskCompletionSource) obj2, str, i, i2, i3, z);
            }
        }).setMethodKey(6705).build());
    }
}
