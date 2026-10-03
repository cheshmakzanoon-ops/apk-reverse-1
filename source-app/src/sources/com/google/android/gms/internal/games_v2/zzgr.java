package com.google.android.gms.internal.games_v2;

final class zzgr extends zzgu {
    private static final zzgr zzb = new zzgr();

    private zzgr() {
        super("");
    }

    @Override
    public final int compareTo(Object obj) {
        return zzc((zzgu) obj);
    }

    @Override
    public final int hashCode() {
        return System.identityHashCode(this);
    }

    public final String toString() {
        return "+∞";
    }

    @Override
    final void zza(StringBuilder sb) {
        throw new AssertionError();
    }

    @Override
    final void zzb(StringBuilder sb) {
        sb.append("+∞)");
    }

    @Override
    public final int zzc(zzgu zzguVar) {
        return zzguVar == this ? 0 : 1;
    }
}
