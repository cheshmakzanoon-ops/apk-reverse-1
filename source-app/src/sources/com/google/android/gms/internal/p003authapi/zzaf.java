package com.google.android.gms.internal.p003authapi;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.RemoteException;
import com.google.android.gms.auth.api.identity.BeginSignInRequest;
import com.google.android.gms.auth.api.identity.BeginSignInResult;
import com.google.android.gms.auth.api.identity.SignInClient;
import com.google.android.gms.auth.api.identity.SignInCredential;
import com.google.android.gms.auth.api.identity.SignInOptions;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.GoogleApiManager;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.internal.safeparcel.SafeParcelableSerializer;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;
import java.util.Iterator;

public final class zzaf extends GoogleApi<SignInOptions> implements SignInClient {
    private static final Api<SignInOptions> API;
    private static final Api.ClientKey<zzak> CLIENT_KEY;
    private static final Api.AbstractClientBuilder<zzak, SignInOptions> zzbj;

    public zzaf(Context context, SignInOptions signInOptions) {
        super(context, API, SignInOptions.Builder.zzc(signInOptions).zze(zzal.zzr()).build(), GoogleApi.Settings.DEFAULT_SETTINGS);
    }

    public zzaf(Activity activity, SignInOptions signInOptions) {
        super(activity, API, SignInOptions.Builder.zzc(signInOptions).zze(zzal.zzr()).build(), GoogleApi.Settings.DEFAULT_SETTINGS);
    }

    @Override
    public final Task<BeginSignInResult> beginSignIn(BeginSignInRequest beginSignInRequest) {
        final BeginSignInRequest beginSignInRequestBuild = BeginSignInRequest.zzc(beginSignInRequest).zzd(getApiOptions().zzf()).build();
        return doRead(TaskApiCall.builder().setFeatures(zzam.zzcw).run(new RemoteCall(this, beginSignInRequestBuild) {
            private final zzaf zzbh;
            private final BeginSignInRequest zzbi;

            {
                this.zzbh = this;
                this.zzbi = beginSignInRequestBuild;
            }

            @Override
            public final void accept(Object obj, Object obj2) throws RemoteException {
                zzaf zzafVar = this.zzbh;
                BeginSignInRequest beginSignInRequest2 = this.zzbi;
                ((zzad) ((zzak) obj).getService()).zzc(new zzaj(zzafVar, (TaskCompletionSource) obj2), (BeginSignInRequest) Preconditions.checkNotNull(beginSignInRequest2));
            }
        }).setAutoResolveMissingFeatures(false).build());
    }

    @Override
    public final Task<Void> signOut() {
        getApplicationContext().getSharedPreferences("com.google.android.gms.signin", 0).edit().clear().apply();
        Iterator<GoogleApiClient> it = GoogleApiClient.getAllClients().iterator();
        while (it.hasNext()) {
            it.next().maybeSignOut();
        }
        GoogleApiManager.reportSignOut();
        return doRead(TaskApiCall.builder().setFeatures(zzam.zzcx).run(new RemoteCall(this) {
            private final zzaf zzbh;

            {
                this.zzbh = this;
            }

            @Override
            public final void accept(Object obj, Object obj2) throws RemoteException {
                zzaf zzafVar = this.zzbh;
                ((zzad) ((zzak) obj).getService()).zzc(new zzai(zzafVar, (TaskCompletionSource) obj2), zzafVar.getApiOptions().zzf());
            }
        }).setAutoResolveMissingFeatures(false).build());
    }

    @Override
    public final SignInCredential getSignInCredentialFromIntent(Intent intent) throws ApiException {
        if (intent == null) {
            throw new ApiException(Status.RESULT_INTERNAL_ERROR);
        }
        Status status = (Status) SafeParcelableSerializer.deserializeFromIntentExtra(intent, "status", Status.CREATOR);
        if (status == null) {
            throw new ApiException(Status.RESULT_CANCELED);
        }
        if (!status.isSuccess()) {
            throw new ApiException(status);
        }
        SignInCredential signInCredential = (SignInCredential) SafeParcelableSerializer.deserializeFromIntentExtra(intent, "sign_in_credential", SignInCredential.CREATOR);
        if (signInCredential != null) {
            return signInCredential;
        }
        throw new ApiException(Status.RESULT_INTERNAL_ERROR);
    }

    static {
        Api.ClientKey<zzak> clientKey = new Api.ClientKey<>();
        CLIENT_KEY = clientKey;
        zzag zzagVar = new zzag();
        zzbj = zzagVar;
        API = new Api<>("Auth.Api.Identity.SignIn.API", zzagVar, clientKey);
    }
}
