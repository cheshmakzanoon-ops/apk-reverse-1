package com.google.android.gms.measurement;

import android.os.Bundle;
import androidx.collection.ArrayMap;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.measurement.internal.zzhf;
import com.google.android.gms.measurement.internal.zzil;
import com.google.android.gms.measurement.internal.zzim;
import com.google.android.gms.measurement.internal.zziq;
import com.google.android.gms.measurement.internal.zznc;
import java.util.List;
import java.util.Map;

final class zza extends AppMeasurement.zza {
    private final zzhf zza;
    private final zziq zzb;

    @Override
    public final int zza(String str) {
        Preconditions.checkNotEmpty(str);
        return 25;
    }

    @Override
    public final long zza() {
        return this.zza.zzt().zzm();
    }

    @Override
    public final Boolean zzb() {
        return this.zzb.zzaa();
    }

    @Override
    public final Double zzc() {
        return this.zzb.zzab();
    }

    @Override
    public final Integer zzd() {
        return this.zzb.zzac();
    }

    @Override
    public final Long zze() {
        return this.zzb.zzad();
    }

    @Override
    public final Object zza(int i) {
        if (i == 0) {
            return zzj();
        }
        if (i == 1) {
            return zze();
        }
        if (i == 2) {
            return zzc();
        }
        if (i == 3) {
            return zzd();
        }
        if (i != 4) {
            return null;
        }
        return zzb();
    }

    @Override
    public final String zzf() {
        return this.zzb.zzae();
    }

    @Override
    public final String zzg() {
        return this.zzb.zzaf();
    }

    @Override
    public final String zzh() {
        return this.zzb.zzag();
    }

    @Override
    public final String zzi() {
        return this.zzb.zzae();
    }

    @Override
    public final String zzj() {
        return this.zzb.zzai();
    }

    @Override
    public final List<Bundle> zza(String str, String str2) {
        return this.zzb.zza(str, str2);
    }

    @Override
    public final Map<String, Object> zza(boolean z) {
        List<zznc> listZza = this.zzb.zza(z);
        ArrayMap arrayMap = new ArrayMap(listZza.size());
        for (zznc zzncVar : listZza) {
            Object objZza = zzncVar.zza();
            if (objZza != null) {
                arrayMap.put(zzncVar.zza, objZza);
            }
        }
        return arrayMap;
    }

    @Override
    public final Map<String, Object> zza(String str, String str2, boolean z) {
        return this.zzb.zza(str, str2, z);
    }

    public zza(zzhf zzhfVar) {
        super();
        Preconditions.checkNotNull(zzhfVar);
        this.zza = zzhfVar;
        this.zzb = zzhfVar.zzp();
    }

    @Override
    public final void zzb(String str) {
        this.zza.zze().zza(str, this.zza.zzb().elapsedRealtime());
    }

    @Override
    public final void zza(String str, String str2, Bundle bundle) {
        this.zza.zzp().zza(str, str2, bundle);
    }

    @Override
    public final void zzc(String str) {
        this.zza.zze().zzb(str, this.zza.zzb().elapsedRealtime());
    }

    @Override
    public final void zzb(String str, String str2, Bundle bundle) {
        this.zzb.zzb(str, str2, bundle);
    }

    @Override
    public final void zza(String str, String str2, Bundle bundle, long j) {
        this.zzb.zza(str, str2, bundle, true, false, j);
    }

    @Override
    public final void zza(zzil zzilVar) {
        this.zzb.zza(zzilVar);
    }

    @Override
    public final void zza(Bundle bundle) {
        this.zzb.zzb(bundle);
    }

    @Override
    public final void zza(zzim zzimVar) {
        this.zzb.zza(zzimVar);
    }

    @Override
    public final void zzb(zzil zzilVar) {
        this.zzb.zzb(zzilVar);
    }
}
