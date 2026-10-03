package com.google.android.gms.games;

public final class AuthenticationResult {
    public static final AuthenticationResult zza = new AuthenticationResult(true);
    public static final AuthenticationResult zzb = new AuthenticationResult(false);
    private final boolean zzc;

    private AuthenticationResult(boolean z) {
        this.zzc = z;
    }

    public boolean isAuthenticated() {
        return this.zzc;
    }
}
