package com.google.android.gms.internal.play_billing;

import com.google.common.primitives.Ints;
import com.google.common.primitives.UnsignedBytes;
import com.google.firebase.analytics.FirebaseAnalytics;
import j$.util.Objects;
import java.util.Arrays;

final class zzci extends zzbz {
    static final zzbz zza = new zzci(null, new Object[0], 0);
    final transient Object[] zzb;
    private final transient Object zzc;
    private final transient int zzd;

    private zzci(Object obj, Object[] objArr, int i) {
        this.zzc = obj;
        this.zzb = objArr;
        this.zzd = i;
    }

    static zzci zzg(int i, Object[] objArr, zzby zzbyVar) {
        int iHighestOneBit;
        short[] sArr;
        char c;
        char c2;
        ?? r3;
        ?? r4;
        int i2 = i;
        Object[] objArrCopyOf = objArr;
        if (i2 == 0) {
            return (zzci) zza;
        }
        zzbx zzbxVar = null;
        ?? r5 = 0;
        zzbx zzbxVar2 = null;
        zzbx zzbxVar3 = null;
        int i3 = 1;
        if (i2 == 1) {
            zzbr.zza(Objects.requireNonNull(objArrCopyOf[0]), Objects.requireNonNull(objArrCopyOf[1]));
            return new zzci(null, objArrCopyOf, 1);
        }
        zzbj.zzb(i2, objArrCopyOf.length >> 1, FirebaseAnalytics.Param.INDEX);
        int iMax = Math.max(i2, 2);
        if (iMax < 751619276) {
            iHighestOneBit = Integer.highestOneBit(iMax - 1);
            do {
                iHighestOneBit += iHighestOneBit;
            } while (((double) iHighestOneBit) * 0.7d < iMax);
        } else {
            iHighestOneBit = Ints.MAX_POWER_OF_TWO;
            if (iMax >= 1073741824) {
                throw new IllegalArgumentException("collection too large");
            }
        }
        if (i2 == 1) {
            zzbr.zza(Objects.requireNonNull(objArrCopyOf[0]), Objects.requireNonNull(objArrCopyOf[1]));
            i2 = 1;
            c = 1;
            c2 = 2;
        } else {
            int i4 = iHighestOneBit - 1;
            byte b = -1;
            if (iHighestOneBit <= 128) {
                byte[] bArr = new byte[iHighestOneBit];
                Arrays.fill(bArr, (byte) -1);
                int i5 = 0;
                int i6 = 0;
                while (i5 < i2) {
                    int i7 = i6 + i6;
                    int i8 = i5 + i5;
                    Object objRequireNonNull = Objects.requireNonNull(objArrCopyOf[i8]);
                    Object objRequireNonNull2 = Objects.requireNonNull(objArrCopyOf[i8 ^ i3]);
                    zzbr.zza(objRequireNonNull, objRequireNonNull2);
                    int iZza = zzbs.zza(objRequireNonNull.hashCode());
                    while (true) {
                        int i9 = iZza & i4;
                        int i10 = bArr[i9] & UnsignedBytes.MAX_VALUE;
                        if (i10 == 255) {
                            bArr[i9] = (byte) i7;
                            if (i6 < i5) {
                                objArrCopyOf[i7] = objRequireNonNull;
                                objArrCopyOf[i7 ^ 1] = objRequireNonNull2;
                            }
                            i6++;
                            break;
                        }
                        if (objRequireNonNull.equals(objArrCopyOf[i10 == true ? 1 : 0])) {
                            int i11 = ~i10;
                            zzbx zzbxVar4 = new zzbx(objRequireNonNull, objRequireNonNull2, Objects.requireNonNull(objArrCopyOf[i11 == true ? 1 : 0]));
                            objArrCopyOf[i11 == true ? 1 : 0] = objRequireNonNull2;
                            zzbxVar2 = zzbxVar4;
                            break;
                        }
                        iZza = i9 + 1;
                    }
                    i5++;
                    i3 = 1;
                }
                if (i6 == i2) {
                    r3 = bArr;
                } else {
                    r4 = new Object[]{bArr, Integer.valueOf(i6), zzbxVar2};
                    c2 = 2;
                }
                c = 1;
                r5 = r4;
            } else if (iHighestOneBit <= 32768) {
                sArr = new short[iHighestOneBit];
                Arrays.fill(sArr, (short) -1);
                int i12 = 0;
                for (int i13 = 0; i13 < i2; i13++) {
                    int i14 = i12 + i12;
                    int i15 = i13 + i13;
                    Object objRequireNonNull3 = Objects.requireNonNull(objArrCopyOf[i15]);
                    Object objRequireNonNull4 = Objects.requireNonNull(objArrCopyOf[i15 ^ 1]);
                    zzbr.zza(objRequireNonNull3, objRequireNonNull4);
                    int iZza2 = zzbs.zza(objRequireNonNull3.hashCode());
                    while (true) {
                        int i16 = iZza2 & i4;
                        char c3 = (char) sArr[i16];
                        if (c3 == 65535) {
                            sArr[i16] = (short) i14;
                            if (i12 < i13) {
                                objArrCopyOf[i14] = objRequireNonNull3;
                                objArrCopyOf[i14 ^ 1] = objRequireNonNull4;
                            }
                            i12++;
                            break;
                        }
                        if (objRequireNonNull3.equals(objArrCopyOf[c3])) {
                            int i17 = c3 ^ 1;
                            zzbx zzbxVar5 = new zzbx(objRequireNonNull3, objRequireNonNull4, Objects.requireNonNull(objArrCopyOf[i17 == true ? 1 : 0]));
                            objArrCopyOf[i17 == true ? 1 : 0] = objRequireNonNull4;
                            zzbxVar3 = zzbxVar5;
                            break;
                        }
                        iZza2 = i16 + 1;
                    }
                }
                if (i12 == i2) {
                    r3 = sArr;
                } else {
                    c2 = 2;
                    r5 = new Object[]{sArr, Integer.valueOf(i12), zzbxVar3};
                    c = 1;
                }
            } else {
                int i18 = 1;
                sArr = new int[iHighestOneBit];
                Arrays.fill((int[]) sArr, -1);
                int i19 = 0;
                int i20 = 0;
                while (i19 < i2) {
                    int i21 = i20 + i20;
                    int i22 = i19 + i19;
                    Object objRequireNonNull5 = Objects.requireNonNull(objArrCopyOf[i22]);
                    Object objRequireNonNull6 = Objects.requireNonNull(objArrCopyOf[i22 ^ i18]);
                    zzbr.zza(objRequireNonNull5, objRequireNonNull6);
                    int iZza3 = zzbs.zza(objRequireNonNull5.hashCode());
                    while (true) {
                        int i23 = iZza3 & i4;
                        ?? r15 = sArr[i23];
                        if (r15 == b) {
                            sArr[i23] = i21;
                            if (i20 < i19) {
                                objArrCopyOf[i21] = objRequireNonNull5;
                                objArrCopyOf[i21 ^ 1] = objRequireNonNull6;
                            }
                            i20++;
                            break;
                        }
                        if (objRequireNonNull5.equals(objArrCopyOf[r15])) {
                            int i24 = r15 ^ 1;
                            zzbx zzbxVar6 = new zzbx(objRequireNonNull5, objRequireNonNull6, Objects.requireNonNull(objArrCopyOf[i24 == true ? 1 : 0]));
                            objArrCopyOf[i24 == true ? 1 : 0] = objRequireNonNull6;
                            zzbxVar = zzbxVar6;
                            break;
                        }
                        iZza3 = i23 + 1;
                        b = -1;
                    }
                    i19++;
                    i18 = 1;
                    b = -1;
                }
                if (i20 == i2) {
                    r3 = sArr;
                } else {
                    c = 1;
                    c2 = 2;
                    r5 = new Object[]{sArr, Integer.valueOf(i20), zzbxVar};
                }
            }
            c2 = 2;
            r4 = r3;
            c = 1;
            r5 = r4;
        }
        boolean z = r5 instanceof Object[];
        ?? r6 = r5;
        if (z) {
            Object[] objArr2 = (Object[]) r5;
            zzbx zzbxVar7 = (zzbx) objArr2[c2];
            if (zzbyVar == null) {
                throw zzbxVar7.zza();
            }
            zzbyVar.zzc = zzbxVar7;
            Object obj = objArr2[0];
            int iIntValue = ((Integer) objArr2[c]).intValue();
            objArrCopyOf = Arrays.copyOf(objArrCopyOf, iIntValue + iIntValue);
            r6 = obj;
            i2 = iIntValue;
        }
        return new zzci(r6, objArrCopyOf, i2);
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
                    int iZza = zzbs.zza(obj.hashCode());
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
                    int iZza2 = zzbs.zza(obj.hashCode());
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
                    int iZza3 = zzbs.zza(obj.hashCode());
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
    final zzbt zza() {
        return new zzch(this.zzb, 1, this.zzd);
    }

    @Override
    final zzca zzd() {
        return new zzcf(this, this.zzb, 0, this.zzd);
    }

    @Override
    final zzca zze() {
        return new zzcg(this, new zzch(this.zzb, 0, this.zzd));
    }
}
