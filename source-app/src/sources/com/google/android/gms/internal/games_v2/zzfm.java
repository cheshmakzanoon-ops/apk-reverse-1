package com.google.android.gms.internal.games_v2;

import android.content.Context;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Looper;
import com.google.android.gms.common.Feature;
import com.google.android.gms.common.api.internal.ConnectionCallbacks;
import com.google.android.gms.common.api.internal.OnConnectionFailedListener;
import com.google.android.gms.common.internal.ClientSettings;
import com.google.android.gms.common.internal.GmsClient;

public final class zzfm extends GmsClient {
    public zzfm(Context context, Looper looper, ClientSettings clientSettings, ConnectionCallbacks connectionCallbacks, OnConnectionFailedListener onConnectionFailedListener) {
        super(context, looper, 1, clientSettings, connectionCallbacks, onConnectionFailedListener);
    }

    @Override
    protected final IInterface createServiceInterface(IBinder iBinder) {
        return zzak.zzb(iBinder);
    }

    @Override
    public final Feature[] getApiFeatures() {
        return new Feature[]{com.google.android.gms.games.zzd.zze};
    }

    @Override
    public final int getMinApkVersion() {
        return 223600000;
    }

    @Override
    protected final String getServiceDescriptor() {
        return "com.google.android.gms.games.internal.recall.IRecallService";
    }

    @Override
    protected final String getStartServiceAction() {
        return "com.google.android.gms.games.internal.recall.service.START";
    }
}
