package com.google.android.gms.auth.api.signin.internal;

import android.accounts.Account;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.auth.api.signin.GoogleSignInResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.OptionalPendingResult;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.PendingResults;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.GoogleApiManager;
import com.google.android.gms.common.api.internal.OptionalPendingResultImpl;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.logging.Logger;
import java.util.HashSet;
import java.util.Iterator;

public final class zzg {
    private static Logger zzby = new Logger("GoogleSignInCommon", new String[0]);

    public static Intent zzc(Context context, GoogleSignInOptions googleSignInOptions) {
        zzby.m15d("getSignInIntent()", new Object[0]);
        SignInConfiguration signInConfiguration = new SignInConfiguration(context.getPackageName(), googleSignInOptions);
        Intent intent = new Intent("com.google.android.gms.auth.GOOGLE_SIGN_IN");
        intent.setPackage(context.getPackageName());
        intent.setClass(context, SignInHubActivity.class);
        Bundle bundle = new Bundle();
        bundle.putParcelable("config", signInConfiguration);
        intent.putExtra("config", bundle);
        return intent;
    }

    public static Intent zzd(Context context, GoogleSignInOptions googleSignInOptions) {
        zzby.m15d("getFallbackSignInIntent()", new Object[0]);
        Intent intentZzc = zzc(context, googleSignInOptions);
        intentZzc.setAction("com.google.android.gms.auth.APPAUTH_SIGN_IN");
        return intentZzc;
    }

    public static Intent zze(Context context, GoogleSignInOptions googleSignInOptions) {
        zzby.m15d("getNoImplementationSignInIntent()", new Object[0]);
        Intent intentZzc = zzc(context, googleSignInOptions);
        intentZzc.setAction("com.google.android.gms.auth.NO_IMPL");
        return intentZzc;
    }

    public static OptionalPendingResult<GoogleSignInResult> zzc(GoogleApiClient googleApiClient, Context context, GoogleSignInOptions googleSignInOptions, boolean z) {
        GoogleSignInResult googleSignInResult;
        boolean zEquals;
        GoogleSignInAccount googleSignInAccountZzk;
        zzby.m15d("silentSignIn()", new Object[0]);
        zzby.m15d("getEligibleSavedSignInResult()", new Object[0]);
        Preconditions.checkNotNull(googleSignInOptions);
        GoogleSignInOptions googleSignInOptionsZzl = zzo.zzd(context).zzl();
        if (googleSignInOptionsZzl != null) {
            Account account = googleSignInOptionsZzl.getAccount();
            Account account2 = googleSignInOptions.getAccount();
            if (account == null) {
                zEquals = account2 == null;
            } else {
                zEquals = account.equals(account2);
            }
            if (!zEquals || googleSignInOptions.isServerAuthCodeRequested() || ((googleSignInOptions.isIdTokenRequested() && !(googleSignInOptionsZzl.isIdTokenRequested() && googleSignInOptions.getServerClientId().equals(googleSignInOptionsZzl.getServerClientId()))) || !new HashSet(googleSignInOptionsZzl.getScopes()).containsAll(new HashSet(googleSignInOptions.getScopes())) || (googleSignInAccountZzk = zzo.zzd(context).zzk()) == null || googleSignInAccountZzk.isExpired())) {
                googleSignInResult = null;
            } else {
                googleSignInResult = new GoogleSignInResult(googleSignInAccountZzk, Status.RESULT_SUCCESS);
            }
        } else {
            googleSignInResult = null;
        }
        if (googleSignInResult != null) {
            zzby.m15d("Eligible saved sign in result found", new Object[0]);
            return PendingResults.immediatePendingResult(googleSignInResult, googleApiClient);
        }
        if (z) {
            return PendingResults.immediatePendingResult(new GoogleSignInResult(null, new Status(4)), googleApiClient);
        }
        zzby.m15d("trySilentSignIn()", new Object[0]);
        return new OptionalPendingResultImpl(googleApiClient.enqueue(new zzj(googleApiClient, context, googleSignInOptions)));
    }

    public static PendingResult<Status> zzc(GoogleApiClient googleApiClient, Context context, boolean z) {
        zzby.m15d("Signing out", new Object[0]);
        zzc(context);
        if (z) {
            return PendingResults.immediatePendingResult(Status.RESULT_SUCCESS, googleApiClient);
        }
        return googleApiClient.execute(new zzl(googleApiClient));
    }

    public static PendingResult<Status> zzd(GoogleApiClient googleApiClient, Context context, boolean z) {
        zzby.m15d("Revoking access", new Object[0]);
        String savedRefreshToken = Storage.getInstance(context).getSavedRefreshToken();
        zzc(context);
        if (z) {
            return zzc.zzf(savedRefreshToken);
        }
        return googleApiClient.execute(new zzn(googleApiClient));
    }

    private static void zzc(Context context) {
        zzo.zzd(context).clear();
        Iterator<GoogleApiClient> it = GoogleApiClient.getAllClients().iterator();
        while (it.hasNext()) {
            it.next().maybeSignOut();
        }
        GoogleApiManager.reportSignOut();
    }

    public static GoogleSignInResult getSignInResultFromIntent(Intent intent) {
        if (intent == null) {
            return new GoogleSignInResult(null, Status.RESULT_INTERNAL_ERROR);
        }
        Status status = (Status) intent.getParcelableExtra("googleSignInStatus");
        GoogleSignInAccount googleSignInAccount = (GoogleSignInAccount) intent.getParcelableExtra("googleSignInAccount");
        if (googleSignInAccount == null) {
            if (status == null) {
                status = Status.RESULT_INTERNAL_ERROR;
            }
            return new GoogleSignInResult(null, status);
        }
        return new GoogleSignInResult(googleSignInAccount, Status.RESULT_SUCCESS);
    }
}
