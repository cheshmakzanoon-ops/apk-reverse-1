package com.google.android.gms.internal.measurement;

final class zzki {
    private static final zzkg zza = zzc();
    private static final zzkg zzb = new zzkf();

    static zzkg zza() {
        return zza;
    }

    static zzkg zzb() {
        return zzb;
    }

    private static zzkg zzc() {
        try {
            return (zzkg) Class.forName("com.google.protobuf.MapFieldSchemaFull").getDeclaredConstructor(null).newInstance(null);
        } catch (Exception unused) {
            return null;
        }
    }
}
