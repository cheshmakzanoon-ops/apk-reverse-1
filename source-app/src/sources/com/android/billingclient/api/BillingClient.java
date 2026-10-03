package com.android.billingclient.api;

import android.app.Activity;
import android.content.Context;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.concurrent.ExecutorService;

public abstract class BillingClient {

    @Retention(RetentionPolicy.SOURCE)
    public @interface BillingProgram {
        public static final int EXTERNAL_CONTENT_LINK = 1;
        public static final int EXTERNAL_OFFER = 3;
        public static final int EXTERNAL_PAYMENTS = 4;
        public static final int UNSPECIFIED_BILLING_PROGRAM = 0;
    }

    @Retention(RetentionPolicy.SOURCE)
    public @interface BillingResponseCode {
        public static final int BILLING_UNAVAILABLE = 3;
        public static final int DEVELOPER_ERROR = 5;
        public static final int ERROR = 6;
        public static final int FEATURE_NOT_SUPPORTED = -2;
        public static final int ITEM_ALREADY_OWNED = 7;
        public static final int ITEM_NOT_OWNED = 8;
        public static final int ITEM_UNAVAILABLE = 4;
        public static final int NETWORK_ERROR = 12;

        public static final int f287OK = 0;
        public static final int SERVICE_DISCONNECTED = -1;

        @Deprecated
        public static final int SERVICE_TIMEOUT = -3;
        public static final int SERVICE_UNAVAILABLE = 2;
        public static final int USER_CANCELED = 1;
    }

    @Retention(RetentionPolicy.SOURCE)
    public @interface ConnectionState {
        public static final int CLOSED = 3;
        public static final int CONNECTED = 2;
        public static final int CONNECTING = 1;
        public static final int DISCONNECTED = 0;
    }

    @Retention(RetentionPolicy.SOURCE)
    public @interface FeatureType {
        public static final String ALTERNATIVE_BILLING_ONLY = "jjj";
        public static final String BILLING_CONFIG = "ggg";
        public static final String EXTERNAL_OFFER = "kkk";
        public static final String INCLUDE_SUSPENDED_SUBSCRIPTIONS = "nnn";
        public static final String IN_APP_MESSAGING = "bbb";
        public static final String PRICE_CHANGE_CONFIRMATION = "priceChangeConfirmation";
        public static final String PRODUCT_DETAILS = "fff";
        public static final String SUBSCRIPTIONS = "subscriptions";
        public static final String SUBSCRIPTIONS_UPDATE = "subscriptionsUpdate";
    }

    @Retention(RetentionPolicy.SOURCE)
    public @interface OnPurchasesUpdatedSubResponseCode {
        public static final int NO_APPLICABLE_SUB_RESPONSE_CODE = 0;
        public static final int PAYMENT_DECLINED_DUE_TO_INSUFFICIENT_FUNDS = 1;
        public static final int USER_INELIGIBLE = 2;
    }

    @Retention(RetentionPolicy.SOURCE)
    public @interface ProductType {
        public static final String INAPP = "inapp";
        public static final String SUBS = "subs";
    }

    @Retention(RetentionPolicy.SOURCE)
    @Deprecated
    public @interface SkuType {
        public static final String INAPP = "inapp";
        public static final String SUBS = "subs";
    }

    public static Builder newBuilder(Context context) {
        return new Builder(context, null);
    }

    public abstract void acknowledgePurchase(AcknowledgePurchaseParams acknowledgePurchaseParams, AcknowledgePurchaseResponseListener acknowledgePurchaseResponseListener);

    public abstract void consumeAsync(ConsumeParams consumeParams, ConsumeResponseListener consumeResponseListener);

    public abstract void createAlternativeBillingOnlyReportingDetailsAsync(AlternativeBillingOnlyReportingDetailsListener alternativeBillingOnlyReportingDetailsListener);

    public abstract void createBillingProgramReportingDetailsAsync(BillingProgramReportingDetailsParams billingProgramReportingDetailsParams, BillingProgramReportingDetailsListener billingProgramReportingDetailsListener);

    @Deprecated
    public abstract void createExternalOfferReportingDetailsAsync(ExternalOfferReportingDetailsListener externalOfferReportingDetailsListener);

    public abstract void endConnection();

    public abstract void getBillingConfigAsync(GetBillingConfigParams getBillingConfigParams, BillingConfigResponseListener billingConfigResponseListener);

    public abstract int getConnectionState();

    public abstract void isAlternativeBillingOnlyAvailableAsync(AlternativeBillingOnlyAvailabilityListener alternativeBillingOnlyAvailabilityListener);

    public abstract void isBillingProgramAvailableAsync(int i, BillingProgramAvailabilityListener billingProgramAvailabilityListener);

    @Deprecated
    public abstract void isExternalOfferAvailableAsync(ExternalOfferAvailabilityListener externalOfferAvailabilityListener);

    public abstract BillingResult isFeatureSupported(String str);

    public abstract boolean isReady();

    public abstract BillingResult launchBillingFlow(Activity activity, BillingFlowParams billingFlowParams);

    public abstract void launchExternalLink(Activity activity, LaunchExternalLinkParams launchExternalLinkParams, LaunchExternalLinkResponseListener launchExternalLinkResponseListener);

    public abstract void queryProductDetailsAsync(QueryProductDetailsParams queryProductDetailsParams, ProductDetailsResponseListener productDetailsResponseListener);

    public abstract void queryPurchasesAsync(QueryPurchasesParams queryPurchasesParams, PurchasesResponseListener purchasesResponseListener);

    public abstract BillingResult showAlternativeBillingOnlyInformationDialog(Activity activity, AlternativeBillingOnlyInformationDialogListener alternativeBillingOnlyInformationDialogListener);

    @Deprecated
    public abstract BillingResult showExternalOfferInformationDialog(Activity activity, ExternalOfferInformationDialogListener externalOfferInformationDialogListener);

    public abstract BillingResult showInAppMessages(Activity activity, InAppMessageParams inAppMessageParams, InAppMessageResponseListener inAppMessageResponseListener);

    public abstract void startConnection(BillingClientStateListener billingClientStateListener);

    public static final class Builder {
        volatile boolean zza;
        volatile com.google.android.gms.internal.play_billing.zzbo zzb;
        private volatile String zzc;
        private volatile PendingPurchasesParams zzd;
        private final Context zze;
        private volatile PurchasesUpdatedListener zzf;
        private volatile zzdo zzg;
        private volatile zzcz zzh;
        private volatile zzb zzi;
        private volatile UserChoiceBillingListener zzj;
        private volatile DeveloperProvidedBillingListener zzk;
        private volatile ExecutorService zzl;
        private volatile boolean zzm;
        private volatile boolean zzn;
        private volatile boolean zzo;
        private volatile boolean zzp;
        private volatile boolean zzq;
        private volatile boolean zzr;

        Builder(Context context, zzac zzacVar) {
            this.zze = context;
        }

        private final boolean zza() {
            try {
                Context context = this.zze;
                return context.getPackageManager().getApplicationInfo(context.getPackageName(), 128).metaData.getBoolean("com.google.android.play.billingclient.enableBillingOverridesTesting", false);
            } catch (Exception e) {
                com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Unable to retrieve metadata value for enableBillingOverridesTesting.", e);
                return false;
            }
        }

        public BillingClient build() {
            Context context = this.zze;
            if (context == null) {
                throw new IllegalArgumentException("Please provide a valid Context.");
            }
            if (this.zzf == null) {
                if (this.zzj != null) {
                    throw new IllegalArgumentException("Please provide a valid listener for Google Play Billing purchases updates when enabling User Choice Billing.");
                }
                if (this.zzm || this.zzn || this.zzp || this.zzq || this.zzr) {
                    return zza() ? new zzcw(null, context, null, null, this) : new BillingClientImpl(null, context, null, null, this);
                }
                throw new IllegalArgumentException("Please provide a valid listener for purchases updates.");
            }
            if (this.zzd == null || !this.zzd.isEnabledForOneTimeProducts()) {
                throw new IllegalArgumentException("Pending purchases for one-time products must be supported.");
            }
            if (this.zzf == null) {
                PendingPurchasesParams pendingPurchasesParams = this.zzd;
                return zza() ? new zzcw(null, pendingPurchasesParams, context, null, null, null, this) : new BillingClientImpl(null, pendingPurchasesParams, context, null, null, null, this);
            }
            if (this.zzj == null && this.zzk == null) {
                PendingPurchasesParams pendingPurchasesParams2 = this.zzd;
                PurchasesUpdatedListener purchasesUpdatedListener = this.zzf;
                return zza() ? new zzcw(null, pendingPurchasesParams2, context, purchasesUpdatedListener, null, null, null, this) : new BillingClientImpl(null, pendingPurchasesParams2, context, purchasesUpdatedListener, null, null, null, this);
            }
            PendingPurchasesParams pendingPurchasesParams3 = this.zzd;
            PurchasesUpdatedListener purchasesUpdatedListener2 = this.zzf;
            UserChoiceBillingListener userChoiceBillingListener = this.zzj;
            DeveloperProvidedBillingListener developerProvidedBillingListener = this.zzk;
            return zza() ? new zzcw(null, pendingPurchasesParams3, context, purchasesUpdatedListener2, userChoiceBillingListener, developerProvidedBillingListener, null, null, this) : new BillingClientImpl(null, pendingPurchasesParams3, context, purchasesUpdatedListener2, userChoiceBillingListener, developerProvidedBillingListener, null, null, this);
        }

        public Builder enableAlternativeBillingOnly() {
            this.zzm = true;
            return this;
        }

        public Builder enableAutoServiceReconnection() {
            this.zza = true;
            return this;
        }

        public Builder enableBillingProgram(int i) {
            EnableBillingProgramParams.Builder builderNewBuilder = EnableBillingProgramParams.newBuilder();
            builderNewBuilder.setBillingProgram(i);
            enableBillingProgram(builderNewBuilder.build());
            return this;
        }

        @Deprecated
        public Builder enableExternalOffer() {
            this.zzn = true;
            return this;
        }

        public Builder enablePendingPurchases(PendingPurchasesParams pendingPurchasesParams) {
            this.zzd = pendingPurchasesParams;
            return this;
        }

        public Builder enableUserChoiceBilling(UserChoiceBillingListener userChoiceBillingListener) {
            this.zzj = userChoiceBillingListener;
            if (this.zzk == null) {
                return this;
            }
            throw new IllegalArgumentException("UserChoiceBillingListener and DeveloperProvidedBillingListener cannot be set at the same time.");
        }

        public Builder setListener(PurchasesUpdatedListener purchasesUpdatedListener) {
            this.zzf = purchasesUpdatedListener;
            return this;
        }

        public Builder enableBillingProgram(EnableBillingProgramParams enableBillingProgramParams) {
            if (enableBillingProgramParams.getDeveloperProvidedBillingListener() != null) {
                if (this.zzj != null) {
                    throw new IllegalArgumentException("UserChoiceBillingListener and DeveloperProvidedBillingListener cannot be set at the same time.");
                }
                if (enableBillingProgramParams.getBillingProgram() != 4) {
                    throw new IllegalArgumentException("DeveloperProvidedBillingListener can only be set when enabling the EXTERNAL_PAYMENTS billing program.");
                }
                this.zzk = enableBillingProgramParams.getDeveloperProvidedBillingListener();
            }
            int billingProgram = enableBillingProgramParams.getBillingProgram();
            if (billingProgram == 1) {
                this.zzp = true;
            } else if (billingProgram == 2) {
                this.zzq = true;
            } else if (billingProgram == 3) {
                this.zzn = true;
            } else {
                if (billingProgram != 4) {
                    throw new IllegalArgumentException("An invalid BillingProgram has been provided.");
                }
                this.zzr = true;
            }
            return this;
        }
    }
}
