package com.google.android.gms.games.internal.p000v2.appshortcuts;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.util.Pair;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.wrappers.Wrappers;
import com.google.android.gms.internal.games_v2.zzgz;
import com.google.android.gms.internal.games_v2.zzhd;
import java.util.List;

public final class zzt {
    public static zzr zza(Context context, Class cls) {
        Bundle bundle;
        Long lValueOf;
        ActivityInfo activityInfo;
        Bundle bundle2;
        try {
            ApplicationInfo applicationInfo = Wrappers.packageManager(context).getApplicationInfo(context.getPackageName(), 128);
            bundle = applicationInfo == null ? null : applicationInfo.metaData;
        } catch (PackageManager.NameNotFoundException unused) {
        }
        String string = "";
        if (bundle == null) {
            lValueOf = null;
        } else {
            try {
                lValueOf = Long.valueOf(Long.parseLong(bundle.getString("com.google.android.gms.games.APP_ID", "")));
            } catch (NumberFormatException unused2) {
                lValueOf = null;
            }
        }
        if (lValueOf == null) {
            return null;
        }
        List<ResolveInfo> listQueryIntentActivities = context.getPackageManager().queryIntentActivities(new Intent("android.intent.action.MAIN").addCategory("android.intent.category.LAUNCHER").setPackage(context.getPackageName()), 795136);
        int i = zzhd.zzd;
        zzgz zzgzVar = new zzgz();
        for (ResolveInfo resolveInfo : listQueryIntentActivities) {
            ActivityInfo activityInfo2 = resolveInfo.activityInfo;
            if (activityInfo2 != null) {
                int componentEnabledSetting = context.getPackageManager().getComponentEnabledSetting(new ComponentName(activityInfo2.packageName, activityInfo2.name));
                if (componentEnabledSetting == 0) {
                    if (activityInfo2.enabled) {
                        if (resolveInfo.activityInfo.exported) {
                            zzgzVar.zzd(resolveInfo);
                        }
                    }
                } else if (componentEnabledSetting == 1) {
                    if (resolveInfo.activityInfo.exported) {
                        zzgzVar.zzd(resolveInfo);
                    }
                }
            }
        }
        zzhd zzhdVarZze = zzgzVar.zze();
        int size = zzhdVarZze.size();
        int iMin = Integer.MAX_VALUE;
        for (int i2 = 0; i2 < size; i2++) {
            ActivityInfo activityInfo3 = ((ResolveInfo) zzhdVarZze.get(i2)).activityInfo;
            if (activityInfo3 != null) {
                try {
                    activityInfo = context.getPackageManager().getActivityInfo(new ComponentName(activityInfo3.packageName, activityInfo3.name), 795264);
                } catch (PackageManager.NameNotFoundException unused3) {
                    activityInfo = null;
                }
                if (activityInfo != null && (bundle2 = activityInfo.metaData) != null) {
                    iMin = Math.min(iMin, bundle2.getInt("com.google.android.gms.games.APP_SHORTCUTS_MAX_NUMBER", Api.BaseClientBuilder.API_PRIORITY_OTHER));
                    string = bundle2.getString("com.google.android.gms.games.APP_SHORTCUTS_TARGET_ACTIVITY", string);
                }
            }
        }
        Pair pair = new Pair(Integer.valueOf(iMin), string);
        return new zzr(lValueOf.longValue(), context.getPackageName(), ((Integer) pair.first).intValue(), new ComponentName(context, (Class<?>) cls), ((String) pair.second).trim());
    }
}
