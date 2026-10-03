package com.google.android.gms.internal.play_billing;

final class zzl extends zzd {
    zzl() {
        super(null);
    }

    @Override
    final void zza(zzm zzmVar, zzm zzmVar2) {
        zzmVar.zzc = zzmVar2;
    }

    @Override
    final void zzb(zzm zzmVar, Thread thread) {
        zzmVar.zzb = thread;
    }

    @Override
    final boolean zzc(zzo zzoVar, zzh zzhVar, zzh zzhVar2) {
        synchronized (zzoVar) {
            if (zzoVar.zzd != zzhVar) {
                return false;
            }
            zzoVar.zzd = zzhVar2;
            return true;
        }
    }

    @Override
    final boolean zzd(zzo zzoVar, Object obj, Object obj2) {
        synchronized (zzoVar) {
            if (zzoVar.zzc != obj) {
                return false;
            }
            zzoVar.zzc = obj2;
            return true;
        }
    }

    @Override
    final boolean zze(zzo zzoVar, zzm zzmVar, zzm zzmVar2) {
        synchronized (zzoVar) {
            if (zzoVar.zze != zzmVar) {
                return false;
            }
            zzoVar.zze = zzmVar2;
            return true;
        }
    }
}
