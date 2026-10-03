package com.google.android.gms.internal.measurement;

final class zzin {
    private static final zzim<?> zza = new zzio();
    private static final zzim<?> zzb = zzc();

    static zzim<?> zza() {
        zzim<?> zzimVar = zzb;
        if (zzimVar != null) {
            return zzimVar;
        }
        throw new IllegalStateException("Protobuf runtime is not correctly loaded.");
    }

    static zzim<?> zzb() {
        return zza;
    }

    private static zzim<?> zzc() {
        try {
            return (zzim) Class.forName("com.google.protobuf.ExtensionSchemaFull").getDeclaredConstructor(null).newInstance(null);
        } catch (Exception unused) {
            return null;
        }
    }
}
