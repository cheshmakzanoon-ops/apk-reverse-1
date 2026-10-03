package com.google.android.gms.internal.play_billing;

final class zzgs implements zzhm {
    private static final zzgz zza = new zzgq();
    private final zzgz zzb;

    public zzgs() {
        zzgz zzgzVar = zza;
        int i = zzei.zza;
        zzgr zzgrVar = new zzgr(zzfp.zza(), zzgzVar);
        byte[] bArr = zzga.zzb;
        this.zzb = zzgrVar;
    }

    @Override
    public final zzhl zza(Class cls) {
        int i = zzhn.zza;
        if (!zzfu.class.isAssignableFrom(cls)) {
            int i2 = zzei.zza;
        }
        zzgy zzgyVarZzb = this.zzb.zzb(cls);
        if (zzgyVarZzb.zzb()) {
            int i3 = zzei.zza;
            return zzhf.zzc(zzhn.zzn(), zzfk.zza(), zzgyVarZzb.zza());
        }
        int i4 = zzei.zza;
        return zzhe.zzl(cls, zzgyVarZzb, zzhh.zza(), zzgl.zza(), zzhn.zzn(), zzgyVarZzb.zzc() + (-1) != 1 ? zzfk.zza() : null, zzgx.zza());
    }
}
