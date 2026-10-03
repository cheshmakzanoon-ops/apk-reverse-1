package com.google.android.gms.internal.measurement;

final class zzjx implements zzle {
    private static final zzkk zza = new zzka();
    private final zzkk zzb;

    private static zzkk zza() {
        try {
            return (zzkk) Class.forName("com.google.protobuf.DescriptorMessageInfoFactory").getDeclaredMethod("getInstance", null).invoke(null, null);
        } catch (Exception unused) {
            return zza;
        }
    }

    @Override
    public final <T> zzlb<T> zza(Class<T> cls) {
        zzld.zza((Class<?>) cls);
        zzkh zzkhVarZza = this.zzb.zza(cls);
        if (zzkhVarZza.zzc()) {
            if (zzix.class.isAssignableFrom(cls)) {
                return zzkp.zza(zzld.zzb(), zzin.zzb(), zzkhVarZza.zza());
            }
            return zzkp.zza(zzld.zza(), zzin.zza(), zzkhVarZza.zza());
        }
        if (zzix.class.isAssignableFrom(cls)) {
            if (zza(zzkhVarZza)) {
                return zzkn.zza(cls, zzkhVarZza, zzkt.zzb(), zzjs.zzb(), zzld.zzb(), zzin.zzb(), zzki.zzb());
            }
            return zzkn.zza(cls, zzkhVarZza, zzkt.zzb(), zzjs.zzb(), zzld.zzb(), (zzim<?>) null, zzki.zzb());
        }
        if (zza(zzkhVarZza)) {
            return zzkn.zza(cls, zzkhVarZza, zzkt.zza(), zzjs.zza(), zzld.zza(), zzin.zza(), zzki.zza());
        }
        return zzkn.zza(cls, zzkhVarZza, zzkt.zza(), zzjs.zza(), zzld.zza(), (zzim<?>) null, zzki.zza());
    }

    public zzjx() {
        this(new zzkc(zziy.zza(), zza()));
    }

    private zzjx(zzkk zzkkVar) {
        this.zzb = (zzkk) zziz.zza(zzkkVar, "messageInfoFactory");
    }

    private static boolean zza(zzkh zzkhVar) {
        return zzjz.zza[zzkhVar.zzb().ordinal()] != 1;
    }
}
