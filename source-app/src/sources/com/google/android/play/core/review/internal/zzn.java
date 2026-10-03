package com.google.android.play.core.review.internal;

final class zzn extends zzj {
    final zzt zza;

    zzn(zzt zztVar) {
        this.zza = zztVar;
    }

    @Override
    public final void zza() {
        zzt zztVar = this.zza;
        if (zztVar.zzn != null) {
            zztVar.zzc.zzd("Unbind from service.", new Object[0]);
            zzt zztVar2 = this.zza;
            zztVar2.zzb.unbindService(zztVar2.zzm);
            this.zza.zzh = false;
            this.zza.zzn = null;
            this.zza.zzm = null;
        }
        this.zza.zzt();
    }
}
