package com.google.android.gms.auth.api.identity;

import android.content.Intent;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.HasApiKey;
import com.google.android.gms.tasks.Task;

public interface SignInClient extends HasApiKey<SignInOptions> {
    Task<BeginSignInResult> beginSignIn(BeginSignInRequest beginSignInRequest);

    SignInCredential getSignInCredentialFromIntent(Intent intent) throws ApiException;

    Task<Void> signOut();
}
