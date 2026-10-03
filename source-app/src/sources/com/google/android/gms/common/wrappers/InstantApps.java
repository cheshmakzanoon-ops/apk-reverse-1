package com.google.android.gms.common.wrappers;

import android.content.Context;
import cn.thinkingdata.android.j$;
import com.google.android.gms.common.util.PlatformVersion;

public class InstantApps {
    private static Context zza;
    private static Boolean zzb;

    public static synchronized boolean isInstantApp(Context context) {
        Boolean bool;
        Context applicationContext = context.getApplicationContext();
        Context context2 = zza;
        if (context2 != null && (bool = zzb) != null && context2 == applicationContext) {
            return bool.booleanValue();
        }
        zzb = null;
        if (PlatformVersion.isAtLeastO()) {
            zzb = Boolean.valueOf(j$.ExternalSyntheticApiModelOutline0.m(applicationContext.getPackageManager()));
        } else {
            try {
                context.getClassLoader().loadClass("com.google.android.instantapps.supervisor.InstantAppsRuntime");
                zzb = true;
            } catch (ClassNotFoundException unused) {
                zzb = false;
            }
        }
        zza = applicationContext;
        return zzb.booleanValue();
    }
}
