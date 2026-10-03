package com.android.billingclient.api;

import android.net.Uri;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public final class DeveloperBillingOptionParams {
    private final Uri zza;
    private final int zzb;
    private final int zzc;

    public static final class Builder {
        private Uri zza;
        private int zzb = 0;
        private int zzc = 0;

        private Builder() {
        }

        Builder(zzdi zzdiVar) {
        }

        public DeveloperBillingOptionParams build() {
            if (this.zzc == 0) {
                throw new IllegalArgumentException("Billing program is required.");
            }
            Uri uri = this.zza;
            if (uri == null || uri.getScheme() != null) {
                return new DeveloperBillingOptionParams(this.zza, this.zzb, this.zzc, null);
            }
            throw new IllegalArgumentException("URI must have a scheme.");
        }

        public Builder setBillingProgram(int i) {
            this.zzc = i;
            return this;
        }

        public Builder setLaunchMode(int i) {
            this.zzb = i;
            return this;
        }

        public Builder setLinkUri(Uri uri) {
            this.zza = uri;
            return this;
        }
    }

    @Retention(RetentionPolicy.SOURCE)
    public @interface LaunchMode {
        public static final int CALLER_WILL_LAUNCH_LINK = 2;
        public static final int LAUNCH_IN_EXTERNAL_BROWSER_OR_APP = 1;
        public static final int LAUNCH_MODE_UNSPECIFIED = 0;
    }

    DeveloperBillingOptionParams(Uri uri, int i, int i2, zzdi zzdiVar) {
        this.zza = uri;
        this.zzb = i;
        this.zzc = i2;
    }

    public static Builder newBuilder() {
        return new Builder(null);
    }

    public int getBillingProgram() {
        return this.zzc;
    }

    public int getLaunchMode() {
        return this.zzb;
    }

    public Uri getLinkUri() {
        return this.zza;
    }
}
