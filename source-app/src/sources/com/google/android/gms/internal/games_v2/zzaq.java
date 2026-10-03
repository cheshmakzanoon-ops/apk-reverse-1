package com.google.android.gms.internal.games_v2;

import android.app.Application;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.tasks.Task;
import j$.util.Objects;

public final class zzaq {
    private final zzaw zza;

    private zzaq(zzaw zzawVar) {
        this.zza = zzawVar;
    }

    public static zzaq zza(Application application) {
        return new zzaq(zzay.zza(application));
    }

    public final Task zzb(final zzap zzapVar) {
        Objects.requireNonNull(zzapVar);
        return this.zza.zza(new zzav() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                return zzapVar.zza(googleApi);
            }
        });
    }
}
