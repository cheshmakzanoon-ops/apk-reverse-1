package com.google.android.gms.internal.measurement;

final class zzhq extends zzhw {
    private final int zzc;
    private final int zzd;

    @Override
    public final byte zza(int i) {
        int iZzb = zzb();
        if (((iZzb - (i + 1)) | i) >= 0) {
            return this.zzb[this.zzc + i];
        }
        if (i < 0) {
            throw new ArrayIndexOutOfBoundsException("Index < 0: " + i);
        }
        throw new ArrayIndexOutOfBoundsException("Index > length: " + i + ", " + iZzb);
    }

    @Override
    final byte zzb(int i) {
        return this.zzb[this.zzc + i];
    }

    @Override
    protected final int zze() {
        return this.zzc;
    }

    @Override
    public final int zzb() {
        return this.zzd;
    }

    zzhq(byte[] bArr, int i, int i2) {
        super(bArr);
        zza(i, i + i2, bArr.length);
        this.zzc = i;
        this.zzd = i2;
    }
}
