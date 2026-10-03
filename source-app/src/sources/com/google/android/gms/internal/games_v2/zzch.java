package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.tasks.Task;

final class zzch implements zzap {
    static final zzch zza = new zzch();

    private zzch() {
    }

    @Override
    public final Task zza(GoogleApi googleApi) {
        return googleApi.doRead(TaskApiCall.builder().run(zzci.zza).setMethodKey(6692).build());
    }
}
