package com.android.billingclient.api;

import android.os.Bundle;
import android.os.Handler;
import android.os.ResultReceiver;
import com.google.android.gms.internal.play_billing.zzjd;
import com.google.android.gms.internal.play_billing.zzjk;
import j$.util.Objects;

final class zzbt extends ResultReceiver {
    final LaunchExternalLinkResponseListener zza;
    final BillingClientImpl zzb;

    zzbt(BillingClientImpl billingClientImpl, Handler handler, LaunchExternalLinkResponseListener launchExternalLinkResponseListener) {
        super(handler);
        this.zza = launchExternalLinkResponseListener;
        Objects.requireNonNull(billingClientImpl);
        this.zzb = billingClientImpl;
    }

    @Override
    public final void onReceiveResult(int i, Bundle bundle) {
        BillingResult.Builder builderNewBuilder = BillingResult.newBuilder();
        builderNewBuilder.setResponseCode(i);
        if (i != 0) {
            if (bundle == null) {
                this.zzb.zzaZ(this.zza, zzdc.zzh, zzjd.zzbF, null);
                return;
            }
            builderNewBuilder.setDebugMessage(com.google.android.gms.internal.play_billing.zzc.zzk(bundle, "BillingClient"));
            int i2 = bundle.getInt("INTERNAL_LOG_ERROR_REASON");
            BillingClientImpl billingClientImpl = this.zzb;
            zzjd zzjdVarZzb = i2 != 0 ? zzjd.zzb(i2) : zzjd.zzw;
            BillingResult billingResultBuild = builderNewBuilder.build();
            String string = bundle.getString("INTERNAL_LOG_ERROR_ADDITIONAL_DETAILS");
            int i3 = zzcy.zza;
            billingClientImpl.zzbc(zzcy.zzb(zzjdVarZzb, 37, billingResultBuild, string, zzjk.zza));
        }
        this.zza.onLaunchExternalLinkResponse(builderNewBuilder.build());
    }
}
