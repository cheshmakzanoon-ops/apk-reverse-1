package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzee implements zzap {
    private final String zza;
    private final String zzb;
    private final String zzc;

    zzee(String str, String str2, String str3) {
        this.zza = str;
        this.zzb = str2;
        this.zzc = str3;
    }

    @Override
    public final Task zza(GoogleApi googleApi) {
        TaskApiCall.Builder builder = TaskApiCall.builder();
        final String str = this.zza;
        final String str2 = this.zzb;
        final String str3 = this.zzc;
        return googleApi.doRead(builder.run(new RemoteCall() {
            @Override
            public final void accept(Object obj, Object obj2) {
                ((TaskCompletionSource) obj2).setResult(((com.google.android.gms.games.internal.zzam) ((com.google.android.gms.games.internal.zzah) obj).getService()).zzR(str, str2, str3));
            }
        }).setMethodKey(6712).build());
    }
}
