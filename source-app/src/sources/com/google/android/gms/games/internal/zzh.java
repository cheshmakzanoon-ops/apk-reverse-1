package com.google.android.gms.games.internal;

public final class zzh {
    private boolean zza = false;
    private boolean zzb = false;
    private boolean zzc = false;

    private zzh() {
    }

    zzh(byte[] bArr) {
    }

    public final zzh zza(boolean z) {
        this.zza = true;
        return this;
    }

    public final zzh zzb(boolean z) {
        this.zzb = true;
        return this;
    }

    public final zzh zzc(boolean z) {
        this.zzc = true;
        return this;
    }

    public final zzi zzd() {
        return new zzi(this, null);
    }

    final boolean zze() {
        return this.zza;
    }

    final boolean zzf() {
        return this.zzb;
    }

    final boolean zzg() {
        return this.zzc;
    }
}
