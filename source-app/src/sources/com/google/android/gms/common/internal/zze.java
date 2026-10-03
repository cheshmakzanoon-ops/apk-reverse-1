package com.google.android.gms.common.internal;

import android.content.ComponentName;
import android.content.ServiceConnection;
import android.os.Handler;
import android.os.IBinder;
import android.os.IInterface;

public final class zze implements ServiceConnection {
    final BaseGmsClient zza;
    private final int zzb;

    public zze(BaseGmsClient baseGmsClient, int i) {
        j$.util.Objects.requireNonNull(baseGmsClient);
        this.zza = baseGmsClient;
        this.zzb = i;
    }

    @Override
    public final void onServiceConnected(ComponentName componentName, IBinder iBinder) {
        BaseGmsClient baseGmsClient = this.zza;
        if (iBinder == null) {
            baseGmsClient.zzf(16);
            return;
        }
        synchronized (baseGmsClient.zzh()) {
            IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface("com.google.android.gms.common.internal.IGmsServiceBroker");
            baseGmsClient.zzi((iInterfaceQueryLocalInterface == null || !(iInterfaceQueryLocalInterface instanceof IGmsServiceBroker)) ? new zzaa(iBinder) : (IGmsServiceBroker) iInterfaceQueryLocalInterface);
        }
        this.zza.zzb(0, null, this.zzb);
    }

    @Override
    public final void onServiceDisconnected(ComponentName componentName) {
        BaseGmsClient baseGmsClient = this.zza;
        synchronized (baseGmsClient.zzh()) {
            baseGmsClient.zzi(null);
        }
        BaseGmsClient baseGmsClient2 = this.zza;
        int i = this.zzb;
        Handler handler = baseGmsClient2.zzb;
        handler.sendMessage(handler.obtainMessage(6, i, 1));
    }
}
