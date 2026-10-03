package com.google.android.gms.internal.games_v2;

import java.io.Serializable;

public final class zzhw extends zzhx implements Serializable {
    public static final int zzc = 0;
    private static final zzhw zzd = new zzhw(zzgt.zzb, zzgr.zzb);
    final zzgu zza;
    final zzgu zzb;

    private zzhw(zzgu zzguVar, zzgu zzguVar2) {
        this.zza = zzguVar;
        this.zzb = zzguVar2;
        if (zzguVar.compareTo(zzguVar2) > 0 || zzguVar == zzgr.zzb || zzguVar2 == zzgt.zzb) {
            throw new IllegalArgumentException("Invalid range: ".concat(zze(zzguVar, zzguVar2)));
        }
    }

    public static zzhw zza() {
        return zzd;
    }

    private static String zze(zzgu zzguVar, zzgu zzguVar2) {
        StringBuilder sb = new StringBuilder(16);
        zzguVar.zza(sb);
        sb.append("..");
        zzguVar2.zzb(sb);
        return sb.toString();
    }

    public final boolean equals(Object obj) {
        if (obj instanceof zzhw) {
            zzhw zzhwVar = (zzhw) obj;
            if (this.zza.equals(zzhwVar.zza) && this.zzb.equals(zzhwVar.zzb)) {
                return true;
            }
        }
        return false;
    }

    public final int hashCode() {
        return (this.zza.hashCode() * 31) + this.zzb.hashCode();
    }

    public final String toString() {
        return zze(this.zza, this.zzb);
    }

    public final boolean zzb() {
        return this.zza.equals(this.zzb);
    }

    public final zzhw zzc(zzhw zzhwVar) {
        zzgu zzguVar = this.zza;
        zzgu zzguVar2 = zzhwVar.zza;
        int iZzc = zzguVar.compareTo(zzguVar2);
        zzgu zzguVar3 = this.zzb;
        zzgu zzguVar4 = zzhwVar.zzb;
        int iZzc2 = zzguVar3.compareTo(zzguVar4);
        if (iZzc >= 0 && iZzc2 <= 0) {
            return this;
        }
        if (iZzc <= 0 && iZzc2 >= 0) {
            return zzhwVar;
        }
        if (iZzc < 0) {
            zzguVar = zzguVar2;
        }
        if (iZzc2 > 0) {
            zzguVar3 = zzguVar4;
        }
        zzfu.zza(zzguVar.compareTo(zzguVar3) <= 0, "intersection is undefined for disconnected ranges %s and %s", this, zzhwVar);
        return new zzhw(zzguVar, zzguVar3);
    }

    public final zzhw zzd(zzhw zzhwVar) {
        zzgu zzguVar = this.zza;
        zzgu zzguVar2 = zzhwVar.zza;
        int iZzc = zzguVar.compareTo(zzguVar2);
        zzgu zzguVar3 = this.zzb;
        zzgu zzguVar4 = zzhwVar.zzb;
        int iZzc2 = zzguVar3.compareTo(zzguVar4);
        if (iZzc <= 0 && iZzc2 >= 0) {
            return this;
        }
        if (iZzc >= 0 && iZzc2 <= 0) {
            return zzhwVar;
        }
        if (iZzc > 0) {
            zzguVar = zzguVar2;
        }
        if (iZzc2 < 0) {
            zzguVar3 = zzguVar4;
        }
        return new zzhw(zzguVar, zzguVar3);
    }
}
