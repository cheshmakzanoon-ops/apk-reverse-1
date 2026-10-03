package com.google.android.gms.games.internal.p000v2.appshortcuts;

import android.content.Context;
import android.os.Build;

public class zzf {
    zzf(byte[] bArr) {
    }

    public static zzf zzd(Context context) {
        return Build.VERSION.SDK_INT < 25 ? new zza() : new zze(context);
    }

    public void zza() {
    }
}
