package com.google.android.gms.auth.api.identity;

import android.os.Bundle;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.internal.Objects;
import com.google.android.gms.common.internal.Preconditions;

public final class SignInOptions implements Api.ApiOptions.Optional {
    private final String zzau;

    public static Builder builder() {
        return new Builder();
    }

    public SignInOptions(String str) {
        this.zzau = str;
    }

    public static class Builder {
        private String zzau;

        public static Builder zzc(SignInOptions signInOptions) {
            Builder builder = new Builder();
            String strZzf = signInOptions.zzf();
            if (strZzf != null) {
                builder.zze(strZzf);
            }
            return builder;
        }

        private Builder() {
        }

        public final Builder zze(String str) {
            this.zzau = Preconditions.checkNotEmpty(str);
            return this;
        }

        public SignInOptions build() {
            return new SignInOptions(this.zzau);
        }
    }

    public final String zzf() {
        return this.zzau;
    }

    public final boolean equals(Object obj) {
        return obj instanceof SignInOptions;
    }

    public final int hashCode() {
        return Objects.hashCode(SignInOptions.class);
    }

    public final Bundle toBundle() {
        Bundle bundle = new Bundle();
        bundle.putString("session_id", this.zzau);
        return bundle;
    }
}
