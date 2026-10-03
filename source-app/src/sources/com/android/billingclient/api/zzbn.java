package com.android.billingclient.api;

import android.os.Bundle;
import android.os.Handler;
import android.os.ResultReceiver;
import j$.util.Objects;

final class zzbn extends ResultReceiver {
    final InAppMessageResponseListener zza;

    zzbn(BillingClientImpl billingClientImpl, Handler handler, InAppMessageResponseListener inAppMessageResponseListener) {
        super(handler);
        this.zza = inAppMessageResponseListener;
        Objects.requireNonNull(billingClientImpl);
    }

    @Override
    public final void onReceiveResult(int i, Bundle bundle) {
        this.zza.onInAppMessageResponse(com.google.android.gms.internal.play_billing.zzc.zzj(bundle, "BillingClient"));
    }
}
