package com.google.android.gms.auth.api;

import android.content.Context;
import android.os.Looper;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.internal.ClientSettings;
import com.google.android.gms.internal.p003authapi.zzq;

final class zzc extends Api.AbstractClientBuilder<zzq, Auth.AuthCredentialsOptions> {
    zzc() {
    }

    @Override
    public final Api.Client buildClient(Context context, Looper looper, ClientSettings clientSettings, Auth.AuthCredentialsOptions authCredentialsOptions, GoogleApiClient.ConnectionCallbacks connectionCallbacks, GoogleApiClient.OnConnectionFailedListener onConnectionFailedListener) {
        return new zzq(context, looper, clientSettings, authCredentialsOptions, connectionCallbacks, onConnectionFailedListener);
    }
}
