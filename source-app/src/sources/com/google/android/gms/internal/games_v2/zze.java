package com.google.android.gms.internal.games_v2;

import android.app.Application;
import android.content.Context;
import android.os.Looper;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.internal.ConnectionCallbacks;
import com.google.android.gms.common.api.internal.OnConnectionFailedListener;
import com.google.android.gms.common.internal.ClientSettings;

class zze extends Api.AbstractClientBuilder {
    zze(byte[] bArr) {
    }

    @Override
    public final Api.Client buildClient(Context context, Looper looper, ClientSettings clientSettings, Object obj, ConnectionCallbacks connectionCallbacks, OnConnectionFailedListener onConnectionFailedListener) {
        com.google.android.gms.games.zzi zziVarZzd = (com.google.android.gms.games.zzi) obj;
        if (zziVarZzd == null) {
            zziVarZzd = com.google.android.gms.games.zzi.zza().zzd();
        }
        com.google.android.gms.games.internal.zzah zzahVar = new com.google.android.gms.games.internal.zzah(context, looper, clientSettings, zziVarZzd, connectionCallbacks, onConnectionFailedListener, com.google.android.gms.games.internal.zzao.zza());
        if (zziVarZzd.zzn.zza()) {
            int i = com.google.android.gms.games.internal.zzf.zza;
            zzahVar.zzp(com.google.android.gms.games.internal.zzf.zza((Application) context.getApplicationContext()));
        }
        return zzahVar;
    }

    @Override
    public final int getPriority() {
        return 1;
    }
}
