package com.google.android.gms.games.internal;

import android.app.Activity;
import android.app.Application;
import android.os.Looper;
import androidx.compose.animation.core.ComplexDouble$;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.tasks.TaskExecutors;
import java.lang.ref.WeakReference;
import java.util.Collections;
import java.util.Iterator;
import java.util.Set;
import java.util.WeakHashMap;
import java.util.concurrent.atomic.AtomicReference;

public final class zzf {
    public static final int zza = 0;
    private static final AtomicReference zzb = new AtomicReference();
    private final Application zzc;
    private WeakReference zzg;
    private final Application.ActivityLifecycleCallbacks zzd = new zze(this, null);
    private final Object zze = new Object();
    private final Set zzf = Collections.newSetFromMap(new WeakHashMap());
    private boolean zzh = false;

    public zzf(Application application) {
        this.zzc = application;
    }

    public static zzf zza(Application application) {
        Preconditions.checkNotNull(application);
        AtomicReference atomicReference = zzb;
        zzf zzfVar = (zzf) atomicReference.get();
        if (zzfVar != null) {
            return zzfVar;
        }
        ComplexDouble$.ExternalSyntheticBackport0.m(atomicReference, (Object) null, new zzf(application));
        return (zzf) atomicReference.get();
    }

    public final void zze(zzc zzcVar) {
        Activity activityZzd = zzd();
        if (activityZzd == null) {
            return;
        }
        zzcVar.zza(activityZzd);
    }

    public final void zzb() {
        synchronized (this.zze) {
            if (!this.zzh) {
                this.zzc.registerActivityLifecycleCallbacks(this.zzd);
                this.zzh = true;
            }
        }
    }

    public final void zzc(final zzc zzcVar) {
        Preconditions.checkNotNull(zzcVar);
        synchronized (this.zze) {
            this.zzf.add(zzcVar);
        }
        if (Looper.myLooper() == Looper.getMainLooper()) {
            zze(zzcVar);
        } else {
            TaskExecutors.MAIN_THREAD.execute(new Runnable() {
                @Override
                public final void run() {
                    this.zza.zze(zzcVar);
                }
            });
        }
    }

    public final Activity zzd() {
        Activity activity;
        synchronized (this.zze) {
            WeakReference weakReference = this.zzg;
            activity = weakReference == null ? null : (Activity) weakReference.get();
        }
        return activity;
    }

    final void zzf(Activity activity) {
        Preconditions.checkNotNull(activity);
        synchronized (this.zze) {
            if (zzd() == activity) {
                return;
            }
            this.zzg = new WeakReference(activity);
            Iterator it = this.zzf.iterator();
            while (it.hasNext()) {
                ((zzc) it.next()).zza(activity);
            }
        }
    }

    final void zzg(Activity activity) {
        synchronized (this.zze) {
            WeakReference weakReference = this.zzg;
            if (weakReference == null) {
                return;
            }
            if (weakReference.get() == activity) {
                this.zzg = null;
            }
        }
    }
}
