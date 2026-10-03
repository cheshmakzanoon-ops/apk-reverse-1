package com.google.android.gms.internal.play_billing;

import sun.misc.Unsafe;

final class zzig extends zzih {
    zzig(Unsafe unsafe) {
        super(unsafe);
    }

    @Override
    public final double zza(Object obj, long j) {
        return Double.longBitsToDouble(this.zza.getLong(obj, j));
    }

    @Override
    public final float zzb(Object obj, long j) {
        return Float.intBitsToFloat(this.zza.getInt(obj, j));
    }

    @Override
    public final void zzc(Object obj, long j, boolean z) {
        if (zzii.zzb) {
            zzii.zzi(obj, j, z);
        } else {
            zzii.zzj(obj, j, z);
        }
    }

    @Override
    public final void zzd(Object obj, long j, byte b) {
        if (zzii.zzb) {
            zzii.zzD(obj, j, b);
        } else {
            zzii.zzE(obj, j, b);
        }
    }

    @Override
    public final void zze(Object obj, long j, double d) {
        this.zza.putLong(obj, j, Double.doubleToLongBits(d));
    }

    @Override
    public final void zzf(Object obj, long j, float f) {
        this.zza.putInt(obj, j, Float.floatToIntBits(f));
    }

    @Override
    public final boolean zzg(Object obj, long j) {
        return zzii.zzb ? zzii.zzt(obj, j) : zzii.zzu(obj, j);
    }
}
