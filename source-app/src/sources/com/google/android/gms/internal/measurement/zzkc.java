package com.google.android.gms.internal.measurement;

final class zzkc implements zzkk {
    private zzkk[] zza;

    @Override
    public final zzkh zza(Class<?> cls) {
        for (zzkk zzkkVar : this.zza) {
            if (zzkkVar.zzb(cls)) {
                return zzkkVar.zza(cls);
            }
        }
        throw new UnsupportedOperationException("No factory is available for message type: " + cls.getName());
    }

    zzkc(zzkk... zzkkVarArr) {
        this.zza = zzkkVarArr;
    }

    @Override
    public final boolean zzb(Class<?> cls) {
        for (zzkk zzkkVar : this.zza) {
            if (zzkkVar.zzb(cls)) {
                return true;
            }
        }
        return false;
    }
}
