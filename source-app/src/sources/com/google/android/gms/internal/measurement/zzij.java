package com.google.android.gms.internal.measurement;

import java.io.IOException;
import java.util.List;
import java.util.Map;

final class zzij implements zzmw {
    private final zzig zza;

    public static zzij zza(zzig zzigVar) {
        return zzigVar.zza != null ? zzigVar.zza : new zzij(zzigVar);
    }

    @Override
    public final int zza() {
        return zzmz.zza;
    }

    private zzij(zzig zzigVar) {
        zzig zzigVar2 = (zzig) zziz.zza(zzigVar, "output");
        this.zza = zzigVar2;
        zzigVar2.zza = this;
    }

    @Override
    public final void zza(int i, boolean z) throws IOException {
        this.zza.zza(i, z);
    }

    @Override
    public final void zza(int i, List<Boolean> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZza = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZza += zzig.zza(list.get(i3).booleanValue());
            }
            this.zza.zzc(iZza);
            while (i2 < list.size()) {
                this.zza.zzb(list.get(i2).booleanValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zza(i, list.get(i2).booleanValue());
            i2++;
        }
    }

    @Override
    public final void zza(int i, zzhm zzhmVar) throws IOException {
        this.zza.zza(i, zzhmVar);
    }

    @Override
    public final void zza(int i, List<zzhm> list) throws IOException {
        for (int i2 = 0; i2 < list.size(); i2++) {
            this.zza.zza(i, list.get(i2));
        }
    }

    @Override
    public final void zza(int i, double d) throws IOException {
        this.zza.zzb(i, d);
    }

    @Override
    public final void zzb(int i, List<Double> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZza = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZza += zzig.zza(list.get(i3).doubleValue());
            }
            this.zza.zzc(iZza);
            while (i2 < list.size()) {
                this.zza.zzb(list.get(i2).doubleValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zzb(i, list.get(i2).doubleValue());
            i2++;
        }
    }

    @Override
    @Deprecated
    public final void zza(int i) throws IOException {
        this.zza.zzc(i, 4);
    }

    @Override
    public final void zza(int i, int i2) throws IOException {
        this.zza.zzb(i, i2);
    }

    @Override
    public final void zzc(int i, List<Integer> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZzd = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzd += zzig.zzd(list.get(i3).intValue());
            }
            this.zza.zzc(iZzd);
            while (i2 < list.size()) {
                this.zza.zzb(list.get(i2).intValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zzb(i, list.get(i2).intValue());
            i2++;
        }
    }

    @Override
    public final void zzb(int i, int i2) throws IOException {
        this.zza.zza(i, i2);
    }

    @Override
    public final void zzd(int i, List<Integer> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZze = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZze += zzig.zze(list.get(i3).intValue());
            }
            this.zza.zzc(iZze);
            while (i2 < list.size()) {
                this.zza.zza(list.get(i2).intValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zza(i, list.get(i2).intValue());
            i2++;
        }
    }

    @Override
    public final void zza(int i, long j) throws IOException {
        this.zza.zza(i, j);
    }

    @Override
    public final void zze(int i, List<Long> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZzc = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzc += zzig.zzc(list.get(i3).longValue());
            }
            this.zza.zzc(iZzc);
            while (i2 < list.size()) {
                this.zza.zza(list.get(i2).longValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zza(i, list.get(i2).longValue());
            i2++;
        }
    }

    @Override
    public final void zza(int i, float f) throws IOException {
        this.zza.zzb(i, f);
    }

    @Override
    public final void zzf(int i, List<Float> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZza = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZza += zzig.zza(list.get(i3).floatValue());
            }
            this.zza.zzc(iZza);
            while (i2 < list.size()) {
                this.zza.zzb(list.get(i2).floatValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zzb(i, list.get(i2).floatValue());
            i2++;
        }
    }

    @Override
    public final void zza(int i, Object obj, zzlb zzlbVar) throws IOException {
        zzig zzigVar = this.zza;
        zzigVar.zzc(i, 3);
        zzlbVar.zza((zzkj) obj, zzigVar.zza);
        zzigVar.zzc(i, 4);
    }

    @Override
    public final void zza(int i, List<?> list, zzlb zzlbVar) throws IOException {
        for (int i2 = 0; i2 < list.size(); i2++) {
            zza(i, list.get(i2), zzlbVar);
        }
    }

    @Override
    public final void zzc(int i, int i2) throws IOException {
        this.zza.zzb(i, i2);
    }

    @Override
    public final void zzg(int i, List<Integer> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZzf = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzf += zzig.zzf(list.get(i3).intValue());
            }
            this.zza.zzc(iZzf);
            while (i2 < list.size()) {
                this.zza.zzb(list.get(i2).intValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zzb(i, list.get(i2).intValue());
            i2++;
        }
    }

    @Override
    public final void zzb(int i, long j) throws IOException {
        this.zza.zzb(i, j);
    }

    @Override
    public final void zzh(int i, List<Long> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZzd = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzd += zzig.zzd(list.get(i3).longValue());
            }
            this.zza.zzc(iZzd);
            while (i2 < list.size()) {
                this.zza.zzb(list.get(i2).longValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zzb(i, list.get(i2).longValue());
            i2++;
        }
    }

    @Override
    public final <K, V> void zza(int i, zzke<K, V> zzkeVar, Map<K, V> map) throws IOException {
        for (Map.Entry<K, V> entry : map.entrySet()) {
            this.zza.zzc(i, 2);
            this.zza.zzc(zzkb.zza(zzkeVar, entry.getKey(), entry.getValue()));
            zzkb.zza(this.zza, zzkeVar, entry.getKey(), entry.getValue());
        }
    }

    @Override
    public final void zzb(int i, Object obj, zzlb zzlbVar) throws IOException {
        this.zza.zza(i, (zzkj) obj, zzlbVar);
    }

    @Override
    public final void zzb(int i, List<?> list, zzlb zzlbVar) throws IOException {
        for (int i2 = 0; i2 < list.size(); i2++) {
            zzb(i, list.get(i2), zzlbVar);
        }
    }

    @Override
    public final void zza(int i, Object obj) throws IOException {
        if (obj instanceof zzhm) {
            this.zza.zzb(i, (zzhm) obj);
        } else {
            this.zza.zza(i, (zzkj) obj);
        }
    }

    @Override
    public final void zzd(int i, int i2) throws IOException {
        this.zza.zza(i, i2);
    }

    @Override
    public final void zzi(int i, List<Integer> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZzg = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzg += zzig.zzg(list.get(i3).intValue());
            }
            this.zza.zzc(iZzg);
            while (i2 < list.size()) {
                this.zza.zza(list.get(i2).intValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zza(i, list.get(i2).intValue());
            i2++;
        }
    }

    @Override
    public final void zzc(int i, long j) throws IOException {
        this.zza.zza(i, j);
    }

    @Override
    public final void zzj(int i, List<Long> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZze = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZze += zzig.zze(list.get(i3).longValue());
            }
            this.zza.zzc(iZze);
            while (i2 < list.size()) {
                this.zza.zza(list.get(i2).longValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zza(i, list.get(i2).longValue());
            i2++;
        }
    }

    @Override
    public final void zze(int i, int i2) throws IOException {
        this.zza.zzk(i, i2);
    }

    @Override
    public final void zzk(int i, List<Integer> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZzh = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzh += zzig.zzh(list.get(i3).intValue());
            }
            this.zza.zzc(iZzh);
            while (i2 < list.size()) {
                this.zza.zzk(list.get(i2).intValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zzk(i, list.get(i2).intValue());
            i2++;
        }
    }

    @Override
    public final void zzd(int i, long j) throws IOException {
        this.zza.zzh(i, j);
    }

    @Override
    public final void zzl(int i, List<Long> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZzf = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzf += zzig.zzf(list.get(i3).longValue());
            }
            this.zza.zzc(iZzf);
            while (i2 < list.size()) {
                this.zza.zzh(list.get(i2).longValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zzh(i, list.get(i2).longValue());
            i2++;
        }
    }

    @Override
    @Deprecated
    public final void zzb(int i) throws IOException {
        this.zza.zzc(i, 3);
    }

    @Override
    public final void zza(int i, String str) throws IOException {
        this.zza.zza(i, str);
    }

    @Override
    public final void zzb(int i, List<String> list) throws IOException {
        int i2 = 0;
        if (list instanceof zzjp) {
            zzjp zzjpVar = (zzjp) list;
            while (i2 < list.size()) {
                Object objZzb = zzjpVar.zzb(i2);
                if (objZzb instanceof String) {
                    this.zza.zza(i, (String) objZzb);
                } else {
                    this.zza.zza(i, (zzhm) objZzb);
                }
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zza(i, list.get(i2));
            i2++;
        }
    }

    @Override
    public final void zzf(int i, int i2) throws IOException {
        this.zza.zzd(i, i2);
    }

    @Override
    public final void zzm(int i, List<Integer> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZzj = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzj += zzig.zzj(list.get(i3).intValue());
            }
            this.zza.zzc(iZzj);
            while (i2 < list.size()) {
                this.zza.zzc(list.get(i2).intValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zzd(i, list.get(i2).intValue());
            i2++;
        }
    }

    @Override
    public final void zze(int i, long j) throws IOException {
        this.zza.zzb(i, j);
    }

    @Override
    public final void zzn(int i, List<Long> list, boolean z) throws IOException {
        int i2 = 0;
        if (z) {
            this.zza.zzc(i, 2);
            int iZzg = 0;
            for (int i3 = 0; i3 < list.size(); i3++) {
                iZzg += zzig.zzg(list.get(i3).longValue());
            }
            this.zza.zzc(iZzg);
            while (i2 < list.size()) {
                this.zza.zzb(list.get(i2).longValue());
                i2++;
            }
            return;
        }
        while (i2 < list.size()) {
            this.zza.zzb(i, list.get(i2).longValue());
            i2++;
        }
    }
}
