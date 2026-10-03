package com.google.android.gms.internal.games_v2;

public final class zzz {
    public static String zza(int i) {
        if (i == 0) {
            return "DAILY";
        }
        if (i == 1) {
            return "WEEKLY";
        }
        if (i == 2) {
            return "ALL_TIME";
        }
        StringBuilder sb = new StringBuilder(String.valueOf(i).length() + 18);
        sb.append("Unknown time span ");
        sb.append(i);
        throw new IllegalArgumentException(sb.toString());
    }
}
