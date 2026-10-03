package com.google.android.gms.internal.games_v2;

import android.app.Activity;
import android.content.ComponentName;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import com.google.android.gms.common.wrappers.Wrappers;
import j$.util.Objects;

final class zzat {
    static final zzat zza = new zzat();
    private boolean zzb;
    private boolean zzc;

    zzat() {
    }

    final boolean zza(Activity activity) {
        Bundle bundle;
        Bundle bundle2;
        if (this.zzc) {
            return this.zzb;
        }
        ActivityInfo activityInfo = null;
        try {
            ApplicationInfo applicationInfo = Wrappers.packageManager(activity).getApplicationInfo(activity.getPackageName(), 128);
            bundle = applicationInfo == null ? null : applicationInfo.metaData;
        } catch (PackageManager.NameNotFoundException unused) {
        }
        boolean zEquals = false;
        if (bundle != null && bundle.getString("com.epicgames.unreal.GameActivity.EngineVersion", "").startsWith("5.")) {
            try {
                activityInfo = activity.getPackageManager().getActivityInfo(new ComponentName(activity, "com.epicgames.unreal.GameActivity"), 128);
            } catch (PackageManager.NameNotFoundException unused2) {
            }
            if (activityInfo != null && (bundle2 = activityInfo.metaData) != null) {
                zEquals = Objects.equals(bundle2.getString("android.app.lib_name", ""), "Unreal");
            }
        }
        this.zzb = zEquals;
        this.zzc = true;
        return zEquals;
    }
}
