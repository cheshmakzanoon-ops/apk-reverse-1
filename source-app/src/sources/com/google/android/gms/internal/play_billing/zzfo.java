package com.google.android.gms.internal.play_billing;

import com.google.android.gms.common.api.Api;
import java.util.Arrays;
import java.util.Collection;
import java.util.RandomAccess;

final class zzfo extends zzeh implements RandomAccess, zzfz {
    private static final float[] zza;
    private float[] zzb;
    private int zzc;

    static {
        float[] fArr = new float[0];
        zza = fArr;
        new zzfo(fArr, 0, false);
    }

    zzfo() {
        this(zza, 0, true);
    }

    private static int zzh(int i) {
        return Math.max(((i * 3) / 2) + 1, 10);
    }

    private final String zzi(int i) {
        return "Index:" + i + ", Size:" + this.zzc;
    }

    private final void zzj(int i) {
        if (i < 0 || i >= this.zzc) {
            throw new IndexOutOfBoundsException(zzi(i));
        }
    }

    @Override
    public final void add(int i, Object obj) {
        int i2;
        float fFloatValue = ((Float) obj).floatValue();
        zza();
        if (i < 0 || i > (i2 = this.zzc)) {
            throw new IndexOutOfBoundsException(zzi(i));
        }
        int i3 = i + 1;
        float[] fArr = this.zzb;
        int length = fArr.length;
        if (i2 < length) {
            System.arraycopy(fArr, i, fArr, i3, i2 - i);
        } else {
            float[] fArr2 = new float[zzh(length)];
            System.arraycopy(this.zzb, 0, fArr2, 0, i);
            System.arraycopy(this.zzb, i, fArr2, i3, this.zzc - i);
            this.zzb = fArr2;
        }
        this.zzb[i] = fFloatValue;
        this.zzc++;
        this.modCount++;
    }

    @Override
    public final boolean addAll(Collection collection) {
        zza();
        byte[] bArr = zzga.zzb;
        collection.getClass();
        if (!(collection instanceof zzfo)) {
            return super.addAll(collection);
        }
        zzfo zzfoVar = (zzfo) collection;
        int i = zzfoVar.zzc;
        if (i == 0) {
            return false;
        }
        int i2 = this.zzc;
        if (Api.BaseClientBuilder.API_PRIORITY_OTHER - i2 < i) {
            throw new OutOfMemoryError();
        }
        int i3 = i2 + i;
        float[] fArr = this.zzb;
        if (i3 > fArr.length) {
            this.zzb = Arrays.copyOf(fArr, i3);
        }
        System.arraycopy(zzfoVar.zzb, 0, this.zzb, this.zzc, zzfoVar.zzc);
        this.zzc = i3;
        this.modCount++;
        return true;
    }

    @Override
    public final boolean contains(Object obj) {
        return indexOf(obj) != -1;
    }

    @Override
    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof zzfo)) {
            return super.equals(obj);
        }
        zzfo zzfoVar = (zzfo) obj;
        if (this.zzc != zzfoVar.zzc) {
            return false;
        }
        float[] fArr = zzfoVar.zzb;
        for (int i = 0; i < this.zzc; i++) {
            if (Float.floatToIntBits(this.zzb[i]) != Float.floatToIntBits(fArr[i])) {
                return false;
            }
        }
        return true;
    }

    @Override
    public final Object get(int i) {
        zzj(i);
        return Float.valueOf(this.zzb[i]);
    }

    @Override
    public final int hashCode() {
        int iFloatToIntBits = 1;
        for (int i = 0; i < this.zzc; i++) {
            iFloatToIntBits = (iFloatToIntBits * 31) + Float.floatToIntBits(this.zzb[i]);
        }
        return iFloatToIntBits;
    }

    @Override
    public final int indexOf(Object obj) {
        if (!(obj instanceof Float)) {
            return -1;
        }
        float fFloatValue = ((Float) obj).floatValue();
        int i = this.zzc;
        for (int i2 = 0; i2 < i; i2++) {
            if (this.zzb[i2] == fFloatValue) {
                return i2;
            }
        }
        return -1;
    }

    @Override
    public final Object remove(int i) {
        zza();
        zzj(i);
        float[] fArr = this.zzb;
        float f = fArr[i];
        int i2 = this.zzc;
        if (i < i2 - 1) {
            System.arraycopy(fArr, i + 1, fArr, i, (i2 - i) - 1);
        }
        this.zzc--;
        this.modCount++;
        return Float.valueOf(f);
    }

    @Override
    protected final void removeRange(int i, int i2) {
        zza();
        if (i2 < i) {
            throw new IndexOutOfBoundsException("toIndex < fromIndex");
        }
        float[] fArr = this.zzb;
        System.arraycopy(fArr, i2, fArr, i, this.zzc - i2);
        this.zzc -= i2 - i;
        this.modCount++;
    }

    @Override
    public final Object set(int i, Object obj) {
        float fFloatValue = ((Float) obj).floatValue();
        zza();
        zzj(i);
        float[] fArr = this.zzb;
        float f = fArr[i];
        fArr[i] = fFloatValue;
        return Float.valueOf(f);
    }

    @Override
    public final int size() {
        return this.zzc;
    }

    @Override
    public final zzfz zzd(int i) {
        if (i >= this.zzc) {
            return new zzfo(i == 0 ? zza : Arrays.copyOf(this.zzb, i), this.zzc, true);
        }
        throw new IllegalArgumentException();
    }

    public final float zze(int i) {
        zzj(i);
        return this.zzb[i];
    }

    public final void zzf(float f) {
        zza();
        int i = this.zzc;
        int length = this.zzb.length;
        if (i == length) {
            float[] fArr = new float[zzh(length)];
            System.arraycopy(this.zzb, 0, fArr, 0, this.zzc);
            this.zzb = fArr;
        }
        float[] fArr2 = this.zzb;
        int i2 = this.zzc;
        this.zzc = i2 + 1;
        fArr2[i2] = f;
    }

    final void zzg(int i) {
        int length = this.zzb.length;
        if (i <= length) {
            return;
        }
        if (length == 0) {
            this.zzb = new float[Math.max(i, 10)];
            return;
        }
        while (length < i) {
            length = zzh(length);
        }
        this.zzb = Arrays.copyOf(this.zzb, length);
    }

    private zzfo(float[] fArr, int i, boolean z) {
        super(z);
        this.zzb = fArr;
        this.zzc = i;
    }

    @Override
    public final boolean add(Object obj) {
        zzf(((Float) obj).floatValue());
        return true;
    }
}
