package com.google.android.gms.auth.api.signin.internal;

import android.content.Context;
import android.content.Intent;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Looper;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.Scope;
import com.google.android.gms.common.internal.ClientSettings;
import com.google.android.gms.common.internal.GmsClient;
import com.google.android.gms.internal.p003authapi.zzal;
import java.util.Iterator;

public final class zzh extends GmsClient<zzv> {
    private final GoogleSignInOptions zzcd;

    public zzh(Context context, Looper looper, ClientSettings clientSettings, GoogleSignInOptions googleSignInOptions, GoogleApiClient.ConnectionCallbacks connectionCallbacks, GoogleApiClient.OnConnectionFailedListener onConnectionFailedListener) {
        super(context, looper, 91, clientSettings, connectionCallbacks, onConnectionFailedListener);
        GoogleSignInOptions.Builder builder = googleSignInOptions != null ? new GoogleSignInOptions.Builder(googleSignInOptions) : new GoogleSignInOptions.Builder();
        builder.setLogSessionId(zzal.zzr());
        if (!clientSettings.getAllRequestedScopes().isEmpty()) {
            Iterator<Scope> it = clientSettings.getAllRequestedScopes().iterator();
            while (it.hasNext()) {
                builder.requestScopes(it.next(), new Scope[0]);
            }
        }
        this.zzcd = builder.build();
    }

    @Override
    public final int getMinApkVersion() {
        return 12451000;
    }

    @Override
    public final boolean providesSignIn() {
        return true;
    }

    @Override
    protected final String getStartServiceAction() {
        return "com.google.android.gms.auth.api.signin.service.START";
    }

    @Override
    protected final String getServiceDescriptor() {
        return "com.google.android.gms.auth.api.signin.internal.ISignInService";
    }

    @Override
    public final Intent getSignInIntent() {
        return zzg.zzc(getContext(), this.zzcd);
    }

    public final GoogleSignInOptions zzj() {
        return this.zzcd;
    }

    @Override
    protected final IInterface createServiceInterface(IBinder iBinder) {
        if (iBinder == null) {
            return null;
        }
        IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface("com.google.android.gms.auth.api.signin.internal.ISignInService");
        if (iInterfaceQueryLocalInterface instanceof zzv) {
            return (zzv) iInterfaceQueryLocalInterface;
        }
        return new zzu(iBinder);
    }
}
