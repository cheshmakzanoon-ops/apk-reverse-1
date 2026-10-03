package com.google.android.gms.dynamite;

import android.content.Context;

final class zzc implements DynamiteModule.VersionPolicy {
    zzc() {
    }

    @Override
    public final DynamiteModule.VersionPolicy.SelectionResult selectModule(Context context, String str, DynamiteModule.VersionPolicy.IVersions iVersions) {
        DynamiteModule.VersionPolicy.SelectionResult selectionResult = new DynamiteModule.VersionPolicy.SelectionResult();
        int iZzb = iVersions.zzb(context, str);
        selectionResult.localVersion = iZzb;
        selectionResult.selection = iZzb != 0 ? -1 : 0;
        return selectionResult;
    }
}
