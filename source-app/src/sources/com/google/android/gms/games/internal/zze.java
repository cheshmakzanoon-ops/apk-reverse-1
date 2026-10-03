package com.google.android.gms.games.internal;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import j$.util.Objects;

final class zze implements Application.ActivityLifecycleCallbacks {
    final zzf zza;

    zze(zzf zzfVar, byte[] bArr) {
        Objects.requireNonNull(zzfVar);
        this.zza = zzfVar;
    }

    @Override
    public final void onActivityCreated(Activity activity, Bundle bundle) {
    }

    @Override
    public final void onActivityDestroyed(Activity activity) {
        this.zza.zzg(activity);
    }

    @Override
    public final void onActivityPaused(Activity activity) {
    }

    @Override
    public final void onActivityResumed(Activity activity) {
        this.zza.zzf(activity);
    }

    @Override
    public final void onActivitySaveInstanceState(Activity activity, Bundle bundle) {
    }

    @Override
    public final void onActivityStarted(Activity activity) {
        this.zza.zzf(activity);
    }

    @Override
    public final void onActivityStopped(Activity activity) {
    }
}
