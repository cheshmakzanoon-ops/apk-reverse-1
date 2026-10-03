package com.google.android.gms.internal.p003authapi;

import android.content.Context;
import android.os.Bundle;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Looper;
import com.google.android.gms.auth.api.Auth;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.internal.ClientSettings;
import com.google.android.gms.common.internal.GmsClient;

public final class zzq extends GmsClient<zzx> {
    private final Auth.AuthCredentialsOptions zzar;

    public zzq(Context context, Looper looper, ClientSettings clientSettings, Auth.AuthCredentialsOptions authCredentialsOptions, GoogleApiClient.ConnectionCallbacks connectionCallbacks, GoogleApiClient.OnConnectionFailedListener onConnectionFailedListener) {
        super(context, looper, 68, clientSettings, connectionCallbacks, onConnectionFailedListener);
        this.zzar = new Auth.AuthCredentialsOptions.Builder(authCredentialsOptions == null ? Auth.AuthCredentialsOptions.zzk : authCredentialsOptions).zzc(zzal.zzr()).zzd();
    }

    @Override
    public final int getMinApkVersion() {
        return 12800000;
    }

    @Override
    protected final String getStartServiceAction() {
        return "com.google.android.gms.auth.api.credentials.service.START";
    }

    @Override
    protected final String getServiceDescriptor() {
        return "com.google.android.gms.auth.api.credentials.internal.ICredentialsService";
    }

    @Override
    protected final Bundle getGetServiceRequestExtraArgs() {
        return this.zzar.toBundle();
    }

    final Auth.AuthCredentialsOptions zze() {
        return this.zzar;
    }

    @Override
    protected final IInterface createServiceInterface(IBinder iBinder) {
        if (iBinder == null) {
            return null;
        }
        IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface("com.google.android.gms.auth.api.credentials.internal.ICredentialsService");
        if (iInterfaceQueryLocalInterface instanceof zzx) {
            return (zzx) iInterfaceQueryLocalInterface;
        }
        return new zzw(iBinder);
    }
}
