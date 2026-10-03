package com.google.android.gms.internal.games_v2;

import android.os.RemoteException;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.games.AnnotatedData;
import com.google.android.gms.games.PlayerStatsClient;
import com.google.android.gms.games.stats.PlayerStats;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

public final class zzdt implements PlayerStatsClient {
    private final zzaq zza;

    public zzdt(zzaq zzaqVar) {
        this.zza = zzaqVar;
    }

    @Override
    public final Task<AnnotatedData<PlayerStats>> loadPlayerStats(final boolean z) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final boolean z2 = z;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzJ((TaskCompletionSource) obj2, z2);
                    }
                }).setMethodKey(6708).build());
            }
        });
    }
}
