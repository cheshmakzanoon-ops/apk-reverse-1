package com.android.billingclient.api;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

final class zzdy extends BroadcastReceiver {
    zzdy() {
    }

    @Override
    public final void onReceive(Context context, Intent intent) {
        if (intent == null || !intent.hasExtra("RESPONSE_CODE")) {
            com.google.android.gms.internal.play_billing.zzc.zzo("ProxyBillingBroadcastReceiver", "Null intent or intent missing response code!");
            return;
        }
        BillingResult.Builder builderNewBuilder = BillingResult.newBuilder();
        builderNewBuilder.setResponseCode(intent.getIntExtra("RESPONSE_CODE", 0));
        builderNewBuilder.setDebugMessage(com.google.android.gms.internal.play_billing.zzbm.zzc(intent.getStringExtra("DEBUG_MESSAGE")));
        builderNewBuilder.build();
    }
}
