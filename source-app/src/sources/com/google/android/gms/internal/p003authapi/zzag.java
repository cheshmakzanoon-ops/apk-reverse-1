package com.google.android.gms.internal.p003authapi;

import android.content.Context;
import android.os.Looper;
import com.google.android.gms.auth.api.identity.SignInOptions;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.internal.ConnectionCallbacks;
import com.google.android.gms.common.api.internal.OnConnectionFailedListener;
import com.google.android.gms.common.internal.ClientSettings;

final class zzag extends Api.AbstractClientBuilder<zzak, SignInOptions> {
    zzag() {
    }

    @Override
    public final Api.Client buildClient(Context context, Looper looper, ClientSettings clientSettings, SignInOptions signInOptions, ConnectionCallbacks connectionCallbacks, OnConnectionFailedListener onConnectionFailedListener) {
        return new zzak(context, looper, signInOptions, clientSettings, connectionCallbacks, onConnectionFailedListener);
    }
}
