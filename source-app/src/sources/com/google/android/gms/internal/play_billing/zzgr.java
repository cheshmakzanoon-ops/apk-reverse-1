package com.google.android.gms.internal.play_billing;

final class zzgr implements zzgz {
    private final zzgz[] zza;

    zzgr(zzgz... zzgzVarArr) {
        this.zza = zzgzVarArr;
    }

    @Override
    public final zzgy zzb(Class cls) {
        for (int i = 0; i < 2; i++) {
            zzgz zzgzVar = this.zza[i];
            if (zzgzVar.zzc(cls)) {
                return zzgzVar.zzb(cls);
            }
        }
        throw new UnsupportedOperationException("No factory is available for message type: ".concat(String.valueOf(cls.getName())));
    }

    @Override
    public final boolean zzc(Class cls) {
        for (int i = 0; i < 2; i++) {
            if (this.zza[i].zzc(cls)) {
                return true;
            }
        }
        return false;
    }
}
