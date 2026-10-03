package com.google.android.gms.internal.play_billing;

public enum zzjk implements zzfw {
    BROADCAST_ACTION_UNSPECIFIED(0),
    PURCHASES_UPDATED_ACTION(1),
    LOCAL_PURCHASES_UPDATED_ACTION(2),
    ALTERNATIVE_BILLING_ACTION(3);

    private final int zzf;

    zzjk(int i) {
        this.zzf = i;
    }

    @Override
    public final String toString() {
        return Integer.toString(this.zzf);
    }

    @Override
    public final int zza() {
        return this.zzf;
    }
}
