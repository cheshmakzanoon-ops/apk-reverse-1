package com.android.billingclient.api;

import android.net.Uri;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public final class LaunchExternalLinkParams {
    private final Uri zza;
    private final int zzb;
    private final int zzc;
    private final int zzd;

    public static final class Builder {
        private Uri zza;
        private int zzb = 0;
        private int zzc = 0;
        private int zzd = 0;

        private Builder() {
        }

        Builder(zzdr zzdrVar) {
        }

        public LaunchExternalLinkParams build() {
            int i = this.zzc;
            if (i == 0) {
                throw new IllegalArgumentException("Link type is required.");
            }
            int i2 = this.zzb;
            if (i2 == 0) {
                throw new IllegalArgumentException("Launch mode is required.");
            }
            if (i2 != 1 && i == 2) {
                throw new IllegalArgumentException("App downloads must launch in an external browser or app.");
            }
            if (this.zzd == 0) {
                throw new IllegalArgumentException("Billing program is required.");
            }
            Uri uri = this.zza;
            if (uri == null) {
                throw new IllegalArgumentException("URI must be set.");
            }
            if (uri.getScheme() != null) {
                return new LaunchExternalLinkParams(this.zza, this.zzb, this.zzc, this.zzd, null);
            }
            throw new IllegalArgumentException("URI must have a scheme.");
        }

        public Builder setBillingProgram(int i) {
            this.zzd = i;
            return this;
        }

        public Builder setLaunchMode(int i) {
            this.zzb = i;
            return this;
        }

        public Builder setLinkType(int i) {
            this.zzc = i;
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

    @Retention(RetentionPolicy.SOURCE)
    public @interface LinkType {
        public static final int LINK_TO_APP_DOWNLOAD = 2;
        public static final int LINK_TO_DIGITAL_CONTENT_OFFER = 1;
        public static final int LINK_TYPE_UNSPECIFIED = 0;
    }

    LaunchExternalLinkParams(Uri uri, int i, int i2, int i3, zzdr zzdrVar) {
        this.zza = uri;
        this.zzb = i;
        this.zzc = i2;
        this.zzd = i3;
    }

    public static Builder newBuilder() {
        return new Builder(null);
    }

    public int getBillingProgram() {
        return this.zzd;
    }

    public int getLaunchMode() {
        return this.zzb;
    }

    public int getLinkType() {
        return this.zzc;
    }

    public Uri getLinkUri() {
        return this.zza;
    }
}
