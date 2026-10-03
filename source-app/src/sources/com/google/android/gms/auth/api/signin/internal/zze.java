package com.google.android.gms.auth.api.signin.internal;

import android.content.Intent;
import com.google.android.gms.auth.api.Auth;
import com.google.android.gms.auth.api.signin.GoogleSignInApi;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.auth.api.signin.GoogleSignInResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.OptionalPendingResult;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.Status;

public final class zze implements GoogleSignInApi {
    @Override
    public final Intent getSignInIntent(GoogleApiClient googleApiClient) {
        return zzg.zzc(googleApiClient.getContext(), zzc(googleApiClient));
    }

    @Override
    public final OptionalPendingResult<GoogleSignInResult> silentSignIn(GoogleApiClient googleApiClient) {
        return zzg.zzc(googleApiClient, googleApiClient.getContext(), zzc(googleApiClient), false);
    }

    @Override
    public final PendingResult<Status> signOut(GoogleApiClient googleApiClient) {
        return zzg.zzc(googleApiClient, googleApiClient.getContext(), false);
    }

    @Override
    public final PendingResult<Status> revokeAccess(GoogleApiClient googleApiClient) {
        return zzg.zzd(googleApiClient, googleApiClient.getContext(), false);
    }

    @Override
    public final GoogleSignInResult getSignInResultFromIntent(Intent intent) {
        return zzg.getSignInResultFromIntent(intent);
    }

    private static GoogleSignInOptions zzc(GoogleApiClient googleApiClient) {
        return ((zzh) googleApiClient.getClient(Auth.zzh)).zzj();
    }
}
