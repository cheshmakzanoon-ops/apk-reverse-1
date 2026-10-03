package com.google.android.gms.measurement.internal;

final class zzgw {
    static final int[] zza;
    static final int[] zzb;

    static {
        int[] iArr = new int[com.google.android.gms.internal.measurement.zzfc.zza.zze.values().length];
        zzb = iArr;
        try {
            iArr[com.google.android.gms.internal.measurement.zzfc.zza.zze.AD_STORAGE.ordinal()] = 1;
        } catch (NoSuchFieldError unused) {
        }
        try {
            zzb[com.google.android.gms.internal.measurement.zzfc.zza.zze.ANALYTICS_STORAGE.ordinal()] = 2;
        } catch (NoSuchFieldError unused2) {
        }
        try {
            zzb[com.google.android.gms.internal.measurement.zzfc.zza.zze.AD_USER_DATA.ordinal()] = 3;
        } catch (NoSuchFieldError unused3) {
        }
        try {
            zzb[com.google.android.gms.internal.measurement.zzfc.zza.zze.AD_PERSONALIZATION.ordinal()] = 4;
        } catch (NoSuchFieldError unused4) {
        }
        int[] iArr2 = new int[com.google.android.gms.internal.measurement.zzs.values().length];
        zza = iArr2;
        try {
            iArr2[com.google.android.gms.internal.measurement.zzs.DEBUG.ordinal()] = 1;
        } catch (NoSuchFieldError unused5) {
        }
        try {
            zza[com.google.android.gms.internal.measurement.zzs.ERROR.ordinal()] = 2;
        } catch (NoSuchFieldError unused6) {
        }
        try {
            zza[com.google.android.gms.internal.measurement.zzs.WARN.ordinal()] = 3;
        } catch (NoSuchFieldError unused7) {
        }
        try {
            zza[com.google.android.gms.internal.measurement.zzs.VERBOSE.ordinal()] = 4;
        } catch (NoSuchFieldError unused8) {
        }
    }
}
