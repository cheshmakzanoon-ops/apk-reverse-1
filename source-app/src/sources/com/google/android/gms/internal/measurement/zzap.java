package com.google.android.gms.internal.measurement;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class zzap implements zzak, zzaq {
    private final Map<String, zzaq> zza = new HashMap();

    public int hashCode() {
        return this.zza.hashCode();
    }

    @Override
    public zzaq zza(String str, zzh zzhVar, List<zzaq> list) {
        return "toString".equals(str) ? new zzas(toString()) : zzan.zza(this, new zzas(str), zzhVar, list);
    }

    @Override
    public final zzaq zzc() {
        zzap zzapVar = new zzap();
        for (Map.Entry<String, zzaq> entry : this.zza.entrySet()) {
            if (entry.getValue() instanceof zzak) {
                zzapVar.zza.put(entry.getKey(), entry.getValue());
            } else {
                zzapVar.zza.put(entry.getKey(), entry.getValue().zzc());
            }
        }
        return zzapVar;
    }

    @Override
    public final zzaq zza(String str) {
        if (this.zza.containsKey(str)) {
            return this.zza.get(str);
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

    @Override
    public final String zzf() {
        return "[object Object]";
    }

    public String toString() {
        StringBuilder sb = new StringBuilder("{");
        if (!this.zza.isEmpty()) {
            for (String str : this.zza.keySet()) {
                sb.append(String.format("%s: %s,", str, this.zza.get(str)));
            }
            sb.deleteCharAt(sb.lastIndexOf(","));
        }
        sb.append("}");
        return sb.toString();
    }

    @Override
    public final Iterator<zzaq> zzh() {
        return zzan.zza(this.zza);
    }

    public final List<String> zza() {
        return new ArrayList(this.zza.keySet());
    }

    @Override
    public final void zza(String str, zzaq zzaqVar) {
        if (zzaqVar == null) {
            this.zza.remove(str);
        } else {
            this.zza.put(str, zzaqVar);
        }
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj instanceof zzap) {
            return this.zza.equals(((zzap) obj).zza);
        }
        return false;
    }

    @Override
    public final boolean zzc(String str) {
        return this.zza.containsKey(str);
    }
}
