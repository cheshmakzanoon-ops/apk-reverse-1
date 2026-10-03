package com.google.android.gms.internal.measurement;

import com.google.common.primitives.UnsignedBytes;
import java.io.IOException;
import java.io.Serializable;
import java.nio.charset.Charset;
import java.util.Comparator;
import java.util.Iterator;
import java.util.Locale;

public abstract class zzhm implements Serializable, Iterable<Byte> {
    public static final zzhm zza = new zzhw(zziz.zzb);
    private static final zzht zzb = new zzhz();
    private static final Comparator<zzhm> zzc = new zzho();
    private int zzd = 0;

    static int zza(byte b) {
        return b & UnsignedBytes.MAX_VALUE;
    }

    public abstract boolean equals(Object obj);

    public abstract byte zza(int i);

    public abstract zzhm zza(int i, int i2);

    protected abstract String zza(Charset charset);

    abstract void zza(zzhn zzhnVar) throws IOException;

    abstract byte zzb(int i);

    public abstract int zzb();

    protected abstract int zzb(int i, int i2, int i3);

    public abstract boolean zzd();

    static int zza(int i, int i2, int i3) {
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

    public final int hashCode() {
        int iZzb = this.zzd;
        if (iZzb == 0) {
            int iZzb2 = zzb();
            iZzb = zzb(iZzb2, 0, iZzb2);
            if (iZzb == 0) {
                iZzb = 1;
            }
            this.zzd = iZzb;
        }
        return iZzb;
    }

    protected final int zza() {
        return this.zzd;
    }

    static zzhv zzc(int i) {
        return new zzhv(i);
    }

    public static zzhm zza(byte[] bArr, int i, int i2) {
        zza(i, i + i2, bArr.length);
        return new zzhw(zzb.zza(bArr, i, i2));
    }

    public static zzhm zza(String str) {
        return new zzhw(str.getBytes(zziz.zza));
    }

    static zzhm zza(byte[] bArr) {
        return new zzhw(bArr);
    }

    public final String toString() {
        String strZza;
        Locale locale = Locale.ROOT;
        String hexString = Integer.toHexString(System.identityHashCode(this));
        Integer numValueOf = Integer.valueOf(zzb());
        if (zzb() <= 50) {
            strZza = zzlw.zza(this);
        } else {
            strZza = zzlw.zza(zza(0, 47)) + "...";
        }
        return String.format(locale, "<ByteString@%s size=%d contents=\"%s\">", hexString, numValueOf, strZza);
    }

    public final String zzc() {
        return zzb() == 0 ? "" : zza(zziz.zza);
    }

    @Override
    public Iterator<Byte> iterator() {
        return new zzhp(this);
    }

    zzhm() {
    }
}
