package com.google.android.gms.internal.play_billing;

import java.io.IOException;
import java.io.Serializable;
import java.util.Iterator;
import java.util.Locale;

public abstract class zzev implements Iterable, Serializable {
    public static final zzev zza = new zzet(zzga.zzb);
    private int zzb = 0;

    static {
        int i = zzei.zza;
    }

    zzev() {
    }

    public static zzev zzk(byte[] bArr, int i, int i2) {
        try {
            zzj(i, i + i2, bArr.length);
            byte[] bArr2 = new byte[i2];
            System.arraycopy(bArr, i, bArr2, 0, i2);
            return new zzet(bArr2);
        } catch (zzgc e) {
            throw new AssertionError("Expected no InvalidProtocolBufferException as data UTF8 validity is not checked.", e);
        }
    }

    static boolean zzl(byte[] bArr, int i, byte[] bArr2, int i2, int i3) {
        int i4 = i + i3;
        zzj(i, i4, bArr.length);
        zzj(i2, i3 + i2, bArr2.length);
        while (i < i4) {
            if (bArr[i] != bArr2[i2]) {
                return false;
            }
            i++;
            i2++;
        }
        return true;
    }

    public final boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (!(obj instanceof zzev)) {
            return false;
        }
        zzev zzevVar = (zzev) obj;
        int iZze = zze();
        if (iZze != zzevVar.zze()) {
            return false;
        }
        if (iZze == 0) {
            return true;
        }
        int i = this.zzb;
        int i2 = zzevVar.zzb;
        if (i == 0 || i2 == 0 || i == i2) {
            return zzh(zzevVar);
        }
        return false;
    }

    public final int hashCode() {
        int iZzd = this.zzb;
        if (iZzd == 0) {
            int iZze = zze();
            iZzd = zzd(iZze, 0, iZze);
            if (iZzd == 0) {
                iZzd = 1;
            }
            this.zzb = iZzd;
        }
        return iZzd;
    }

    @Override
    public final Iterator iterator() {
        return new zzen(this);
    }

    public final String toString() {
        return String.format(Locale.ROOT, "<ByteString@%s size=%d contents=\"%s\">", Integer.toHexString(System.identityHashCode(this)), Integer.valueOf(zze()), zze() <= 50 ? zzhz.zza(this) : zzhz.zza(zzf(0, 47)).concat("..."));
    }

    public abstract byte zza(int i);

    abstract byte zzb(int i);

    protected abstract int zzd(int i, int i2, int i3);

    public abstract int zze();

    public abstract zzev zzf(int i, int i2);

    abstract void zzg(zzem zzemVar) throws IOException;

    protected abstract boolean zzh(zzev zzevVar);

    static int zzj(int i, int i2, int i3) {
        int i4 = i2 - i;
        if ((i | i2 | i4 | (i3 - i2)) >= 0) {
            return i4;
        }
        if (i < 0) {
            throw new IndexOutOfBoundsException("Beginning index: " + i + " < 0");
        }
        if (i2 < i) {
            throw new IndexOutOfBoundsException("Beginning index larger than ending index: " + i + ", " + i2);
        }
        throw new IndexOutOfBoundsException("End index: " + i2 + " >= " + i3);
    }
}
