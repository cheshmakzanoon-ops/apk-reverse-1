package com.google.android.gms.dynamite;

import android.content.Context;

final class zzo implements DynamiteModule.VersionPolicy.IVersions {
    private final int zza;

    public zzo(int i, int i2) {
        this.zza = i;
    }

    @Override
    public final int zza(Context context, String str, boolean z) {
        return 0;
    }

    @Override
    public final int zzb(Context context, String str) {
        return this.zza;
    }
}
