package com.google.android.gms.internal.games_v2;

abstract class zzfz implements zzhy {
    zzfz() {
    }

    public final boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (obj instanceof zzhy) {
            return zzc().equals(((zzhy) obj).zzc());
        }
        return false;
    }

    public final int hashCode() {
        return zzc().hashCode();
    }

    public final String toString() {
        return zzc().toString();
    }
}
