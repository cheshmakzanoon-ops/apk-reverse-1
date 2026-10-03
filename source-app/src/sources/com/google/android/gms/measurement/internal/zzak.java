package com.google.android.gms.measurement.internal;

import java.util.EnumMap;

final class zzak {
    private final EnumMap<zzih.zza, zzaj> zza;

    public final zzaj zza(zzih.zza zzaVar) {
        zzaj zzajVar = this.zza.get(zzaVar);
        return zzajVar == null ? zzaj.UNSET : zzajVar;
    }

    public static zzak zza(String str) {
        EnumMap enumMap = new EnumMap(zzih.zza.class);
        if (str.length() >= zzih.zza.values().length) {
            int i = 0;
            if (str.charAt(0) == '1') {
                zzih.zza[] zzaVarArrValues = zzih.zza.values();
                int length = zzaVarArrValues.length;
                int i2 = 1;
                while (i < length) {
                    enumMap.put(zzaVarArrValues[i], zzaj.zza(str.charAt(i2)));
                    i++;
                    i2++;
                }
                return new zzak(enumMap);
            }
        }
        return new zzak();
    }

    public final String toString() {
        StringBuilder sb = new StringBuilder("1");
        for (zzih.zza zzaVar : zzih.zza.values()) {
            zzaj zzajVar = this.zza.get(zzaVar);
            if (zzajVar == null) {
                zzajVar = zzaj.UNSET;
            }
            sb.append(zzajVar.zzj);
        }
        return sb.toString();
    }

    zzak() {
        this.zza = new EnumMap<>(zzih.zza.class);
    }

    private zzak(EnumMap<zzih.zza, zzaj> enumMap) {
        EnumMap<zzih.zza, zzaj> enumMap2 = new EnumMap<>(zzih.zza.class);
        this.zza = enumMap2;
        enumMap2.putAll(enumMap);
    }

    public final void zza(zzih.zza zzaVar, int i) {
        zzaj zzajVar = zzaj.UNSET;
        if (i == -20) {
            zzajVar = zzaj.API;
        } else if (i == -10) {
            zzajVar = zzaj.MANIFEST;
        } else if (i == 0) {
            zzajVar = zzaj.API;
        } else if (i == 30) {
            zzajVar = zzaj.INITIALIZATION;
        }
        this.zza.put(zzaVar, zzajVar);
    }

    public final void zza(zzih.zza zzaVar, zzaj zzajVar) {
        this.zza.put(zzaVar, zzajVar);
    }
}
