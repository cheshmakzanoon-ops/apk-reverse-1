package com.google.android.gms.measurement.internal;

abstract class zzic extends zzid {
    private boolean zza;

    zzic(zzhf zzhfVar) {
        super(zzhfVar);
        this.zzu.zzaa();
    }

    protected abstract boolean zzo();

    protected void zzz() {
    }

    protected final void zzab() {
        if (!zzae()) {
            throw new IllegalStateException("Not initialized");
        }
    }

    public final void zzac() {
        if (this.zza) {
            throw new IllegalStateException("Can't initialize twice");
        }
        if (zzo()) {
            return;
        }
        this.zzu.zzz();
        this.zza = true;
    }

    public final void zzad() {
        if (this.zza) {
            throw new IllegalStateException("Can't initialize twice");
        }
        zzz();
        this.zzu.zzz();
        this.zza = true;
    }

    final boolean zzae() {
        return this.zza;
    }
}
