package com.google.android.gms.common.internal;

import android.app.PendingIntent;
import android.os.Looper;
import android.os.Message;
import android.util.Log;
import com.google.android.gms.common.ConnectionResult;

final class zzb extends com.google.android.gms.internal.common.zzg {
    final BaseGmsClient zza;

    public zzb(BaseGmsClient baseGmsClient, Looper looper) {
        super(looper);
        j$.util.Objects.requireNonNull(baseGmsClient);
        this.zza = baseGmsClient;
    }

    private static final void zza(Message message) {
        zzc zzcVar = (zzc) message.obj;
        if (zzcVar != null) {
            zzcVar.zze();
        }
    }

    private static final boolean zzb(Message message) {
        return message.what == 2 || message.what == 1 || message.what == 7;
    }

    @Override
    public final void handleMessage(Message message) {
        BaseGmsClient baseGmsClient = this.zza;
        if (baseGmsClient.zzd.get() != message.arg1) {
            if (zzb(message)) {
                zza(message);
                return;
            }
            return;
        }
        if ((message.what == 1 || message.what == 7 || ((message.what == 4 && !baseGmsClient.enableLocalFallback()) || message.what == 5)) && !baseGmsClient.isConnecting()) {
            zza(message);
            return;
        }
        if (message.what == 4) {
            baseGmsClient.zzn(new ConnectionResult(message.arg2));
            if (baseGmsClient.zzg() && !baseGmsClient.zzo()) {
                baseGmsClient.zzd(3, null);
                return;
            }
            ConnectionResult connectionResultZzm = baseGmsClient.zzm() != null ? baseGmsClient.zzm() : new ConnectionResult(8);
            baseGmsClient.zzc.onReportServiceBinding(connectionResultZzm);
            baseGmsClient.onConnectionFailed(connectionResultZzm);
            return;
        }
        if (message.what == 5) {
            ConnectionResult connectionResultZzm2 = baseGmsClient.zzm() != null ? baseGmsClient.zzm() : new ConnectionResult(8);
            baseGmsClient.zzc.onReportServiceBinding(connectionResultZzm2);
            baseGmsClient.onConnectionFailed(connectionResultZzm2);
            return;
        }
        if (message.what == 3) {
            ConnectionResult connectionResult = new ConnectionResult(message.arg2, message.obj instanceof PendingIntent ? (PendingIntent) message.obj : null);
            baseGmsClient.zzc.onReportServiceBinding(connectionResult);
            baseGmsClient.onConnectionFailed(connectionResult);
            return;
        }
        if (message.what == 6) {
            baseGmsClient.zzd(5, null);
            if (baseGmsClient.zzk() != null) {
                baseGmsClient.zzk().onConnectionSuspended(message.arg2);
            }
            baseGmsClient.onConnectionSuspended(message.arg2);
            baseGmsClient.zze(5, 1, null);
            return;
        }
        if (message.what == 2 && !baseGmsClient.isConnected()) {
            zza(message);
            return;
        }
        if (zzb(message)) {
            ((zzc) message.obj).zzd();
            return;
        }
        int i = message.what;
        StringBuilder sb = new StringBuilder(String.valueOf(i).length() + 34);
        sb.append("Don't know how to handle message: ");
        sb.append(i);
        Log.wtf("GmsClient", sb.toString(), new Exception());
    }
}
