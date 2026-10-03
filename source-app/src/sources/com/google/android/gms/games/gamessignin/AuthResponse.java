package com.google.android.gms.games.gamessignin;

import j$.util.Objects;
import java.util.List;

public final class AuthResponse {
    private final List zza;
    private final String zzb;

    public AuthResponse(String str, List<AuthScope> list) {
        Objects.requireNonNull(list, "Granted scopes list cannot be null");
        this.zzb = str;
        this.zza = list;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj instanceof AuthResponse) {
            AuthResponse authResponse = (AuthResponse) obj;
            if (this.zza.equals(authResponse.zza) && this.zzb.equals(authResponse.zzb)) {
                return true;
            }
        }
        return false;
    }

    public String getAuthCode() {
        return this.zzb;
    }

    public List<AuthScope> getGrantedScopes() {
        return this.zza;
    }

    public int hashCode() {
        return Objects.hash(new Object[]{this.zza, this.zzb});
    }

    public String toString() {
        String strValueOf = String.valueOf(this.zza);
        int length = String.valueOf(strValueOf).length();
        String str = this.zzb;
        StringBuilder sb = new StringBuilder(length + 39 + String.valueOf(str).length() + 2);
        sb.append("AuthResponse{grantedScopes=");
        sb.append(strValueOf);
        sb.append(", authCode='");
        sb.append(str);
        sb.append("'}");
        return sb.toString();
    }
}
