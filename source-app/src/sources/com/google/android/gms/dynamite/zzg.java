package com.google.android.gms.dynamite;

import android.content.Context;

final class zzg implements DynamiteModule.VersionPolicy {
    zzg() {
    }

    @Override
    public final DynamiteModule.VersionPolicy.SelectionResult selectModule(Context context, String str, DynamiteModule.VersionPolicy.IVersions iVersions) throws DynamiteModule.LoadingException {
        DynamiteModule.VersionPolicy.SelectionResult selectionResult = new DynamiteModule.VersionPolicy.SelectionResult();
        int iZza = iVersions.zza(context, str, true);
        selectionResult.remoteVersion = iZza;
        if (iZza != 0) {
            selectionResult.selection = 1;
        } else {
            int iZzb = iVersions.zzb(context, str);
            selectionResult.localVersion = iZzb;
            if (iZzb != 0) {
                selectionResult.selection = -1;
            }
        }
        return selectionResult;
    }
}
