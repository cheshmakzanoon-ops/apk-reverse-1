package com.google.android.gms.internal.play_billing;

import java.io.IOException;

final class zzep extends zzes {
    private final byte[] zzb;
    private final int zzc;
    private final int zzd;

    zzep(byte[] bArr, int i, int i2) {
        super(null);
        zzj(i, i + i2, bArr.length);
        this.zzb = bArr;
        this.zzc = i;
        this.zzd = i2;
    }

    @Override
    final byte zzb(int i) {
        return this.zzb[this.zzc + i];
    }

    @Override
    protected final int zzd(int i, int i2, int i3) {
        return zzga.zzb(i, this.zzb, this.zzc, i3);
    }

    @Override
    public final int zze() {
        return this.zzd;
    }

    @Override
    public final zzev zzf(int i, int i2) {
        int iZzj = zzj(i, i2, this.zzd);
        return iZzj == 0 ? zzev.zza : new zzep(this.zzb, this.zzc + i, iZzj);
    }

    @Override
    final void zzg(zzem zzemVar) throws IOException {
        ((zzez) zzemVar).zzc(this.zzb, this.zzc, this.zzd);
    }

    @Override
    protected final boolean zzh(zzev zzevVar) {
        boolean z = zzevVar instanceof zzet;
        if (!z && !(zzevVar instanceof zzep)) {
            return zzevVar.zzh(this);
        }
        int i = this.zzd;
        if (i > zzevVar.zze()) {
            throw new IllegalArgumentException("Length too large: " + i + i);
        }
        if (i > zzevVar.zze()) {
            throw new IllegalArgumentException("Ran off end of other: 0, " + i + ", " + zzevVar.zze());
        }
        if (z) {
            return zzev.zzl(this.zzb, this.zzc, ((zzet) zzevVar).zzb, 0, i);
        }
        if (zzevVar instanceof zzep) {
            zzep zzepVar = (zzep) zzevVar;
            return zzev.zzl(this.zzb, this.zzc, zzepVar.zzb, zzepVar.zzc, i);
        }
        zzev zzevVarZzf = zzevVar.zzf(0, i);
        int i2 = this.zzc;
        return zzevVarZzf.equals(zzf(i2, i + i2));
    }

    @Override
    public final byte zza(int i) {
        int i2 = this.zzd;
        if (((i2 - (i + 1)) | i) >= 0) {
            return this.zzb[this.zzc + i];
        }
        if (i < 0) {
            throw new ArrayIndexOutOfBoundsException("Index < 0: " + i);
        }
        throw new ArrayIndexOutOfBoundsException("Index > length: " + i + ", " + i2);
    }
}
