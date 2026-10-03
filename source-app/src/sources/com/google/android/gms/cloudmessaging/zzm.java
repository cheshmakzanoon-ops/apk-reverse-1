package com.google.android.gms.cloudmessaging;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.util.Log;
import android.util.SparseArray;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.stats.ConnectionTracker;
import java.util.ArrayDeque;
import java.util.Iterator;
import java.util.Queue;
import java.util.concurrent.TimeUnit;

final class zzm implements ServiceConnection {
    zzn zzc;
    final zzs zzf;
    int zza = 0;
    final Messenger zzb = new Messenger(new com.google.android.gms.internal.cloudmessaging.zzf(Looper.getMainLooper(), new Handler.Callback() {
        @Override
        public final boolean handleMessage(Message message) {
            zzm zzmVar = this.zza;
            int i = message.arg1;
            if (Log.isLoggable("MessengerIpcClient", 3)) {
                StringBuilder sb = new StringBuilder(41);
                sb.append("Received response to request: ");
                sb.append(i);
                Log.d("MessengerIpcClient", sb.toString());
            }
            synchronized (zzmVar) {
                zzp<?> zzpVar = zzmVar.zze.get(i);
                if (zzpVar == null) {
                    StringBuilder sb2 = new StringBuilder(50);
                    sb2.append("Received response for unknown request: ");
                    sb2.append(i);
                    Log.w("MessengerIpcClient", sb2.toString());
                    return true;
                }
                zzmVar.zze.remove(i);
                zzmVar.zzf();
                Bundle data = message.getData();
                if (data.getBoolean("unsupported", false)) {
                    zzpVar.zzc(new zzq(4, "Not supported by GmsCore", null));
                    return true;
                }
                zzpVar.zza(data);
                return true;
            }
        }
    }));
    final Queue<zzp<?>> zzd = new ArrayDeque();
    final SparseArray<zzp<?>> zze = new SparseArray<>();

    zzm(zzs zzsVar, zzl zzlVar) {
        this.zzf = zzsVar;
    }

    @Override
    public final void onServiceConnected(ComponentName componentName, final IBinder iBinder) {
        if (Log.isLoggable("MessengerIpcClient", 2)) {
            Log.v("MessengerIpcClient", "Service connected");
        }
        this.zzf.zzc.execute(new Runnable() {
            @Override
            public final void run() {
                zzm zzmVar = this.zza;
                IBinder iBinder2 = iBinder;
                synchronized (zzmVar) {
                    try {
                        if (iBinder2 == null) {
                            zzmVar.zza(0, "Null service connection");
                            return;
                        }
                        try {
                            zzmVar.zzc = new zzn(iBinder2);
                            zzmVar.zza = 2;
                            zzmVar.zzc();
                        } catch (RemoteException e) {
                            zzmVar.zza(0, e.getMessage());
                        }
                    } catch (Throwable th) {
                        throw th;
                    }
                }
            }
        });
    }

    @Override
    public final void onServiceDisconnected(ComponentName componentName) {
        if (Log.isLoggable("MessengerIpcClient", 2)) {
            Log.v("MessengerIpcClient", "Service disconnected");
        }
        this.zzf.zzc.execute(new Runnable() {
            @Override
            public final void run() {
                this.zza.zza(2, "Service disconnected");
            }
        });
    }

    final synchronized void zza(int i, String str) {
        zzb(i, str, null);
    }

    final synchronized void zzb(int i, String str, Throwable th) {
        if (Log.isLoggable("MessengerIpcClient", 3)) {
            String strValueOf = String.valueOf(str);
            Log.d("MessengerIpcClient", strValueOf.length() != 0 ? "Disconnected: ".concat(strValueOf) : new String("Disconnected: "));
        }
        int i2 = this.zza;
        if (i2 == 0) {
            throw new IllegalStateException();
        }
        if (i2 != 1 && i2 != 2) {
            if (i2 != 3) {
                return;
            }
            this.zza = 4;
            return;
        }
        if (Log.isLoggable("MessengerIpcClient", 2)) {
            Log.v("MessengerIpcClient", "Unbinding service");
        }
        this.zza = 4;
        ConnectionTracker.getInstance().unbindService(this.zzf.zzb, this);
        zzq zzqVar = new zzq(i, str, th);
        Iterator<zzp<?>> it = this.zzd.iterator();
        while (it.hasNext()) {
            it.next().zzc(zzqVar);
        }
        this.zzd.clear();
        for (int i3 = 0; i3 < this.zze.size(); i3++) {
            this.zze.valueAt(i3).zzc(zzqVar);
        }
        this.zze.clear();
    }

    final void zzc() {
        this.zzf.zzc.execute(new Runnable() {
            @Override
            public final void run() {
                final zzp<?> zzpVarPoll;
                final zzm zzmVar = this.zza;
                while (true) {
                    synchronized (zzmVar) {
                        if (zzmVar.zza != 2) {
                            return;
                        }
                        if (zzmVar.zzd.isEmpty()) {
                            zzmVar.zzf();
                            return;
                        } else {
                            zzpVarPoll = zzmVar.zzd.poll();
                            zzmVar.zze.put(zzpVarPoll.zza, zzpVarPoll);
                            zzmVar.zzf.zzc.schedule(new Runnable() {
                                @Override
                                public final void run() {
                                    zzmVar.zze(zzpVarPoll.zza);
                                }
                            }, 30L, TimeUnit.SECONDS);
                        }
                    }
                    if (Log.isLoggable("MessengerIpcClient", 3)) {
                        String strValueOf = String.valueOf(zzpVarPoll);
                        StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 8);
                        sb.append("Sending ");
                        sb.append(strValueOf);
                        Log.d("MessengerIpcClient", sb.toString());
                    }
                    Context context = zzmVar.zzf.zzb;
                    Messenger messenger = zzmVar.zzb;
                    Message messageObtain = Message.obtain();
                    messageObtain.what = zzpVarPoll.zzc;
                    messageObtain.arg1 = zzpVarPoll.zza;
                    messageObtain.replyTo = messenger;
                    Bundle bundle = new Bundle();
                    bundle.putBoolean("oneWay", zzpVarPoll.zzb());
                    bundle.putString("pkg", context.getPackageName());
                    bundle.putBundle("data", zzpVarPoll.zzd);
                    messageObtain.setData(bundle);
                    try {
                        zzmVar.zzc.zza(messageObtain);
                    } catch (RemoteException e) {
                        zzmVar.zza(2, e.getMessage());
                    }
                }
            }
        });
    }

    final synchronized void zzd() {
        if (this.zza == 1) {
            zza(1, "Timed out while binding");
        }
    }

    final synchronized void zze(int i) {
        zzp<?> zzpVar = this.zze.get(i);
        if (zzpVar != null) {
            StringBuilder sb = new StringBuilder(31);
            sb.append("Timing out request: ");
            sb.append(i);
            Log.w("MessengerIpcClient", sb.toString());
            this.zze.remove(i);
            zzpVar.zzc(new zzq(3, "Timed out waiting for response", null));
            zzf();
        }
    }

    final synchronized void zzf() {
        if (this.zza == 2 && this.zzd.isEmpty() && this.zze.size() == 0) {
            if (Log.isLoggable("MessengerIpcClient", 2)) {
                Log.v("MessengerIpcClient", "Finished handling requests, unbinding");
            }
            this.zza = 3;
            ConnectionTracker.getInstance().unbindService(this.zzf.zzb, this);
        }
    }

    final synchronized boolean zzg(zzp<?> zzpVar) {
        try {
            int i = this.zza;
            if (i != 0) {
                if (i == 1) {
                    this.zzd.add(zzpVar);
                    return true;
                }
                if (i != 2) {
                    return false;
                }
                this.zzd.add(zzpVar);
                zzc();
                return true;
            }
            this.zzd.add(zzpVar);
            Preconditions.checkState(this.zza == 0);
            if (Log.isLoggable("MessengerIpcClient", 2)) {
                Log.v("MessengerIpcClient", "Starting bind to GmsCore");
            }
            this.zza = 1;
            Intent intent = new Intent("com.google.android.c2dm.intent.REGISTER");
            intent.setPackage("com.google.android.gms");
            try {
                if (ConnectionTracker.getInstance().bindService(this.zzf.zzb, intent, this, 1)) {
                    this.zzf.zzc.schedule(new Runnable() {
                        @Override
                        public final void run() {
                            this.zza.zzd();
                        }
                    }, 30L, TimeUnit.SECONDS);
                } else {
                    zza(0, "Unable to bind to service");
                }
            } catch (SecurityException e) {
                zzb(0, "Unable to bind to service", e);
            }
            return true;
        } catch (Throwable th) {
            throw th;
        }
    }
}
