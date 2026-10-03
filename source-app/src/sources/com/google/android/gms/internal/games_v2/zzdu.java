package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.tasks.Task;

final class zzdu implements zzap {
    static final zzdu zza = new zzdu();

    private zzdu() {
    }

    @Override
    public final Task zza(GoogleApi googleApi) {
        return googleApi.doRead(TaskApiCall.builder().run(zzea.zza).setMethodKey(6710).build());
    }
}
