package com.google.android.gms.auth;

import android.os.IBinder;
import android.os.RemoteException;
import java.io.IOException;
import java.util.List;

final class zzg implements zzj<List<AccountChangeEvent>> {
    private final String zzr;
    private final int zzs;

    zzg(String str, int i) {
        this.zzr = str;
        this.zzs = i;
    }

    @Override
    public final List<AccountChangeEvent> zzb(IBinder iBinder) throws RemoteException, IOException, GoogleAuthException {
        return ((AccountChangeEventsResponse) zzd.zza(com.google.android.gms.internal.auth.zzf.zza(iBinder).zza(new AccountChangeEventsRequest().setAccountName(this.zzr).setEventIndex(this.zzs)))).getEvents();
    }
}
