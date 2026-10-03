package com.google.android.gms.common.internal;

import android.content.ComponentName;

public final class zzn {
    private final String zza;
    private final String zzb;
    private final ComponentName zzc;
    private final int zzd;
    private final boolean zze;

    public zzn(ComponentName componentName, int i) {
        this.zza = null;
        this.zzb = null;
        Preconditions.checkNotNull(componentName);
        this.zzc = componentName;
        this.zzd = 4225;
        this.zze = false;
    }

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof zzn)) {
            return false;
        }
        zzn zznVar = (zzn) obj;
        if (Objects.equal(this.zza, zznVar.zza) && Objects.equal(this.zzb, zznVar.zzb) && Objects.equal(this.zzc, zznVar.zzc)) {
            int i = zznVar.zzd;
            if (this.zze == zznVar.zze) {
                return true;
            }
        }
        return false;
    }

    public final int hashCode() {
        return Objects.hashCode(this.zza, this.zzb, this.zzc, 4225, Boolean.valueOf(this.zze));
    }

    public final String toString() {
        String str = this.zza;
        if (str != null) {
            return str;
        }
        ComponentName componentName = this.zzc;
        Preconditions.checkNotNull(componentName);
        return componentName.flattenToString();
    }

    public final String zza() {
        return this.zza;
    }

    public final String zzb() {
        return this.zzb;
    }

    public final ComponentName zzc() {
        return this.zzc;
    }

    public final boolean zzd() {
        return this.zze;
    }

    public zzn(String str, int i, boolean z) {
        this(str, "com.google.android.gms", 4225, false);
    }

    public zzn(String str, String str2, int i, boolean z) {
        Preconditions.checkNotEmpty(str);
        this.zza = str;
        Preconditions.checkNotEmpty(str2);
        this.zzb = str2;
        this.zzc = null;
        this.zzd = 4225;
        this.zze = z;
    }
}
