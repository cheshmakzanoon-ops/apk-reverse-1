package com.google.android.gms.internal.measurement;

final class zziy implements zzkk {
    private static final zziy zza = new zziy();

    public static zziy zza() {
        return zza;
    }

    @Override
    public final zzkh zza(Class<?> cls) {
        if (!zzix.class.isAssignableFrom(cls)) {
            throw new IllegalArgumentException("Unsupported message type: " + cls.getName());
        }
        try {
            return (zzkh) zzix.zza(cls.asSubclass(zzix.class)).zza(zzix.zze.zzc, (Object) null, (Object) null);
        } catch (Exception e) {
            throw new RuntimeException("Unable to get message info for " + cls.getName(), e);
        }
    }

    private zziy() {
    }

    @Override
    public final boolean zzb(Class<?> cls) {
        return zzix.class.isAssignableFrom(cls);
    }
}
