package com.google.android.gms.internal.games_v2;

import androidx.compose.animation.core.ComplexDouble$;
import java.util.concurrent.atomic.AtomicReference;

public abstract class zzac {
    private final AtomicReference zza = new AtomicReference();

    protected abstract zzab zza();

    public final void zzb() {
        zzab zzabVar = (zzab) this.zza.get();
        if (zzabVar != null) {
            zzabVar.zzc();
        }
    }

    public final void zzc(String str, int i) {
        AtomicReference atomicReference = this.zza;
        zzab zzabVarZza = (zzab) atomicReference.get();
        if (zzabVarZza == null) {
            zzabVarZza = zza();
            if (!ComplexDouble$.ExternalSyntheticBackport0.m(atomicReference, (Object) null, zzabVarZza)) {
                zzabVarZza = (zzab) atomicReference.get();
            }
        }
        zzabVarZza.zzb(str, i);
    }
}
