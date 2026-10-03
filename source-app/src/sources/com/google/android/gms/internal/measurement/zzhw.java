package com.google.android.gms.internal.measurement;

import java.io.IOException;
import java.nio.charset.Charset;

class zzhw extends zzhx {
    protected final byte[] zzb;

    @Override
    public byte zza(int i) {
        return this.zzb[i];
    }

    protected int zze() {
        return 0;
    }

    @Override
    byte zzb(int i) {
        return this.zzb[i];
    }

    @Override
    protected final int zzb(int i, int i2, int i3) {
        return zziz.zza(i, this.zzb, zze(), i3);
    }

    @Override
    public int zzb() {
        return this.zzb.length;
    }

    @Override
    public final zzhm zza(int i, int i2) {
        int iZza = zza(0, i2, zzb());
        if (iZza == 0) {
            return zzhm.zza;
        }
        return new zzhq(this.zzb, zze(), iZza);
    }

    @Override
    protected final String zza(Charset charset) {
        return new String(this.zzb, zze(), zzb(), charset);
    }

    zzhw(byte[] bArr) {
        bArr.getClass();
        this.zzb = bArr;
    }

    @Override
    final void zza(zzhn zzhnVar) throws IOException {
        zzhnVar.zza(this.zzb, zze(), zzb());
    }

    @Override
    public final boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (!(obj instanceof zzhm) || zzb() != ((zzhm) obj).zzb()) {
            return false;
        }
        if (zzb() == 0) {
            return true;
        }
        if (obj instanceof zzhw) {
            zzhw zzhwVar = (zzhw) obj;
            int iZza = zza();
            int iZza2 = zzhwVar.zza();
            if (iZza == 0 || iZza2 == 0 || iZza == iZza2) {
                return zza(zzhwVar, 0, zzb());
            }
            return false;
        }
        return obj.equals(this);
    }

    @Override
    final boolean zza(zzhm zzhmVar, int i, int i2) {
        if (i2 > zzhmVar.zzb()) {
            throw new IllegalArgumentException("Length too large: " + i2 + zzb());
        }
        if (i2 > zzhmVar.zzb()) {
            throw new IllegalArgumentException("Ran off end of other: 0, " + i2 + ", " + zzhmVar.zzb());
        }
        if (zzhmVar instanceof zzhw) {
            zzhw zzhwVar = (zzhw) zzhmVar;
            byte[] bArr = this.zzb;
            byte[] bArr2 = zzhwVar.zzb;
            int iZze = zze() + i2;
            int iZze2 = zze();
            int iZze3 = zzhwVar.zze();
            while (iZze2 < iZze) {
                if (bArr[iZze2] != bArr2[iZze3]) {
                    return false;
                }
                iZze2++;
                iZze3++;
            }
            return true;
        }
        return zzhmVar.zza(0, i2).equals(zza(0, i2));
    }

    @Override
    public final boolean zzd() {
        int iZze = zze();
        return zzmh.zzc(this.zzb, iZze, zzb() + iZze);
    }
}
