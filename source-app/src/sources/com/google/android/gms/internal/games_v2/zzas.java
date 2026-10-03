package com.google.android.gms.internal.games_v2;

import android.app.Application;
import androidx.compose.animation.core.ComplexDouble$;
import com.google.android.gms.common.internal.Preconditions;
import java.util.concurrent.atomic.AtomicReference;

public final class zzas {
    private static final AtomicReference zza = new AtomicReference();
    private final zzar zzb;
    private final zzaw zzc;

    zzas(Application application, zzaw zzawVar) {
        this.zzb = new zzar(this, application, null);
        this.zzc = zzawVar;
    }

    static zzas zza(Application application) {
        AtomicReference atomicReference = zza;
        zzas zzasVar = (zzas) atomicReference.get();
        if (zzasVar != null) {
            return zzasVar;
        }
        ComplexDouble$.ExternalSyntheticBackport0.m(atomicReference, (Object) null, new zzas(application, zzay.zza(application)));
        return (zzas) Preconditions.checkNotNull((zzas) atomicReference.get());
    }

    public final void zzb() {
        zzfn.zza("AutomaticGamesAuthenticator", "startWatching()");
        this.zzb.zza();
    }

    final zzaw zzc() {
        return this.zzc;
    }
}
