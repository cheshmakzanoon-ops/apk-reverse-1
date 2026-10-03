package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.tasks.Task;
import com.soundcloud.android.crop.Crop;

final class zzel implements zzap {
    static final zzel zza = new zzel();

    private zzel() {
    }

    @Override
    public final Task zza(GoogleApi googleApi) {
        return googleApi.doRead(TaskApiCall.builder().run(zzeb.zza).setMethodKey(Crop.REQUEST_CROP).build());
    }
}
