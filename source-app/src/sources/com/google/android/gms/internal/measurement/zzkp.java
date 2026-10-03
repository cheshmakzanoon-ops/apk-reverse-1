package com.google.android.gms.internal.measurement;

import java.io.IOException;
import java.util.Iterator;
import java.util.Map;

final class zzkp<T> implements zzlb<T> {
    private final zzkj zza;
    private final zzma<?, ?> zzb;
    private final boolean zzc;
    private final zzim<?> zzd;

    @Override
    public final int zza(T t) {
        zzma<?, ?> zzmaVar = this.zzb;
        int iZzb = zzmaVar.zzb(zzmaVar.zzd(t));
        return this.zzc ? iZzb + this.zzd.zza(t).zza() : iZzb;
    }

    @Override
    public final int zzb(T t) {
        int iHashCode = this.zzb.zzd(t).hashCode();
        return this.zzc ? (iHashCode * 53) + this.zzd.zza(t).hashCode() : iHashCode;
    }

    static <T> zzkp<T> zza(zzma<?, ?> zzmaVar, zzim<?> zzimVar, zzkj zzkjVar) {
        return new zzkp<>(zzmaVar, zzimVar, zzkjVar);
    }

    @Override
    public final T zza() {
        zzkj zzkjVar = this.zza;
        if (zzkjVar instanceof zzix) {
            return (T) ((zzix) zzkjVar).zzbz();
        }
        return (T) zzkjVar.zzcd().zzac();
    }

    private zzkp(zzma<?, ?> zzmaVar, zzim<?> zzimVar, zzkj zzkjVar) {
        this.zzb = zzmaVar;
        this.zzc = zzimVar.zza(zzkjVar);
        this.zzd = zzimVar;
        this.zza = zzkjVar;
    }

    @Override
    public final void zzc(T t) {
        this.zzb.zzf(t);
        this.zzd.zzc(t);
    }

    @Override
    public final void zza(T t, T t2) {
        zzld.zza(this.zzb, t, t2);
        if (this.zzc) {
            zzld.zza(this.zzd, t, t2);
        }
    }

    @Override
    public final void zza(T t, zzlc zzlcVar, zzik zzikVar) throws IOException {
        boolean zZzt;
        zzma<?, ?> zzmaVar = this.zzb;
        zzim<?> zzimVar = this.zzd;
        Object objZzc = zzmaVar.zzc(t);
        zziq<T> zziqVarZzb = zzimVar.zzb(t);
        while (zzlcVar.zzc() != Integer.MAX_VALUE) {
            try {
                int iZzd = zzlcVar.zzd();
                if (iZzd != 11) {
                    if ((iZzd & 7) == 2) {
                        Object objZza = zzimVar.zza(zzikVar, this.zza, iZzd >>> 3);
                        if (objZza != null) {
                            zzimVar.zza(zzlcVar, objZza, zzikVar, zziqVarZzb);
                        } else {
                            zZzt = zzmaVar.zza(objZzc, zzlcVar);
                        }
                    } else {
                        zZzt = zzlcVar.zzt();
                    }
                    if (!zZzt) {
                        zzmaVar.zzb(t, objZzc);
                        return;
                    }
                } else {
                    Object objZza2 = null;
                    int iZzj = 0;
                    zzhm zzhmVarZzp = null;
                    while (zzlcVar.zzc() != Integer.MAX_VALUE) {
                        int iZzd2 = zzlcVar.zzd();
                        if (iZzd2 == 16) {
                            iZzj = zzlcVar.zzj();
                            objZza2 = zzimVar.zza(zzikVar, this.zza, iZzj);
                        } else if (iZzd2 == 26) {
                            if (objZza2 != null) {
                                zzimVar.zza(zzlcVar, objZza2, zzikVar, zziqVarZzb);
                            } else {
                                zzhmVarZzp = zzlcVar.zzp();
                            }
                        } else if (!zzlcVar.zzt()) {
                            break;
                        }
                    }
                    if (zzlcVar.zzd() != 12) {
                        throw zzji.zzb();
                    }
                    if (zzhmVarZzp != null) {
                        if (objZza2 != null) {
                            zzimVar.zza(zzhmVarZzp, objZza2, zzikVar, zziqVarZzb);
                        } else {
                            zzmaVar.zza(objZzc, iZzj, zzhmVarZzp);
                        }
                    }
                }
                zZzt = true;
                if (!zZzt) {
                    zzmaVar.zzb(t, objZzc);
                    return;
                }
            } catch (Throwable th) {
                zzmaVar.zzb(t, objZzc);
                throw th;
            }
        }
        zzmaVar.zzb(t, objZzc);
    }

    @Override
    public final void zza(T t, byte[] bArr, int i, int i2, zzhl zzhlVar) throws IOException {
        zzix zzixVar = (zzix) t;
        zzlz zzlzVarZzd = zzixVar.zzb;
        if (zzlzVarZzd == zzlz.zzc()) {
            zzlzVarZzd = zzlz.zzd();
            zzixVar.zzb = zzlzVarZzd;
        }
        ((zzix.zzd) t).zza();
        zzix.zzf zzfVar = null;
        while (i < i2) {
            int iZzc = zzhi.zzc(bArr, i, zzhlVar);
            int i3 = zzhlVar.zza;
            if (i3 == 11) {
                int i4 = 0;
                zzhm zzhmVar = null;
                while (iZzc < i2) {
                    iZzc = zzhi.zzc(bArr, iZzc, zzhlVar);
                    int i5 = zzhlVar.zza;
                    int i6 = i5 >>> 3;
                    int i7 = i5 & 7;
                    if (i6 == 2) {
                        if (i7 != 0) {
                            if (i5 != 12) {
                                break;
                                break;
                            }
                            iZzc = zzhi.zza(i5, bArr, iZzc, i2, zzhlVar);
                        } else {
                            iZzc = zzhi.zzc(bArr, iZzc, zzhlVar);
                            i4 = zzhlVar.zza;
                            zzfVar = (zzix.zzf) this.zzd.zza(zzhlVar.zzd, this.zza, i4);
                        }
                    } else {
                        if (i6 == 3) {
                            if (zzfVar != null) {
                                zzkx.zza();
                                throw new NoSuchMethodError();
                            }
                            if (i7 == 2) {
                                iZzc = zzhi.zza(bArr, iZzc, zzhlVar);
                                zzhmVar = (zzhm) zzhlVar.zzc;
                            }
                        }
                        if (i5 != 12) {
                            break;
                        } else {
                            iZzc = zzhi.zza(i5, bArr, iZzc, i2, zzhlVar);
                        }
                    }
                }
                if (zzhmVar != null) {
                    zzlzVarZzd.zza((i4 << 3) | 2, zzhmVar);
                }
                i = iZzc;
            } else if ((i3 & 7) == 2) {
                zzfVar = (zzix.zzf) this.zzd.zza(zzhlVar.zzd, this.zza, i3 >>> 3);
                if (zzfVar != null) {
                    zzkx.zza();
                    throw new NoSuchMethodError();
                }
                i = zzhi.zza(i3, bArr, iZzc, i2, zzlzVarZzd, zzhlVar);
            } else {
                i = zzhi.zza(i3, bArr, iZzc, i2, zzhlVar);
            }
        }
        if (i != i2) {
            throw zzji.zzg();
        }
    }

    @Override
    public final void zza(T t, zzmw zzmwVar) throws IOException {
        Iterator itZzd = this.zzd.zza(t).zzd();
        while (itZzd.hasNext()) {
            Map.Entry entry = (Map.Entry) itZzd.next();
            zzis zzisVar = (zzis) entry.getKey();
            if (zzisVar.zzc() != zzmx.MESSAGE || zzisVar.zze() || zzisVar.zzd()) {
                throw new IllegalStateException("Found invalid MessageSet item.");
            }
            if (entry instanceof zzjm) {
                zzmwVar.zza(zzisVar.zza(), (Object) ((zzjm) entry).zza().zzc());
            } else {
                zzmwVar.zza(zzisVar.zza(), entry.getValue());
            }
        }
        zzma<?, ?> zzmaVar = this.zzb;
        zzmaVar.zza(zzmaVar.zzd(t), zzmwVar);
    }

    @Override
    public final boolean zzb(T t, T t2) {
        if (!this.zzb.zzd(t).equals(this.zzb.zzd(t2))) {
            return false;
        }
        if (this.zzc) {
            return this.zzd.zza(t).equals(this.zzd.zza(t2));
        }
        return true;
    }

    @Override
    public final boolean zzd(T t) {
        return this.zzd.zza(t).zzg();
    }
}
