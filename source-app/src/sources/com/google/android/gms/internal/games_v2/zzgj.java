package com.google.android.gms.internal.games_v2;

import j$.util.Objects;
import java.util.function.Function;

final class zzgj implements Function {
    static final zzgj zza = new zzgj();

    private zzgj() {
    }

    @Override
    public Function andThen(Function function) {
        return j$.util.function.Function.-CC.$default$andThen(this, function);
    }

    @Override
    public Function compose(Function function) {
        return j$.util.function.Function.-CC.$default$compose(this, function);
    }

    @Override
    public final Object apply(Object obj) {
        zzhj zzhjVar = (zzhj) obj;
        int i = zzhjVar.zzb;
        if (i == 0) {
            return zzif.zza;
        }
        if (i == 1) {
            return new zzii(Objects.requireNonNull(zzhjVar.zza[0]));
        }
        zzhk zzhkVarZzk = zzhk.zzk(i, zzhjVar.zza);
        zzhjVar.zzb = zzhkVarZzk.size();
        zzhjVar.zzc = true;
        return zzhkVarZzk;
    }
}
