package com.google.android.gms.internal.measurement;

public enum zzs {
    DEBUG(3),
    ERROR(6),
    INFO(4),
    VERBOSE(2),
    WARN(5);

    private final int zzg;

    public static zzs zza(int i) {
        if (i == 2) {
            return VERBOSE;
        }
        if (i == 3) {
            return DEBUG;
        }
        if (i != 5) {
            return i != 6 ? INFO : ERROR;
        }
        return WARN;
    }

    zzs(int i) {
        this.zzg = i;
    }
}
