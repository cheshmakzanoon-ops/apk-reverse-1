package com.google.android.gms.dynamite;

import android.content.Context;

final class zzl implements DynamiteModule.VersionPolicy {
    zzl() {
    }

    @Override
    public final DynamiteModule.VersionPolicy.SelectionResult selectModule(Context context, String str, DynamiteModule.VersionPolicy.IVersions iVersions) throws DynamiteModule.LoadingException {
        DynamiteModule.VersionPolicy.SelectionResult selectionResult = new DynamiteModule.VersionPolicy.SelectionResult();
        selectionResult.localVersion = iVersions.zzb(context, str);
        int i = 1;
        int iZza = iVersions.zza(context, str, true);
        selectionResult.remoteVersion = iZza;
        int i2 = selectionResult.localVersion;
        if (i2 == 0) {
            i2 = 0;
            if (iZza == 0) {
                i = 0;
            } else if (iZza < i2) {
                i = -1;
            }
        } else if (iZza < i2) {
            i = -1;
        }
        selectionResult.selection = i;
        return selectionResult;
    }
}
