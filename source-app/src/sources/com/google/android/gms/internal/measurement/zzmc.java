package com.google.android.gms.internal.measurement;

import java.io.IOException;

final class zzmc extends zzma<zzlz, zzlz> {
    @Override
    final int zza(zzlz zzlzVar) {
        return zzlzVar.zza();
    }

    @Override
    final boolean zza(zzlc zzlcVar) {
        return false;
    }

    @Override
    final int zzb(zzlz zzlzVar) {
        return zzlzVar.zzb();
    }

    @Override
    final zzlz zzc(Object obj) {
        zzlz zzlzVar = ((zzix) obj).zzb;
        if (zzlzVar != zzlz.zzc()) {
            return zzlzVar;
        }
        zzlz zzlzVarZzd = zzlz.zzd();
        zza(obj, zzlzVarZzd);
        return zzlzVarZzd;
    }

    @Override
    final zzlz zzd(Object obj) {
        return ((zzix) obj).zzb;
    }

    @Override
    final zzlz zza(zzlz zzlzVar, zzlz zzlzVar2) {
        zzlz zzlzVar3 = zzlzVar;
        zzlz zzlzVar4 = zzlzVar2;
        if (zzlz.zzc().equals(zzlzVar4)) {
            return zzlzVar3;
        }
        if (zzlz.zzc().equals(zzlzVar3)) {
            return zzlz.zza(zzlzVar3, zzlzVar4);
        }
        return zzlzVar3.zza(zzlzVar4);
    }

    @Override
    final zzlz zza() {
        return zzlz.zzd();
    }

    @Override
    final zzlz zze(zzlz zzlzVar) {
        zzlz zzlzVar2 = zzlzVar;
        zzlzVar2.zze();
        return zzlzVar2;
    }

    zzmc() {
    }

    @Override
    final void zza(zzlz zzlzVar, int i, int i2) {
        zzlzVar.zza((i << 3) | 5, Integer.valueOf(i2));
    }

    @Override
    final void zza(zzlz zzlzVar, int i, long j) {
        zzlzVar.zza((i << 3) | 1, Long.valueOf(j));
    }

    @Override
    final void zza(zzlz zzlzVar, int i, zzlz zzlzVar2) {
        zzlzVar.zza((i << 3) | 3, zzlzVar2);
    }

    @Override
    final void zza(zzlz zzlzVar, int i, zzhm zzhmVar) {
        zzlzVar.zza((i << 3) | 2, zzhmVar);
    }

    @Override
    final void zzb(zzlz zzlzVar, int i, long j) {
        zzlzVar.zza(i << 3, Long.valueOf(j));
    }

    @Override
    final void zzf(Object obj) {
        ((zzix) obj).zzb.zze();
    }

    @Override
    final void zzb(Object obj, zzlz zzlzVar) {
        zza(obj, zzlzVar);
    }

    private static void zza(Object obj, zzlz zzlzVar) {
        ((zzix) obj).zzb = zzlzVar;
    }

    @Override
    final void zzc(Object obj, zzlz zzlzVar) {
        zza(obj, zzlzVar);
    }

    @Override
    final void zza(zzlz zzlzVar, zzmw zzmwVar) throws IOException {
        zzlzVar.zza(zzmwVar);
    }

    @Override
    final void zzb(zzlz zzlzVar, zzmw zzmwVar) throws IOException {
        zzlzVar.zzb(zzmwVar);
    }
}
