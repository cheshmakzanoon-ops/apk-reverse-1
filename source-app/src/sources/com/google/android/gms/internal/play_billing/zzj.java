package com.google.android.gms.internal.play_billing;

import java.util.concurrent.atomic.AtomicReferenceFieldUpdater;

final class zzj extends zzd {
    final AtomicReferenceFieldUpdater zza;
    final AtomicReferenceFieldUpdater zzb;
    final AtomicReferenceFieldUpdater zzc;
    final AtomicReferenceFieldUpdater zzd;
    final AtomicReferenceFieldUpdater zze;

    zzj(AtomicReferenceFieldUpdater atomicReferenceFieldUpdater, AtomicReferenceFieldUpdater atomicReferenceFieldUpdater2, AtomicReferenceFieldUpdater atomicReferenceFieldUpdater3, AtomicReferenceFieldUpdater atomicReferenceFieldUpdater4, AtomicReferenceFieldUpdater atomicReferenceFieldUpdater5) {
        super(null);
        this.zza = atomicReferenceFieldUpdater;
        this.zzb = atomicReferenceFieldUpdater2;
        this.zzc = atomicReferenceFieldUpdater3;
        this.zzd = atomicReferenceFieldUpdater4;
        this.zze = atomicReferenceFieldUpdater5;
    }

    @Override
    final void zza(zzm zzmVar, zzm zzmVar2) {
        this.zzb.lazySet(zzmVar, zzmVar2);
    }

    @Override
    final void zzb(zzm zzmVar, Thread thread) {
        this.zza.lazySet(zzmVar, thread);
    }

    @Override
    final boolean zzc(zzo zzoVar, zzh zzhVar, zzh zzhVar2) {
        return zzi.zza(this.zzd, zzoVar, zzhVar, zzhVar2);
    }

    @Override
    final boolean zzd(zzo zzoVar, Object obj, Object obj2) {
        return zzi.zza(this.zze, zzoVar, obj, obj2);
    }

    @Override
    final boolean zze(zzo zzoVar, zzm zzmVar, zzm zzmVar2) {
        return zzi.zza(this.zzc, zzoVar, zzmVar, zzmVar2);
    }
}
