package com.google.android.gms.internal.games_v2;

final class zzgt extends zzgu {
    private static final zzgt zzb = new zzgt();

    private zzgt() {
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
        return "-∞";
    }

    @Override
    final void zza(StringBuilder sb) {
        sb.append("(-∞");
    }

    @Override
    final void zzb(StringBuilder sb) {
        throw new AssertionError();
    }

    @Override
    public final int zzc(zzgu zzguVar) {
        return zzguVar == this ? 0 : -1;
    }
}
