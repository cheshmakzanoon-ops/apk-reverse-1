package com.google.android.gms.internal.auth;

import android.content.Context;
import android.os.Bundle;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Looper;
import android.text.TextUtils;
import com.google.android.gms.auth.api.AuthProxy;
import com.google.android.gms.auth.api.AuthProxyOptions;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.internal.ClientSettings;
import com.google.android.gms.common.internal.GmsClient;

public final class zzak extends GmsClient<zzan> {
    private final Bundle zzbv;

    public zzak(Context context, Looper looper, ClientSettings clientSettings, AuthProxyOptions authProxyOptions, GoogleApiClient.ConnectionCallbacks connectionCallbacks, GoogleApiClient.OnConnectionFailedListener onConnectionFailedListener) {
        super(context, looper, 16, clientSettings, connectionCallbacks, onConnectionFailedListener);
        if (authProxyOptions != null) {
            throw new NoSuchMethodError();
        }
        this.zzbv = new Bundle();
    }

    @Override
    public final int getMinApkVersion() {
        return 12451000;
    }

    @Override
    public final boolean requiresSignIn() {
        ClientSettings clientSettings = getClientSettings();
        return (TextUtils.isEmpty(clientSettings.getAccountName()) || clientSettings.getApplicableScopes(AuthProxy.API).isEmpty()) ? false : true;
    }

    @Override
    protected final String getStartServiceAction() {
        return "com.google.android.gms.auth.service.START";
    }

    @Override
    protected final String getServiceDescriptor() {
        return "com.google.android.gms.auth.api.internal.IAuthService";
    }

    @Override
    protected final Bundle getGetServiceRequestExtraArgs() {
        return this.zzbv;
    }

    @Override
    protected final IInterface createServiceInterface(IBinder iBinder) {
        if (iBinder == null) {
            return null;
        }
        IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface("com.google.android.gms.auth.api.internal.IAuthService");
        if (iInterfaceQueryLocalInterface instanceof zzan) {
            return (zzan) iInterfaceQueryLocalInterface;
        }
        return new zzao(iBinder);
    }
}
