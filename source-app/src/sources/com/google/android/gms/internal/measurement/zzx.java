package com.google.android.gms.internal.measurement;

import java.util.List;
import java.util.concurrent.Callable;

public final class zzx extends zzal {
    private final Callable<Object> zzk;

    @Override
    public final zzaq zza(zzh zzhVar, List<zzaq> list) {
        try {
            return zzj.zza(this.zzk.call());
        } catch (Exception unused) {
            return zzaq.zzc;
        }
    }

    public zzx(String str, Callable<Object> callable) {
        super(str);
        this.zzk = callable;
    }
}
