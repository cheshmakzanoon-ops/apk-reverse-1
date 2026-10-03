package com.google.android.gms.internal.measurement;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public abstract class zzal implements zzak, zzaq {
    protected final String zza;
    protected final Map<String, zzaq> zzb = new HashMap();

    public int hashCode() {
        String str = this.zza;
        if (str != null) {
            return str.hashCode();
        }
        return 0;
    }

    public abstract zzaq zza(zzh zzhVar, List<zzaq> list);

    @Override
    public zzaq zzc() {
        return this;
    }

    @Override
    public final zzaq zza(String str, zzh zzhVar, List<zzaq> list) {
        return "toString".equals(str) ? new zzas(this.zza) : zzan.zza(this, new zzas(str), zzhVar, list);
    }

    @Override
    public final zzaq zza(String str) {
        if (this.zzb.containsKey(str)) {
            return this.zzb.get(str);
        }
        return zzc;
    }

    @Override
    public final Boolean zzd() {
        return true;
    }

    @Override
    public final Double zze() {
        return Double.valueOf(Double.NaN);
    }

    public final String zza() {
        return this.zza;
    }

    @Override
    public final String zzf() {
        return this.zza;
    }

    @Override
    public final Iterator<zzaq> zzh() {
        return zzan.zza(this.zzb);
    }

    public zzal(String str) {
        this.zza = str;
    }

    @Override
    public final void zza(String str, zzaq zzaqVar) {
        if (zzaqVar == null) {
            this.zzb.remove(str);
        } else {
            this.zzb.put(str, zzaqVar);
        }
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof zzal)) {
            return false;
        }
        zzal zzalVar = (zzal) obj;
        String str = this.zza;
        if (str != null) {
            return str.equals(zzalVar.zza);
        }
        return false;
    }

    @Override
    public final boolean zzc(String str) {
        return this.zzb.containsKey(str);
    }
}
