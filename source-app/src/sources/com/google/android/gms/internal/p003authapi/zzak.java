package com.google.android.gms.internal.p003authapi;

import android.content.Context;
import android.os.Bundle;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Looper;
import com.google.android.gms.auth.api.identity.SignInOptions;
import com.google.android.gms.common.Feature;
import com.google.android.gms.common.api.internal.ConnectionCallbacks;
import com.google.android.gms.common.api.internal.OnConnectionFailedListener;
import com.google.android.gms.common.internal.ClientSettings;
import com.google.android.gms.common.internal.GmsClient;

public final class zzak extends GmsClient<zzad> {
    private final Bundle zzbl;

    public zzak(Context context, Looper looper, SignInOptions signInOptions, ClientSettings clientSettings, ConnectionCallbacks connectionCallbacks, OnConnectionFailedListener onConnectionFailedListener) {
        super(context, looper, 212, clientSettings, connectionCallbacks, onConnectionFailedListener);
        this.zzbl = signInOptions.toBundle();
    }

    @Override
    public final int getMinApkVersion() {
        return 17895000;
    }

    @Override
    protected final boolean getUseDynamicLookup() {
        return true;
    }

    @Override
    protected final String getStartServiceAction() {
        return "com.google.android.gms.auth.api.identity.service.signin.START";
    }

    @Override
    protected final String getServiceDescriptor() {
        return "com.google.android.gms.auth.api.identity.internal.ISignInService";
    }

    @Override
    protected final Bundle getGetServiceRequestExtraArgs() {
        return this.zzbl;
    }

    @Override
    public final Feature[] getApiFeatures() {
        return zzam.zzdd;
    }

    @Override
    protected final IInterface createServiceInterface(IBinder iBinder) {
        if (iBinder == null) {
            return null;
        }
        IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface("com.google.android.gms.auth.api.identity.internal.ISignInService");
        if (iInterfaceQueryLocalInterface instanceof zzad) {
            return (zzad) iInterfaceQueryLocalInterface;
        }
        return new zzac(iBinder);
    }
}
