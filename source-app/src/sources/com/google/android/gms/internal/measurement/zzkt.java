package com.google.android.gms.internal.measurement;

final class zzkt {
    private static final zzkr zza = zzc();
    private static final zzkr zzb = new zzku();

    static zzkr zza() {
        return zza;
    }

    static zzkr zzb() {
        return zzb;
    }

    private static zzkr zzc() {
        try {
            return (zzkr) Class.forName("com.google.protobuf.NewInstanceSchemaFull").getDeclaredConstructor(null).newInstance(null);
        } catch (Exception unused) {
            return null;
        }
    }
}
