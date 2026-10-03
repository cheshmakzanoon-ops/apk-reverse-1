package com.google.android.gms.games.internal.p000v2.appshortcuts;

import android.content.Context;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Looper;
import com.google.android.gms.common.Feature;
import com.google.android.gms.common.api.internal.ConnectionCallbacks;
import com.google.android.gms.common.api.internal.OnConnectionFailedListener;
import com.google.android.gms.common.internal.ClientSettings;
import com.google.android.gms.common.internal.GmsClient;
import com.google.android.gms.games.zzd;

final class zzu extends GmsClient {
    public zzu(Context context, Looper looper, ClientSettings clientSettings, ConnectionCallbacks connectionCallbacks, OnConnectionFailedListener onConnectionFailedListener) {
        super(context, looper, 1, clientSettings, connectionCallbacks, onConnectionFailedListener);
    }

    @Override
    protected final IInterface createServiceInterface(IBinder iBinder) {
        if (iBinder == null) {
            return null;
        }
        IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface("com.google.android.gms.games.internal.v2.appshortcuts.IAppShortcutsService");
        return iInterfaceQueryLocalInterface instanceof zzv ? (zzv) iInterfaceQueryLocalInterface : new zzv(iBinder);
    }

    @Override
    public final Feature[] getApiFeatures() {
        return new Feature[]{zzd.zzg};
    }

    @Override
    protected final String getServiceDescriptor() {
        return "com.google.android.gms.games.internal.v2.appshortcuts.IAppShortcutsService";
    }

    @Override
    protected final String getStartServiceAction() {
        return "com.google.android.gms.games.internal.appshortcuts.service.START";
    }

    @Override
    public final boolean requiresGooglePlayServices() {
        return false;
    }

    @Override
    public final boolean usesClientTelemetry() {
        return true;
    }
}
