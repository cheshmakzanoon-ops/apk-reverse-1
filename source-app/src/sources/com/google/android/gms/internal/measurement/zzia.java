package com.google.android.gms.internal.measurement;

import com.google.android.gms.common.api.Api;
import com.google.common.base.Ascii;
import com.google.common.primitives.UnsignedBytes;
import java.io.IOException;
import java.util.Arrays;

final class zzia extends zzib {
    private final byte[] zzd;
    private final boolean zze;
    private int zzf;
    private int zzg;
    private int zzh;
    private int zzi;
    private int zzj;
    private int zzk;

    private final byte zzv() throws IOException {
        int i = this.zzh;
        if (i == this.zzf) {
            throw zzji.zzh();
        }
        byte[] bArr = this.zzd;
        this.zzh = i + 1;
        return bArr[i];
    }

    @Override
    public final double zza() throws IOException {
        return Double.longBitsToDouble(zzy());
    }

    @Override
    public final float zzb() throws IOException {
        return Float.intBitsToFloat(zzw());
    }

    @Override
    public final int zzc() {
        return this.zzh - this.zzi;
    }

    @Override
    public final int zza(int i) throws zzji {
        if (i < 0) {
            throw zzji.zzf();
        }
        int iZzc = i + zzc();
        if (iZzc < 0) {
            throw zzji.zzg();
        }
        int i2 = this.zzk;
        if (iZzc > i2) {
            throw zzji.zzh();
        }
        this.zzk = iZzc;
        zzaa();
        return i2;
    }

    @Override
    public final int zzd() throws IOException {
        return zzx();
    }

    @Override
    public final int zze() throws IOException {
        return zzw();
    }

    @Override
    public final int zzf() throws IOException {
        return zzx();
    }

    private final int zzw() throws IOException {
        int i = this.zzh;
        if (this.zzf - i < 4) {
            throw zzji.zzh();
        }
        byte[] bArr = this.zzd;
        this.zzh = i + 4;
        return ((bArr[i + 3] & UnsignedBytes.MAX_VALUE) << 24) | (bArr[i] & UnsignedBytes.MAX_VALUE) | ((bArr[i + 1] & UnsignedBytes.MAX_VALUE) << 8) | ((bArr[i + 2] & UnsignedBytes.MAX_VALUE) << 16);
    }

    private final int zzx() throws IOException {
        int i;
        int i2 = this.zzh;
        int i3 = this.zzf;
        if (i3 != i2) {
            byte[] bArr = this.zzd;
            int i4 = i2 + 1;
            byte b = bArr[i2];
            if (b >= 0) {
                this.zzh = i4;
                return b;
            }
            if (i3 - i4 >= 9) {
                int i5 = i2 + 2;
                int i6 = (bArr[i4] << 7) ^ b;
                if (i6 < 0) {
                    i = i6 ^ (-128);
                } else {
                    int i7 = i2 + 3;
                    int i8 = (bArr[i5] << Ascii.f90SO) ^ i6;
                    if (i8 >= 0) {
                        i = i8 ^ 16256;
                    } else {
                        int i9 = i2 + 4;
                        int i10 = i8 ^ (bArr[i7] << Ascii.NAK);
                        if (i10 < 0) {
                            i = (-2080896) ^ i10;
                        } else {
                            i7 = i2 + 5;
                            byte b2 = bArr[i9];
                            int i11 = (i10 ^ (b2 << Ascii.f83FS)) ^ 266354560;
                            if (b2 < 0) {
                                i9 = i2 + 6;
                                if (bArr[i7] < 0) {
                                    i7 = i2 + 7;
                                    if (bArr[i9] < 0) {
                                        i9 = i2 + 8;
                                        if (bArr[i7] < 0) {
                                            i7 = i2 + 9;
                                            if (bArr[i9] < 0) {
                                                int i12 = i2 + 10;
                                                if (bArr[i7] >= 0) {
                                                    i5 = i12;
                                                    i = i11;
                                                }
                                            }
                                        }
                                    }
                                }
                                i = i11;
                            }
                            i = i11;
                        }
                        i5 = i9;
                    }
                    i5 = i7;
                }
                this.zzh = i5;
                return i;
            }
        }
        return (int) zzm();
    }

    @Override
    public final int zzg() throws IOException {
        return zzw();
    }

    @Override
    public final int zzh() throws IOException {
        return zze(zzx());
    }

    @Override
    public final int zzi() throws IOException {
        if (zzt()) {
            this.zzj = 0;
            return 0;
        }
        int iZzx = zzx();
        this.zzj = iZzx;
        if ((iZzx >>> 3) != 0) {
            return iZzx;
        }
        throw zzji.zzc();
    }

    @Override
    public final int zzj() throws IOException {
        return zzx();
    }

    @Override
    public final long zzk() throws IOException {
        return zzy();
    }

    @Override
    public final long zzl() throws IOException {
        return zzz();
    }

    private final long zzy() throws IOException {
        int i = this.zzh;
        if (this.zzf - i < 8) {
            throw zzji.zzh();
        }
        byte[] bArr = this.zzd;
        this.zzh = i + 8;
        return ((((long) bArr[i + 7]) & 255) << 56) | (((long) bArr[i]) & 255) | ((((long) bArr[i + 1]) & 255) << 8) | ((((long) bArr[i + 2]) & 255) << 16) | ((((long) bArr[i + 3]) & 255) << 24) | ((((long) bArr[i + 4]) & 255) << 32) | ((((long) bArr[i + 5]) & 255) << 40) | ((((long) bArr[i + 6]) & 255) << 48);
    }

    private final long zzz() throws IOException {
        long j;
        long j2;
        long j3;
        int i = this.zzh;
        int i2 = this.zzf;
        if (i2 != i) {
            byte[] bArr = this.zzd;
            int i3 = i + 1;
            byte b = bArr[i];
            if (b >= 0) {
                this.zzh = i3;
                return b;
            }
            if (i2 - i3 >= 9) {
                int i4 = i + 2;
                int i5 = (bArr[i3] << 7) ^ b;
                if (i5 < 0) {
                    j = i5 ^ (-128);
                } else {
                    int i6 = i + 3;
                    int i7 = (bArr[i4] << Ascii.f90SO) ^ i5;
                    if (i7 >= 0) {
                        j = i7 ^ 16256;
                        i4 = i6;
                    } else {
                        int i8 = i + 4;
                        int i9 = i7 ^ (bArr[i6] << Ascii.NAK);
                        if (i9 < 0) {
                            long j4 = (-2080896) ^ i9;
                            i4 = i8;
                            j = j4;
                        } else {
                            long j5 = i9;
                            i4 = i + 5;
                            long j6 = j5 ^ (((long) bArr[i8]) << 28);
                            if (j6 >= 0) {
                                j3 = 266354560;
                            } else {
                                int i10 = i + 6;
                                long j7 = j6 ^ (((long) bArr[i4]) << 35);
                                if (j7 < 0) {
                                    j2 = -34093383808L;
                                } else {
                                    i4 = i + 7;
                                    j6 = j7 ^ (((long) bArr[i10]) << 42);
                                    if (j6 >= 0) {
                                        j3 = 4363953127296L;
                                    } else {
                                        i10 = i + 8;
                                        j7 = j6 ^ (((long) bArr[i4]) << 49);
                                        if (j7 < 0) {
                                            j2 = -558586000294016L;
                                        } else {
                                            i4 = i + 9;
                                            long j8 = (j7 ^ (((long) bArr[i10]) << 56)) ^ 71499008037633920L;
                                            if (j8 < 0) {
                                                int i11 = i + 10;
                                                if (bArr[i4] >= 0) {
                                                    i4 = i11;
                                                }
                                            }
                                            j = j8;
                                        }
                                    }
                                }
                                j = j7 ^ j2;
                                i4 = i10;
                            }
                            j = j6 ^ j3;
                        }
                    }
                }
                this.zzh = i4;
                return j;
            }
        }
        return zzm();
    }

    @Override
    final long zzm() throws IOException {
        long j = 0;
        for (int i = 0; i < 64; i += 7) {
            byte bZzv = zzv();
            j |= ((long) (bZzv & Ascii.DEL)) << i;
            if ((bZzv & UnsignedBytes.MAX_POWER_OF_TWO) == 0) {
                return j;
            }
        }
        throw zzji.zze();
    }

    @Override
    public final long zzn() throws IOException {
        return zzy();
    }

    @Override
    public final long zzo() throws IOException {
        return zza(zzz());
    }

    @Override
    public final long zzp() throws IOException {
        return zzz();
    }

    @Override
    public final zzhm zzq() throws IOException {
        byte[] bArrCopyOfRange;
        int iZzx = zzx();
        if (iZzx > 0) {
            int i = this.zzf;
            int i2 = this.zzh;
            if (iZzx <= i - i2) {
                zzhm zzhmVarZza = zzhm.zza(this.zzd, i2, iZzx);
                this.zzh += iZzx;
                return zzhmVarZza;
            }
        }
        if (iZzx == 0) {
            return zzhm.zza;
        }
        if (iZzx > 0) {
            int i3 = this.zzf;
            int i4 = this.zzh;
            if (iZzx <= i3 - i4) {
                int i5 = iZzx + i4;
                this.zzh = i5;
                bArrCopyOfRange = Arrays.copyOfRange(this.zzd, i4, i5);
            } else {
                if (iZzx <= 0) {
                    throw zzji.zzh();
                }
                if (iZzx == 0) {
                    bArrCopyOfRange = zziz.zzb;
                } else {
                    throw zzji.zzf();
                }
            }
        } else {
            if (iZzx <= 0) {
                throw zzji.zzh();
            }
            if (iZzx == 0) {
                bArrCopyOfRange = zziz.zzb;
            } else {
                throw zzji.zzf();
            }
        }
        return zzhm.zza(bArrCopyOfRange);
    }

    @Override
    public final String zzr() throws IOException {
        int iZzx = zzx();
        if (iZzx > 0 && iZzx <= this.zzf - this.zzh) {
            String str = new String(this.zzd, this.zzh, iZzx, zziz.zza);
            this.zzh += iZzx;
            return str;
        }
        if (iZzx == 0) {
            return "";
        }
        if (iZzx < 0) {
            throw zzji.zzf();
        }
        throw zzji.zzh();
    }

    @Override
    public final String zzs() throws IOException {
        int iZzx = zzx();
        if (iZzx > 0) {
            int i = this.zzf;
            int i2 = this.zzh;
            if (iZzx <= i - i2) {
                String strZzb = zzmh.zzb(this.zzd, i2, iZzx);
                this.zzh += iZzx;
                return strZzb;
            }
        }
        if (iZzx == 0) {
            return "";
        }
        if (iZzx <= 0) {
            throw zzji.zzf();
        }
        throw zzji.zzh();
    }

    private zzia(byte[] bArr, int i, int i2, boolean z) {
        super();
        this.zzk = Api.BaseClientBuilder.API_PRIORITY_OTHER;
        this.zzd = bArr;
        this.zzf = i2 + i;
        this.zzh = i;
        this.zzi = i;
        this.zze = z;
    }

    @Override
    public final void zzb(int i) throws zzji {
        if (this.zzj != i) {
            throw zzji.zzb();
        }
    }

    @Override
    public final void zzc(int i) {
        this.zzk = i;
        zzaa();
    }

    private final void zzaa() {
        int i = this.zzf + this.zzg;
        this.zzf = i;
        int i2 = i - this.zzi;
        int i3 = this.zzk;
        if (i2 > i3) {
            int i4 = i2 - i3;
            this.zzg = i4;
            this.zzf = i - i4;
            return;
        }
        this.zzg = 0;
    }

    private final void zzf(int i) throws IOException {
        if (i >= 0) {
            int i2 = this.zzf;
            int i3 = this.zzh;
            if (i <= i2 - i3) {
                this.zzh = i3 + i;
                return;
            }
        }
        if (i < 0) {
            throw zzji.zzf();
        }
        throw zzji.zzh();
    }

    @Override
    public final boolean zzt() throws IOException {
        return this.zzh == this.zzf;
    }

    @Override
    public final boolean zzu() throws IOException {
        return zzz() != 0;
    }

    @Override
    public final boolean zzd(int i) throws IOException {
        int iZzi;
        int i2 = i & 7;
        int i3 = 0;
        if (i2 == 0) {
            if (this.zzf - this.zzh >= 10) {
                while (i3 < 10) {
                    byte[] bArr = this.zzd;
                    int i4 = this.zzh;
                    this.zzh = i4 + 1;
                    if (bArr[i4] < 0) {
                        i3++;
                    }
                }
                throw zzji.zze();
            }
            while (i3 < 10) {
                if (zzv() < 0) {
                    i3++;
                }
            }
            throw zzji.zze();
            return true;
        }
        if (i2 == 1) {
            zzf(8);
            return true;
        }
        if (i2 == 2) {
            zzf(zzx());
            return true;
        }
        if (i2 != 3) {
            if (i2 == 4) {
                return false;
            }
            if (i2 == 5) {
                zzf(4);
                return true;
            }
            throw zzji.zza();
        }
        do {
            iZzi = zzi();
            if (iZzi == 0) {
                break;
            }
        } while (zzd(iZzi));
        zzb(((i >>> 3) << 3) | 4);
        return true;
    }
}
