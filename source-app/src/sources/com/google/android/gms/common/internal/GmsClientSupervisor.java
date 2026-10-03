package com.google.android.gms.common.internal;

import android.content.ComponentName;
import android.content.Context;
import android.content.ServiceConnection;
import android.os.HandlerThread;
import com.google.android.gms.common.ConnectionResult;
import java.util.concurrent.Executor;

public abstract class GmsClientSupervisor {
    static HandlerThread zza = null;
    private static final Object zzb = new Object();
    private static int zzc = 9;
    private static zzq zzd;
    private static Executor zze;
    private static boolean zzf;

    public static int getDefaultBindFlags() {
        return 4225;
    }

    public static GmsClientSupervisor getInstance(Context context) {
        synchronized (zzb) {
            if (zzd == null) {
                zzd = new zzq(context.getApplicationContext(), zzf ? getOrStartHandlerThread().getLooper() : context.getMainLooper(), zze);
            }
        }
        return zzd;
    }

    public static HandlerThread getOrStartHandlerThread() {
        synchronized (zzb) {
            HandlerThread handlerThread = zza;
            if (handlerThread != null) {
                return handlerThread;
            }
            HandlerThread handlerThread2 = new HandlerThread("GoogleApiHandler", zzc);
            zza = handlerThread2;
            handlerThread2.start();
            return zza;
        }
    }

    public static void setDefaultBindExecutor(Executor executor) {
        synchronized (zzb) {
            zzq zzqVar = zzd;
            if (zzqVar != null) {
                zzqVar.zze(executor);
            }
            zze = executor;
        }
    }

    public static boolean setGamHandlerThreadPriorityIfNotInitialized(int i) {
        synchronized (zzb) {
            if (zza != null) {
                return false;
            }
            zzc = i;
            return true;
        }
    }

    public static void setUseHandlerThreadForCallbacks() {
        synchronized (zzb) {
            zzq zzqVar = zzd;
            if (zzqVar != null && !zzf) {
                zzqVar.zzd(getOrStartHandlerThread().getLooper());
            }
            zzf = true;
        }
    }

    public boolean bindService(ComponentName componentName, ServiceConnection serviceConnection, String str) {
        return zza(new zzn(componentName, 4225), serviceConnection, str, null).isSuccess();
    }

    public void unbindService(ComponentName componentName, ServiceConnection serviceConnection, String str) {
        zzc(new zzn(componentName, 4225), serviceConnection, str);
    }

    protected abstract ConnectionResult zza(zzn zznVar, ServiceConnection serviceConnection, String str, Executor executor);

    public final void zzb(String str, String str2, int i, ServiceConnection serviceConnection, String str3, boolean z) {
        zzc(new zzn(str, str2, 4225, z), serviceConnection, str3);
    }

    protected abstract void zzc(zzn zznVar, ServiceConnection serviceConnection, String str);

    public void unbindService(String str, ServiceConnection serviceConnection, String str2) {
        zzc(new zzn(str, 4225, false), serviceConnection, str2);
    }

    public boolean bindService(ComponentName componentName, ServiceConnection serviceConnection, String str, Executor executor) {
        return zza(new zzn(componentName, 4225), serviceConnection, str, executor).isSuccess();
    }

    public static HandlerThread getOrStartHandlerThread(int i) {
        synchronized (zzb) {
            HandlerThread handlerThread = zza;
            if (handlerThread != null) {
                return handlerThread;
            }
            HandlerThread handlerThread2 = new HandlerThread("GoogleApiHandler", i);
            zza = handlerThread2;
            handlerThread2.start();
            return zza;
        }
    }

    public boolean bindService(String str, ServiceConnection serviceConnection, String str2) {
        return zza(new zzn(str, 4225, false), serviceConnection, str2, null).isSuccess();
    }
}
