package com.android.billingclient.api;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Bundle;
import com.google.android.gms.internal.play_billing.zzhx;

final class zzdg {
    static Bundle zza(com.google.android.gms.internal.play_billing.zzdy zzdyVar, zzhx zzhxVar) {
        Bundle bundle = new Bundle();
        bundle.putByteArray("REQUEST_METADATA", zzdyVar.zzQ());
        bundle.putByteArray("REQUEST_PARAMS", zzhxVar.zzQ());
        return bundle;
    }

    static com.google.android.gms.internal.play_billing.zzdy zzb(String str, int i, Context context, String str2) {
        String strValueOf;
        com.google.android.gms.internal.play_billing.zzdx zzdxVarZza = com.google.android.gms.internal.play_billing.zzdy.zza();
        zzdxVarZza.zzd(str);
        zzdxVarZza.zze(24);
        zzdxVarZza.zzb(context.getPackageName());
        zzdxVarZza.zzc(str2);
        try {
            strValueOf = String.valueOf(context.getPackageManager().getPackageInfo(context.getPackageName(), 0).versionCode);
        } catch (PackageManager.NameNotFoundException unused) {
            com.google.android.gms.internal.play_billing.zzc.zzo("DelegationApiParamsBuilder", "No version code is found!");
            strValueOf = null;
        }
        if (strValueOf != null) {
            zzdxVarZza.zza(strValueOf);
        }
        return zzdxVarZza.zzi();
    }
}
