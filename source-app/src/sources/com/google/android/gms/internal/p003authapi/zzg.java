package com.google.android.gms.internal.p003authapi;

import com.google.android.gms.auth.api.credentials.Credential;
import com.google.android.gms.auth.api.credentials.CredentialRequestResult;
import com.google.android.gms.common.api.Status;

public final class zzg implements CredentialRequestResult {
    private final Status mStatus;
    private final Credential zzam;

    public zzg(Status status, Credential credential) {
        this.mStatus = status;
        this.zzam = credential;
    }

    @Override
    public final Status getStatus() {
        return this.mStatus;
    }

    @Override
    public final Credential getCredential() {
        return this.zzam;
    }

    public static zzg zzc(Status status) {
        return new zzg(status, null);
    }
}
