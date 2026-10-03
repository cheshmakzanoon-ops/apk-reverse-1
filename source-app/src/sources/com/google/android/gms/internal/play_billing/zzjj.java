package com.google.android.gms.internal.play_billing;

final class zzjj implements zzfx {
    static final zzfx zza = new zzjj();

    private zzjj() {
    }

    @Override
    public final boolean zza(int i) {
        zzjk zzjkVar;
        if (i == 0) {
            zzjkVar = zzjk.BROADCAST_ACTION_UNSPECIFIED;
        } else if (i == 1) {
            zzjkVar = zzjk.PURCHASES_UPDATED_ACTION;
        } else if (i != 2) {
            zzjkVar = i != 3 ? null : zzjk.ALTERNATIVE_BILLING_ACTION;
        } else {
            zzjkVar = zzjk.LOCAL_PURCHASES_UPDATED_ACTION;
        }
        return zzjkVar != null;
    }
}
