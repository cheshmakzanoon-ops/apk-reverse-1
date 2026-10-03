package com.google.android.gms.internal.games_v2;

import android.content.Intent;
import android.os.RemoteException;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.games.AchievementsClient;
import com.google.android.gms.games.AnnotatedData;
import com.google.android.gms.games.achievement.AchievementBuffer;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

public final class zzcj implements AchievementsClient {
    private final zzaq zza;

    public zzcj(zzaq zzaqVar) {
        this.zza = zzaqVar;
    }

    @Override
    public final Task<Intent> getAchievementsIntent() {
        return this.zza.zzb(zzch.zza);
    }

    @Override
    public final void increment(String str, int i) {
        this.zza.zzb(new zzca(str, i));
    }

    @Override
    public final Task<Boolean> incrementImmediate(String str, int i) {
        return this.zza.zzb(new zzca(str, i));
    }

    @Override
    public final Task<AnnotatedData<AchievementBuffer>> load(final boolean z) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final boolean z2 = z;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzB((TaskCompletionSource) obj2, z2);
                    }
                }).setMethodKey(6693).build());
            }
        });
    }

    @Override
    public final void reveal(String str) {
        this.zza.zzb(new zzby(str));
    }

    @Override
    public final Task<Void> revealImmediate(String str) {
        return this.zza.zzb(new zzby(str));
    }

    @Override
    public final void setSteps(String str, int i) {
        this.zza.zzb(new zzcb(str, i));
    }

    @Override
    public final Task<Boolean> setStepsImmediate(String str, int i) {
        return this.zza.zzb(new zzcb(str, i));
    }

    @Override
    public final void unlock(String str) {
        this.zza.zzb(new zzbz(str));
    }

    @Override
    public final Task<Void> unlockImmediate(String str) {
        return this.zza.zzb(new zzbz(str));
    }
}
