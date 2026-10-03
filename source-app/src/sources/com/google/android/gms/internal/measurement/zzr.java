package com.google.android.gms.internal.measurement;

import java.util.List;

public final class zzr extends zzal {
    private final zzv zzk;

    @Override
    public final zzaq zza(zzh zzhVar, List<zzaq> list) {
        return zzaq.zzc;
    }

    public zzr(zzv zzvVar) {
        super("internal.logger");
        this.zzk = zzvVar;
        this.zzb.put("log", new zzu(this, false, true));
        this.zzb.put("silent", new zzq(this, "silent"));
        ((zzal) this.zzb.get("silent")).zza("log", new zzu(this, true, true));
        this.zzb.put("unmonitored", new zzt(this, "unmonitored"));
        ((zzal) this.zzb.get("unmonitored")).zza("log", new zzu(this, false, false));
    }
}
