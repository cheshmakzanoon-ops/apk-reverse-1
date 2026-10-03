package com.google.android.gms.internal.games_v2;

import com.google.common.primitives.UnsignedBytes;
import j$.util.Objects;

final class zzie extends zzhg {
    static final zzhg zza = new zzie(null, new Object[0], 0);
    final transient Object[] zzb;
    private final transient Object zzc;
    private final transient int zzd;

    private zzie(Object obj, Object[] objArr, int i) {
        this.zzc = obj;
        this.zzb = objArr;
        this.zzd = i;
    }

    static com.google.android.gms.internal.games_v2.zzie zzf(int r17, java.lang.Object[] r18, com.google.android.gms.internal.games_v2.zzhf r19) {
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.gms.internal.games_v2.zzie.zzf(int, java.lang.Object[], com.google.android.gms.internal.games_v2.zzhf):com.google.android.gms.internal.games_v2.zzie");
    }

    @Override
    public final Object get(Object obj) {
        Object objRequireNonNull;
        if (obj == null) {
            objRequireNonNull = null;
        } else {
            int i = this.zzd;
            Object[] objArr = this.zzb;
            if (i != 1) {
                Object obj2 = this.zzc;
                if (obj2 == null) {
                    objRequireNonNull = null;
                } else if (obj2 instanceof byte[]) {
                    byte[] bArr = (byte[]) obj2;
                    int length = bArr.length - 1;
                    int iZza = zzgv.zza(obj.hashCode());
                    while (true) {
                        int i2 = iZza & length;
                        int i3 = bArr[i2] & UnsignedBytes.MAX_VALUE;
                        if (i3 == 255) {
                            break;
                        }
                        if (obj.equals(objArr[i3])) {
                            objRequireNonNull = objArr[i3 ^ 1];
                        } else {
                            iZza = i2 + 1;
                        }
                    }
                    objRequireNonNull = null;
                } else if (obj2 instanceof short[]) {
                    short[] sArr = (short[]) obj2;
                    int length2 = sArr.length - 1;
                    int iZza2 = zzgv.zza(obj.hashCode());
                    while (true) {
                        int i4 = iZza2 & length2;
                        char c = (char) sArr[i4];
                        if (c == 65535) {
                            break;
                        }
                        if (obj.equals(objArr[c])) {
                            objRequireNonNull = objArr[c ^ 1];
                        } else {
                            iZza2 = i4 + 1;
                        }
                    }
                    objRequireNonNull = null;
                } else {
                    int[] iArr = (int[]) obj2;
                    int length3 = iArr.length - 1;
                    int iZza3 = zzgv.zza(obj.hashCode());
                    while (true) {
                        int i5 = iZza3 & length3;
                        int i6 = iArr[i5];
                        if (i6 == -1) {
                            break;
                        }
                        if (obj.equals(objArr[i6])) {
                            objRequireNonNull = objArr[i6 ^ 1];
                        } else {
                            iZza3 = i5 + 1;
                        }
                    }
                    objRequireNonNull = null;
                }
            } else if (Objects.requireNonNull(objArr[0]).equals(obj)) {
                objRequireNonNull = Objects.requireNonNull(objArr[1]);
            } else {
                objRequireNonNull = null;
            }
        }
        if (objRequireNonNull == null) {
            return null;
        }
        return objRequireNonNull;
    }

    @Override
    public final int size() {
        return this.zzd;
    }

    @Override
    final zzhk zzb() {
        return new zzib(this, this.zzb, 0, this.zzd);
    }

    @Override
    final zzhk zzc() {
        return new zzic(this, new zzid(this.zzb, 0, this.zzd));
    }

    @Override
    final zzgy zze() {
        return new zzid(this.zzb, 1, this.zzd);
    }
}
