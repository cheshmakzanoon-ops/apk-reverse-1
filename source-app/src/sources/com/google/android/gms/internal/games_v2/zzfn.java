package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.internal.GmsLogger;

public final class zzfn {
    private static final GmsLogger zza = new GmsLogger("Games");

    public static void zza(String str, String str2) {
        zza.m1d(zzi(str), str2);
    }

    public static void zzb(String str, String str2, Throwable th) {
        zza.m2d(zzi("GamesApiManager"), "Authentication task failed", th);
    }

    public static void zzc(String str, String str2) {
        zza.m7v(zzi(str), str2);
    }

    public static void zzd(String str, String str2, Throwable th) {
        zza.m6i(zzi("SnapshotContentsEntity"), "Failed to write snapshot data", th);
    }

    public static void zze(String str, String str2) {
        zza.m9w(zzi(str), str2);
    }

    public static void zzf(String str, String str2, Throwable th) {
        zza.m10w(zzi(str), str2, th);
    }

    public static void zzg(String str, String str2) {
        zza.m3e(zzi(str), str2);
    }

    public static void zzh(String str, String str2, Throwable th) {
        zza.m4e(zzi(str), str2, th);
    }

    private static String zzi(String str) {
        return String.format("%s[%s]", "PlayGamesServices", str);
    }
}
