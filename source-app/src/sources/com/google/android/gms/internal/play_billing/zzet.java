package com.google.android.gms.internal.play_billing;

import java.io.IOException;
import java.util.Arrays;

final class zzet extends zzes {
    private final byte[] zzb;

    zzet(byte[] bArr) {
        super(null);
        bArr.getClass();
        this.zzb = bArr;
    }

    @Override
    public final byte zza(int i) {
        return this.zzb[i];
    }

    @Override
    final byte zzb(int i) {
        return this.zzb[i];
    }

    @Override
    protected final int zzd(int i, int i2, int i3) {
        return zzga.zzb(i, this.zzb, 0, i3);
    }

    @Override
    public final int zze() {
        return this.zzb.length;
    }

    @Override
    public final zzev zzf(int i, int i2) {
        byte[] bArr = this.zzb;
        int iZzj = zzj(0, i2, bArr.length);
        return iZzj == 0 ? zzev.zza : new zzep(bArr, 0, iZzj);
    }

    @Override
    final void zzg(zzem zzemVar) throws IOException {
        byte[] bArr = this.zzb;
        ((zzez) zzemVar).zzc(bArr, 0, bArr.length);
    }

    @Override
    protected final boolean zzh(zzev zzevVar) {
        boolean z = zzevVar instanceof zzet;
        if (z) {
            return Arrays.equals(this.zzb, ((zzet) zzevVar).zzb);
        }
        boolean z2 = zzevVar instanceof zzep;
        if (!z2) {
            return zzevVar.zzh(this);
        }
        byte[] bArr = this.zzb;
        int iZze = zzevVar.zze();
        int length = bArr.length;
        if (length > iZze) {
            throw new IllegalArgumentException("Length too large: " + length + length);
        }
        if (length <= zzevVar.zze()) {
            if (z) {
                return zzev.zzl(bArr, 0, ((zzet) zzevVar).zzb, 0, length);
            }
            if (!z2) {
                return zzevVar.zzf(0, length).equals(zzf(0, length));
            }
            zzep zzepVar = (zzep) zzevVar;
            return zzev.zzl(bArr, 0, zzepVar.zzb, zzepVar.zzc, length);
        }
        throw new IllegalArgumentException("Ran off end of other: 0, " + length + ", " + zzevVar.zze());
    }
}
