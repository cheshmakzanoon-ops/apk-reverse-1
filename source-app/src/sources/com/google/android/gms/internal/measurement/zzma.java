package com.google.android.gms.internal.measurement;

import java.io.IOException;

abstract class zzma<T, B> {
    zzma() {
    }

    abstract int zza(T t);

    abstract B zza();

    abstract T zza(T t, T t2);

    abstract void zza(B b, int i, int i2);

    abstract void zza(B b, int i, long j);

    abstract void zza(B b, int i, zzhm zzhmVar);

    abstract void zza(B b, int i, T t);

    abstract void zza(T t, zzmw zzmwVar) throws IOException;

    abstract boolean zza(zzlc zzlcVar);

    abstract int zzb(T t);

    abstract void zzb(B b, int i, long j);

    abstract void zzb(T t, zzmw zzmwVar) throws IOException;

    abstract void zzb(Object obj, B b);

    abstract B zzc(Object obj);

    abstract void zzc(Object obj, T t);

    abstract T zzd(Object obj);

    abstract T zze(B b);

    abstract void zzf(Object obj);

    final boolean zza(B b, zzlc zzlcVar) throws IOException {
        int iZzd = zzlcVar.zzd();
        int i = iZzd >>> 3;
        int i2 = iZzd & 7;
        if (i2 == 0) {
            zzb(b, i, zzlcVar.zzl());
            return true;
        }
        if (i2 == 1) {
            zza(b, i, zzlcVar.zzk());
            return true;
        }
        if (i2 == 2) {
            zza((Object) b, i, zzlcVar.zzp());
            return true;
        }
        if (i2 != 3) {
            if (i2 == 4) {
                return false;
            }
            if (i2 != 5) {
                throw zzji.zza();
            }
            zza((Object) b, i, zzlcVar.zzf());
            return true;
        }
        B bZza = zza();
        int i3 = 4 | (i << 3);
        while (zzlcVar.zzc() != Integer.MAX_VALUE && zza((Object) bZza, zzlcVar)) {
        }
        if (i3 != zzlcVar.zzd()) {
            throw zzji.zzb();
        }
        zza(b, i, zze(bZza));
        return true;
    }
}
