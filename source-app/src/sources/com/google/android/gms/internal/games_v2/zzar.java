package com.google.android.gms.internal.games_v2;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import j$.util.Objects;

final class zzar implements Application.ActivityLifecycleCallbacks {
    final zzas zza;
    private final Application zzb;
    private boolean zzc;
    private boolean zzd;

    zzar(zzas zzasVar, Application application, byte[] bArr) {
        Objects.requireNonNull(zzasVar);
        this.zza = zzasVar;
        this.zzc = false;
        this.zzb = application;
    }

    @Override
    public final void onActivityCreated(Activity activity, Bundle bundle) {
        String className = activity.getComponentName().getClassName();
        if (this.zzd) {
            if (!Objects.equals(className, "com.epicgames.unreal.GameActivity")) {
                return;
            }
        } else if (Objects.equals(className, "com.epicgames.unreal.SplashActivity") && zzat.zza.zza(activity)) {
            this.zzd = true;
            return;
        }
        this.zzb.unregisterActivityLifecycleCallbacks(this);
        if (this.zzc) {
            this.zzc = false;
            zzfn.zza("AutomaticGamesAuthenticator", "Automatic connection attempt triggered");
            this.zza.zzc().zzd();
        }
    }

    @Override
    public final void onActivityDestroyed(Activity activity) {
    }

    @Override
    public final void onActivityPaused(Activity activity) {
    }

    @Override
    public final void onActivityResumed(Activity activity) {
    }

    @Override
    public final void onActivitySaveInstanceState(Activity activity, Bundle bundle) {
    }

    @Override
    public final void onActivityStarted(Activity activity) {
    }

    @Override
    public final void onActivityStopped(Activity activity) {
    }

    final void zza() {
        if (this.zzc) {
            return;
        }
        this.zzb.registerActivityLifecycleCallbacks(this);
        this.zzc = true;
    }
}
