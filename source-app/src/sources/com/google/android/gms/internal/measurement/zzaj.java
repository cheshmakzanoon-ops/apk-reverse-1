package com.google.android.gms.internal.measurement;

import java.util.Iterator;
import java.util.List;

public final class zzaj implements zzaq {
    private final zzaq zza;
    private final String zzb;

    public final int hashCode() {
        return (this.zzb.hashCode() * 31) + this.zza.hashCode();
    }

    @Override
    public final Iterator<zzaq> zzh() {
        return null;
    }

    @Override
    public final zzaq zza(String str, zzh zzhVar, List<zzaq> list) {
        throw new IllegalStateException("Control does not have functions");
    }

    @Override
    public final zzaq zzc() {
        return new zzaj(this.zzb, this.zza.zzc());
    }

    public final zzaq zza() {
        return this.zza;
    }

    @Override
    public final Boolean zzd() {
        throw new IllegalStateException("Control is not a boolean");
    }

    @Override
    public final Double zze() {
        throw new IllegalStateException("Control is not a double");
    }

    @Override
    public final String zzf() {
        throw new IllegalStateException("Control is not a String");
    }

    public final String zzb() {
        return this.zzb;
    }

    public zzaj() {
        this.zza = zzc;
        this.zzb = "return";
    }

    public zzaj(String str) {
        this.zza = zzc;
        this.zzb = str;
    }

    public zzaj(String str, zzaq zzaqVar) {
        this.zza = zzaqVar;
        this.zzb = str;
    }

    public final boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (!(obj instanceof zzaj)) {
            return false;
        }
        zzaj zzajVar = (zzaj) obj;
        return this.zzb.equals(zzajVar.zzb) && this.zza.equals(zzajVar.zza);
    }
}
