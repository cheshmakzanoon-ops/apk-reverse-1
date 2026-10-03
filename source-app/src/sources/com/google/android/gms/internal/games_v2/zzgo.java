package com.google.android.gms.internal.games_v2;

final class zzgo extends zzgq {
    zzgo() {
        super(null);
    }

    @Override
    public final zzgq zza(Comparable comparable, Comparable comparable2) {
        int iCompareTo = comparable.compareTo(comparable2);
        if (iCompareTo < 0) {
            return zzgq.zzb;
        }
        return iCompareTo > 0 ? zzgq.zzc : zzgq.zza;
    }

    @Override
    public final int zzb() {
        return 0;
    }
}
