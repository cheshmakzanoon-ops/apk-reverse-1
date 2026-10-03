package com.google.android.gms.internal.measurement;

import java.util.Iterator;
import java.util.List;

public final class zzag implements zzaq {
    private final boolean zza;

    public final int hashCode() {
        return Boolean.valueOf(this.zza).hashCode();
    }

    @Override
    public final Iterator<zzaq> zzh() {
        return null;
    }

    @Override
    public final zzaq zza(String str, zzh zzhVar, List<zzaq> list) {
        if ("toString".equals(str)) {
            return new zzas(Boolean.toString(this.zza));
        }
        throw new IllegalArgumentException(String.format("%s.%s is not a function.", Boolean.toString(this.zza), str));
    }

    @Override
    public final zzaq zzc() {
        return new zzag(Boolean.valueOf(this.zza));
    }

    @Override
    public final Boolean zzd() {
        return Boolean.valueOf(this.zza);
    }

    @Override
    public final Double zze() {
        return Double.valueOf(this.zza ? 1.0d : 0.0d);
    }

    @Override
    public final String zzf() {
        return Boolean.toString(this.zza);
    }

    public final String toString() {
        return String.valueOf(this.zza);
    }

    public zzag(Boolean bool) {
        if (bool == null) {
            this.zza = false;
        } else {
            this.zza = bool.booleanValue();
        }
    }

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        return (obj instanceof zzag) && this.zza == ((zzag) obj).zza;
    }
}
