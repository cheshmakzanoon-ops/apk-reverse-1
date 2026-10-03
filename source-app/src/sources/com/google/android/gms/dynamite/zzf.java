package com.google.android.gms.dynamite;

import android.content.Context;

final class zzf implements DynamiteModule.VersionPolicy.IVersions {
    zzf() {
    }

    @Override
    public final int zza(Context context, String str, boolean z) throws DynamiteModule.LoadingException {
        return DynamiteModule.zza(context, str, z);
    }

    @Override
    public final int zzb(Context context, String str) {
        return DynamiteModule.getLocalVersion(context, str);
    }
}
