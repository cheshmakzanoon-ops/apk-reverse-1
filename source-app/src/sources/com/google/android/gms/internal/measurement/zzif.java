package com.google.android.gms.internal.measurement;

import com.google.android.gms.common.api.Api;
import com.ishumei.smantifraud.l111l1111llIl;
import java.io.IOException;
import java.util.List;
import java.util.Map;

final class zzif implements zzlc {
    private final zzib zza;
    private int zzb;
    private int zzc;
    private int zzd = 0;

    @Override
    public final double zza() throws IOException {
        zzb(1);
        return this.zza.zza();
    }

    @Override
    public final float zzb() throws IOException {
        zzb(5);
        return this.zza.zzb();
    }

    @Override
    public final int zzc() throws IOException {
        int i = this.zzd;
        if (i != 0) {
            this.zzb = i;
            this.zzd = 0;
        } else {
            this.zzb = this.zza.zzi();
        }
        int i2 = this.zzb;
        return (i2 == 0 || i2 == this.zzc) ? Api.BaseClientBuilder.API_PRIORITY_OTHER : i2 >>> 3;
    }

    @Override
    public final int zzd() {
        return this.zzb;
    }

    @Override
    public final int zze() throws IOException {
        zzb(0);
        return this.zza.zzd();
    }

    @Override
    public final int zzf() throws IOException {
        zzb(5);
        return this.zza.zze();
    }

    @Override
    public final int zzg() throws IOException {
        zzb(0);
        return this.zza.zzf();
    }

    @Override
    public final int zzh() throws IOException {
        zzb(5);
        return this.zza.zzg();
    }

    @Override
    public final int zzi() throws IOException {
        zzb(0);
        return this.zza.zzh();
    }

    @Override
    public final int zzj() throws IOException {
        zzb(0);
        return this.zza.zzj();
    }

    @Override
    public final long zzk() throws IOException {
        zzb(1);
        return this.zza.zzk();
    }

    @Override
    public final long zzl() throws IOException {
        zzb(0);
        return this.zza.zzl();
    }

    @Override
    public final long zzm() throws IOException {
        zzb(1);
        return this.zza.zzn();
    }

    @Override
    public final long zzn() throws IOException {
        zzb(0);
        return this.zza.zzo();
    }

    @Override
    public final long zzo() throws IOException {
        zzb(0);
        return this.zza.zzp();
    }

    @Override
    public final zzhm zzp() throws IOException {
        zzb(2);
        return this.zza.zzq();
    }

    public static zzif zza(zzib zzibVar) {
        if (zzibVar.zzc != null) {
            return zzibVar.zzc;
        }
        return new zzif(zzibVar);
    }

    private final Object zza(zzmn zzmnVar, Class<?> cls, zzik zzikVar) throws IOException {
        switch (zzie.zza[zzmnVar.ordinal()]) {
            case 1:
                return Boolean.valueOf(zzs());
            case 2:
                return zzp();
            case 3:
                return Double.valueOf(zza());
            case 4:
                return Integer.valueOf(zze());
            case 5:
                return Integer.valueOf(zzf());
            case 6:
                return Long.valueOf(zzk());
            case 7:
                return Float.valueOf(zzb());
            case 8:
                return Integer.valueOf(zzg());
            case 9:
                return Long.valueOf(zzl());
            case 10:
                zzb(2);
                return zzb(zzkx.zza().zza((Class) cls), zzikVar);
            case 11:
                return Integer.valueOf(zzh());
            case 12:
                return Long.valueOf(zzm());
            case 13:
                return Integer.valueOf(zzi());
            case 14:
                return Long.valueOf(zzn());
            case 15:
                return zzr();
            case 16:
                return Integer.valueOf(zzj());
            case 17:
                return Long.valueOf(zzo());
            default:
                throw new IllegalArgumentException("unsupported field type.");
        }
    }

    private final <T> T zza(zzlb<T> zzlbVar, zzik zzikVar) throws IOException {
        T tZza = zzlbVar.zza();
        zzc(tZza, zzlbVar, zzikVar);
        zzlbVar.zzc(tZza);
        return tZza;
    }

    private final <T> T zzb(zzlb<T> zzlbVar, zzik zzikVar) throws IOException {
        T tZza = zzlbVar.zza();
        zzd(tZza, zzlbVar, zzikVar);
        zzlbVar.zzc(tZza);
        return tZza;
    }

    @Override
    public final String zzq() throws IOException {
        zzb(2);
        return this.zza.zzr();
    }

    @Override
    public final String zzr() throws IOException {
        zzb(2);
        return this.zza.zzs();
    }

    private zzif(zzib zzibVar) {
        zzib zzibVar2 = (zzib) zziz.zza(zzibVar, l111l1111llIl.l111l111llIl);
        this.zza = zzibVar2;
        zzibVar2.zzc = this;
    }

    @Override
    public final <T> void zza(T t, zzlb<T> zzlbVar, zzik zzikVar) throws IOException {
        zzb(3);
        zzc(t, zzlbVar, zzikVar);
    }

    private final <T> void zzc(T t, zzlb<T> zzlbVar, zzik zzikVar) throws IOException {
        int i = this.zzc;
        this.zzc = ((this.zzb >>> 3) << 3) | 4;
        try {
            zzlbVar.zza(t, this, zzikVar);
            if (this.zzb != this.zzc) {
                throw zzji.zzg();
            }
            this.zzc = i;
        } catch (Throwable th) {
            this.zzc = i;
            throw th;
        }
    }

    @Override
    public final <T> void zzb(T t, zzlb<T> zzlbVar, zzik zzikVar) throws IOException {
        zzb(2);
        zzd(t, zzlbVar, zzikVar);
    }

    private final <T> void zzd(T t, zzlb<T> zzlbVar, zzik zzikVar) throws IOException {
        int iZzj = this.zza.zzj();
        if (this.zza.zza >= this.zza.zzb) {
            throw new zzji("Protocol message had too many levels of nesting.  May be malicious.  Use CodedInputStream.setRecursionLimit() to increase the depth limit.");
        }
        int iZza = this.zza.zza(iZzj);
        this.zza.zza++;
        zzlbVar.zza(t, this, zzikVar);
        this.zza.zzb(0);
        this.zza.zza--;
        this.zza.zzc(iZza);
    }

    @Override
    public final void zza(List<Boolean> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zzhk) {
            zzhk zzhkVar = (zzhk) list;
            int i = this.zzb & 7;
            if (i == 0) {
                do {
                    zzhkVar.zza(this.zza.zzu());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            if (i == 2) {
                int iZzc = this.zza.zzc() + this.zza.zzj();
                do {
                    zzhkVar.zza(this.zza.zzu());
                } while (this.zza.zzc() < iZzc);
                zza(iZzc);
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 0) {
            do {
                list.add(Boolean.valueOf(this.zza.zzu()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        if (i2 == 2) {
            int iZzc2 = this.zza.zzc() + this.zza.zzj();
            do {
                list.add(Boolean.valueOf(this.zza.zzu()));
            } while (this.zza.zzc() < iZzc2);
            zza(iZzc2);
            return;
        }
        throw zzji.zza();
    }

    @Override
    public final void zzb(List<zzhm> list) throws IOException {
        int iZzi;
        if ((this.zzb & 7) != 2) {
            throw zzji.zza();
        }
        do {
            list.add(zzp());
            if (this.zza.zzt()) {
                return;
            } else {
                iZzi = this.zza.zzi();
            }
        } while (iZzi == this.zzb);
        this.zzd = iZzi;
    }

    @Override
    public final void zzc(List<Double> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zzii) {
            zzii zziiVar = (zzii) list;
            int i = this.zzb & 7;
            if (i == 1) {
                do {
                    zziiVar.zza(this.zza.zza());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            if (i == 2) {
                int iZzj = this.zza.zzj();
                zzd(iZzj);
                int iZzc = this.zza.zzc() + iZzj;
                do {
                    zziiVar.zza(this.zza.zza());
                } while (this.zza.zzc() < iZzc);
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 1) {
            do {
                list.add(Double.valueOf(this.zza.zza()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        if (i2 == 2) {
            int iZzj2 = this.zza.zzj();
            zzd(iZzj2);
            int iZzc2 = this.zza.zzc() + iZzj2;
            do {
                list.add(Double.valueOf(this.zza.zza()));
            } while (this.zza.zzc() < iZzc2);
            return;
        }
        throw zzji.zza();
    }

    @Override
    public final void zzd(List<Integer> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zzja) {
            zzja zzjaVar = (zzja) list;
            int i = this.zzb & 7;
            if (i == 0) {
                do {
                    zzjaVar.zzd(this.zza.zzd());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            if (i == 2) {
                int iZzc = this.zza.zzc() + this.zza.zzj();
                do {
                    zzjaVar.zzd(this.zza.zzd());
                } while (this.zza.zzc() < iZzc);
                zza(iZzc);
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 0) {
            do {
                list.add(Integer.valueOf(this.zza.zzd()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        if (i2 == 2) {
            int iZzc2 = this.zza.zzc() + this.zza.zzj();
            do {
                list.add(Integer.valueOf(this.zza.zzd()));
            } while (this.zza.zzc() < iZzc2);
            zza(iZzc2);
            return;
        }
        throw zzji.zza();
    }

    @Override
    public final void zze(List<Integer> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zzja) {
            zzja zzjaVar = (zzja) list;
            int i = this.zzb & 7;
            if (i == 2) {
                int iZzj = this.zza.zzj();
                zzc(iZzj);
                int iZzc = this.zza.zzc() + iZzj;
                do {
                    zzjaVar.zzd(this.zza.zze());
                } while (this.zza.zzc() < iZzc);
                return;
            }
            if (i == 5) {
                do {
                    zzjaVar.zzd(this.zza.zze());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 2) {
            int iZzj2 = this.zza.zzj();
            zzc(iZzj2);
            int iZzc2 = this.zza.zzc() + iZzj2;
            do {
                list.add(Integer.valueOf(this.zza.zze()));
            } while (this.zza.zzc() < iZzc2);
            return;
        }
        if (i2 == 5) {
            do {
                list.add(Integer.valueOf(this.zza.zze()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        throw zzji.zza();
    }

    @Override
    public final void zzf(List<Long> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zzjy) {
            zzjy zzjyVar = (zzjy) list;
            int i = this.zzb & 7;
            if (i == 1) {
                do {
                    zzjyVar.zza(this.zza.zzk());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            if (i == 2) {
                int iZzj = this.zza.zzj();
                zzd(iZzj);
                int iZzc = this.zza.zzc() + iZzj;
                do {
                    zzjyVar.zza(this.zza.zzk());
                } while (this.zza.zzc() < iZzc);
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 1) {
            do {
                list.add(Long.valueOf(this.zza.zzk()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        if (i2 == 2) {
            int iZzj2 = this.zza.zzj();
            zzd(iZzj2);
            int iZzc2 = this.zza.zzc() + iZzj2;
            do {
                list.add(Long.valueOf(this.zza.zzk()));
            } while (this.zza.zzc() < iZzc2);
            return;
        }
        throw zzji.zza();
    }

    @Override
    public final void zzg(List<Float> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zziw) {
            zziw zziwVar = (zziw) list;
            int i = this.zzb & 7;
            if (i == 2) {
                int iZzj = this.zza.zzj();
                zzc(iZzj);
                int iZzc = this.zza.zzc() + iZzj;
                do {
                    zziwVar.zza(this.zza.zzb());
                } while (this.zza.zzc() < iZzc);
                return;
            }
            if (i == 5) {
                do {
                    zziwVar.zza(this.zza.zzb());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 2) {
            int iZzj2 = this.zza.zzj();
            zzc(iZzj2);
            int iZzc2 = this.zza.zzc() + iZzj2;
            do {
                list.add(Float.valueOf(this.zza.zzb()));
            } while (this.zza.zzc() < iZzc2);
            return;
        }
        if (i2 == 5) {
            do {
                list.add(Float.valueOf(this.zza.zzb()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        throw zzji.zza();
    }

    @Override
    @Deprecated
    public final <T> void zza(List<T> list, zzlb<T> zzlbVar, zzik zzikVar) throws IOException {
        int iZzi;
        int i = this.zzb;
        if ((i & 7) != 3) {
            throw zzji.zza();
        }
        do {
            list.add(zza(zzlbVar, zzikVar));
            if (this.zza.zzt() || this.zzd != 0) {
                return;
            } else {
                iZzi = this.zza.zzi();
            }
        } while (iZzi == i);
        this.zzd = iZzi;
    }

    @Override
    public final void zzh(List<Integer> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zzja) {
            zzja zzjaVar = (zzja) list;
            int i = this.zzb & 7;
            if (i == 0) {
                do {
                    zzjaVar.zzd(this.zza.zzf());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            if (i == 2) {
                int iZzc = this.zza.zzc() + this.zza.zzj();
                do {
                    zzjaVar.zzd(this.zza.zzf());
                } while (this.zza.zzc() < iZzc);
                zza(iZzc);
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 0) {
            do {
                list.add(Integer.valueOf(this.zza.zzf()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        if (i2 == 2) {
            int iZzc2 = this.zza.zzc() + this.zza.zzj();
            do {
                list.add(Integer.valueOf(this.zza.zzf()));
            } while (this.zza.zzc() < iZzc2);
            zza(iZzc2);
            return;
        }
        throw zzji.zza();
    }

    @Override
    public final void zzi(List<Long> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zzjy) {
            zzjy zzjyVar = (zzjy) list;
            int i = this.zzb & 7;
            if (i == 0) {
                do {
                    zzjyVar.zza(this.zza.zzl());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            if (i == 2) {
                int iZzc = this.zza.zzc() + this.zza.zzj();
                do {
                    zzjyVar.zza(this.zza.zzl());
                } while (this.zza.zzc() < iZzc);
                zza(iZzc);
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 0) {
            do {
                list.add(Long.valueOf(this.zza.zzl()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        if (i2 == 2) {
            int iZzc2 = this.zza.zzc() + this.zza.zzj();
            do {
                list.add(Long.valueOf(this.zza.zzl()));
            } while (this.zza.zzc() < iZzc2);
            zza(iZzc2);
            return;
        }
        throw zzji.zza();
    }

    @Override
    public final <K, V> void zza(Map<K, V> map, zzke<K, V> zzkeVar, zzik zzikVar) throws IOException {
        zzb(2);
        int iZza = this.zza.zza(this.zza.zzj());
        Object objZza = zzkeVar.zzb;
        Object objZza2 = zzkeVar.zzd;
        while (true) {
            try {
                int iZzc = zzc();
                if (iZzc == Integer.MAX_VALUE || this.zza.zzt()) {
                    break;
                }
                if (iZzc == 1) {
                    objZza = zza(zzkeVar.zza, (Class<?>) null, (zzik) null);
                } else if (iZzc == 2) {
                    objZza2 = zza(zzkeVar.zzc, zzkeVar.zzd.getClass(), zzikVar);
                } else {
                    try {
                        if (!zzt()) {
                            throw new zzji("Unable to parse map entry.");
                        }
                    } catch (zzjh unused) {
                        if (!zzt()) {
                            throw new zzji("Unable to parse map entry.");
                        }
                    }
                }
            } catch (Throwable th) {
                this.zza.zzc(iZza);
                throw th;
            }
        }
        map.put(objZza, objZza2);
        this.zza.zzc(iZza);
    }

    @Override
    public final <T> void zzb(List<T> list, zzlb<T> zzlbVar, zzik zzikVar) throws IOException {
        int iZzi;
        int i = this.zzb;
        if ((i & 7) != 2) {
            throw zzji.zza();
        }
        do {
            list.add(zzb(zzlbVar, zzikVar));
            if (this.zza.zzt() || this.zzd != 0) {
                return;
            } else {
                iZzi = this.zza.zzi();
            }
        } while (iZzi == i);
        this.zzd = iZzi;
    }

    @Override
    public final void zzj(List<Integer> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zzja) {
            zzja zzjaVar = (zzja) list;
            int i = this.zzb & 7;
            if (i == 2) {
                int iZzj = this.zza.zzj();
                zzc(iZzj);
                int iZzc = this.zza.zzc() + iZzj;
                do {
                    zzjaVar.zzd(this.zza.zzg());
                } while (this.zza.zzc() < iZzc);
                return;
            }
            if (i == 5) {
                do {
                    zzjaVar.zzd(this.zza.zzg());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 2) {
            int iZzj2 = this.zza.zzj();
            zzc(iZzj2);
            int iZzc2 = this.zza.zzc() + iZzj2;
            do {
                list.add(Integer.valueOf(this.zza.zzg()));
            } while (this.zza.zzc() < iZzc2);
            return;
        }
        if (i2 == 5) {
            do {
                list.add(Integer.valueOf(this.zza.zzg()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        throw zzji.zza();
    }

    @Override
    public final void zzk(List<Long> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zzjy) {
            zzjy zzjyVar = (zzjy) list;
            int i = this.zzb & 7;
            if (i == 1) {
                do {
                    zzjyVar.zza(this.zza.zzn());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            if (i == 2) {
                int iZzj = this.zza.zzj();
                zzd(iZzj);
                int iZzc = this.zza.zzc() + iZzj;
                do {
                    zzjyVar.zza(this.zza.zzn());
                } while (this.zza.zzc() < iZzc);
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 1) {
            do {
                list.add(Long.valueOf(this.zza.zzn()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        if (i2 == 2) {
            int iZzj2 = this.zza.zzj();
            zzd(iZzj2);
            int iZzc2 = this.zza.zzc() + iZzj2;
            do {
                list.add(Long.valueOf(this.zza.zzn()));
            } while (this.zza.zzc() < iZzc2);
            return;
        }
        throw zzji.zza();
    }

    @Override
    public final void zzl(List<Integer> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zzja) {
            zzja zzjaVar = (zzja) list;
            int i = this.zzb & 7;
            if (i == 0) {
                do {
                    zzjaVar.zzd(this.zza.zzh());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            if (i == 2) {
                int iZzc = this.zza.zzc() + this.zza.zzj();
                do {
                    zzjaVar.zzd(this.zza.zzh());
                } while (this.zza.zzc() < iZzc);
                zza(iZzc);
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 0) {
            do {
                list.add(Integer.valueOf(this.zza.zzh()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        if (i2 == 2) {
            int iZzc2 = this.zza.zzc() + this.zza.zzj();
            do {
                list.add(Integer.valueOf(this.zza.zzh()));
            } while (this.zza.zzc() < iZzc2);
            zza(iZzc2);
            return;
        }
        throw zzji.zza();
    }

    @Override
    public final void zzm(List<Long> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zzjy) {
            zzjy zzjyVar = (zzjy) list;
            int i = this.zzb & 7;
            if (i == 0) {
                do {
                    zzjyVar.zza(this.zza.zzo());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            if (i == 2) {
                int iZzc = this.zza.zzc() + this.zza.zzj();
                do {
                    zzjyVar.zza(this.zza.zzo());
                } while (this.zza.zzc() < iZzc);
                zza(iZzc);
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 0) {
            do {
                list.add(Long.valueOf(this.zza.zzo()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        if (i2 == 2) {
            int iZzc2 = this.zza.zzc() + this.zza.zzj();
            do {
                list.add(Long.valueOf(this.zza.zzo()));
            } while (this.zza.zzc() < iZzc2);
            zza(iZzc2);
            return;
        }
        throw zzji.zza();
    }

    @Override
    public final void zzn(List<String> list) throws IOException {
        zza(list, false);
    }

    private final void zza(List<String> list, boolean z) throws IOException {
        int iZzi;
        int iZzi2;
        if ((this.zzb & 7) != 2) {
            throw zzji.zza();
        }
        if ((list instanceof zzjp) && !z) {
            zzjp zzjpVar = (zzjp) list;
            do {
                zzjpVar.zza(zzp());
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi2 = this.zza.zzi();
                }
            } while (iZzi2 == this.zzb);
            this.zzd = iZzi2;
            return;
        }
        do {
            list.add(z ? zzr() : zzq());
            if (this.zza.zzt()) {
                return;
            } else {
                iZzi = this.zza.zzi();
            }
        } while (iZzi == this.zzb);
        this.zzd = iZzi;
    }

    @Override
    public final void zzo(List<String> list) throws IOException {
        zza(list, true);
    }

    @Override
    public final void zzp(List<Integer> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zzja) {
            zzja zzjaVar = (zzja) list;
            int i = this.zzb & 7;
            if (i == 0) {
                do {
                    zzjaVar.zzd(this.zza.zzj());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            if (i == 2) {
                int iZzc = this.zza.zzc() + this.zza.zzj();
                do {
                    zzjaVar.zzd(this.zza.zzj());
                } while (this.zza.zzc() < iZzc);
                zza(iZzc);
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 0) {
            do {
                list.add(Integer.valueOf(this.zza.zzj()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        if (i2 == 2) {
            int iZzc2 = this.zza.zzc() + this.zza.zzj();
            do {
                list.add(Integer.valueOf(this.zza.zzj()));
            } while (this.zza.zzc() < iZzc2);
            zza(iZzc2);
            return;
        }
        throw zzji.zza();
    }

    @Override
    public final void zzq(List<Long> list) throws IOException {
        int iZzi;
        int iZzi2;
        if (list instanceof zzjy) {
            zzjy zzjyVar = (zzjy) list;
            int i = this.zzb & 7;
            if (i == 0) {
                do {
                    zzjyVar.zza(this.zza.zzp());
                    if (this.zza.zzt()) {
                        return;
                    } else {
                        iZzi2 = this.zza.zzi();
                    }
                } while (iZzi2 == this.zzb);
                this.zzd = iZzi2;
                return;
            }
            if (i == 2) {
                int iZzc = this.zza.zzc() + this.zza.zzj();
                do {
                    zzjyVar.zza(this.zza.zzp());
                } while (this.zza.zzc() < iZzc);
                zza(iZzc);
                return;
            }
            throw zzji.zza();
        }
        int i2 = this.zzb & 7;
        if (i2 == 0) {
            do {
                list.add(Long.valueOf(this.zza.zzp()));
                if (this.zza.zzt()) {
                    return;
                } else {
                    iZzi = this.zza.zzi();
                }
            } while (iZzi == this.zzb);
            this.zzd = iZzi;
            return;
        }
        if (i2 == 2) {
            int iZzc2 = this.zza.zzc() + this.zza.zzj();
            do {
                list.add(Long.valueOf(this.zza.zzp()));
            } while (this.zza.zzc() < iZzc2);
            zza(iZzc2);
            return;
        }
        throw zzji.zza();
    }

    private final void zza(int i) throws IOException {
        if (this.zza.zzc() != i) {
            throw zzji.zzh();
        }
    }

    private final void zzb(int i) throws IOException {
        if ((this.zzb & 7) != i) {
            throw zzji.zza();
        }
    }

    private static void zzc(int i) throws IOException {
        if ((i & 3) != 0) {
            throw zzji.zzg();
        }
    }

    private static void zzd(int i) throws IOException {
        if ((i & 7) != 0) {
            throw zzji.zzg();
        }
    }

    @Override
    public final boolean zzs() throws IOException {
        zzb(0);
        return this.zza.zzu();
    }

    @Override
    public final boolean zzt() throws IOException {
        int i;
        if (this.zza.zzt() || (i = this.zzb) == this.zzc) {
            return false;
        }
        return this.zza.zzd(i);
    }
}
