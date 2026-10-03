package com.android.billingclient.api;

public final class QueryPurchasesParams {
    private final String zza;
    private final boolean zzb;

    public static class Builder {
        private String zza;
        private boolean zzb = false;

        private Builder() {
        }

        Builder(zzed zzedVar) {
        }

        public QueryPurchasesParams build() {
            String str = this.zza;
            if (str == null) {
                throw new IllegalArgumentException("Product type must be set");
            }
            if (!this.zzb || str.equals("subs")) {
                return new QueryPurchasesParams(this, null);
            }
            throw new IllegalArgumentException("includeSuspendedSubscriptions is only supported for subscription purchases");
        }

        public Builder includeSuspendedSubscriptions(boolean z) {
            this.zzb = z;
            return this;
        }

        public Builder setProductType(String str) {
            this.zza = str;
            return this;
        }
    }

    QueryPurchasesParams(Builder builder, zzed zzedVar) {
        this.zza = builder.zza;
        this.zzb = builder.zzb;
    }

    public static Builder newBuilder() {
        return new Builder(null);
    }

    public boolean getIncludeSuspendedSubscriptions() {
        return this.zzb;
    }

    public final String zza() {
        return this.zza;
    }
}
