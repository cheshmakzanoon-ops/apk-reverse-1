package com.android.billingclient.api;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.internal.play_billing.zzjd;
import com.google.android.gms.internal.play_billing.zzjk;
import org.json.JSONException;

final class zzca extends com.google.android.gms.internal.play_billing.zzaf {
    final BillingConfigResponseListener zza;
    final zzcz zzb;
    final int zzc;

    zzca(BillingConfigResponseListener billingConfigResponseListener, zzcz zzczVar, int i, zzch zzchVar) {
        this.zza = billingConfigResponseListener;
        this.zzb = zzczVar;
        this.zzc = i;
    }

    public final void zza(Bundle bundle) throws RemoteException {
        if (bundle == null) {
            zzcz zzczVar = this.zzb;
            zzjd zzjdVar = zzjd.zzak;
            BillingResult billingResult = zzdc.zzh;
            int i = zzcy.zza;
            zzczVar.zzb(zzcy.zzb(zzjdVar, 13, billingResult, null, zzjk.zza), this.zzc);
            this.zza.onBillingConfigResponse(billingResult, null);
            return;
        }
        int iZzb = com.google.android.gms.internal.play_billing.zzc.zzb(bundle, "BillingClient");
        String strZzk = com.google.android.gms.internal.play_billing.zzc.zzk(bundle, "BillingClient");
        BillingResult.Builder builderNewBuilder = BillingResult.newBuilder();
        builderNewBuilder.setResponseCode(iZzb);
        builderNewBuilder.setDebugMessage(strZzk);
        if (iZzb != 0) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "getBillingConfig() failed. Response code: " + iZzb);
            BillingResult billingResultBuild = builderNewBuilder.build();
            zzcz zzczVar2 = this.zzb;
            zzjd zzjdVar2 = zzjd.zzw;
            int i2 = zzcy.zza;
            zzczVar2.zzb(zzcy.zzb(zzjdVar2, 13, billingResultBuild, null, zzjk.zza), this.zzc);
            this.zza.onBillingConfigResponse(billingResultBuild, null);
            return;
        }
        if (!bundle.containsKey("BILLING_CONFIG")) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "getBillingConfig() returned a bundle with neither an error nor a billing config response");
            builderNewBuilder.setResponseCode(6);
            BillingResult billingResultBuild2 = builderNewBuilder.build();
            zzcz zzczVar3 = this.zzb;
            zzjd zzjdVar3 = zzjd.zzal;
            int i3 = zzcy.zza;
            zzczVar3.zzb(zzcy.zzb(zzjdVar3, 13, billingResultBuild2, null, zzjk.zza), this.zzc);
            this.zza.onBillingConfigResponse(billingResultBuild2, null);
            return;
        }
        try {
            this.zza.onBillingConfigResponse(builderNewBuilder.build(), new BillingConfig(bundle.getString("BILLING_CONFIG")));
        } catch (JSONException e) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Got a JSON exception trying to decode BillingConfig. \n Exception: ", e);
            zzcz zzczVar4 = this.zzb;
            zzjd zzjdVar4 = zzjd.zzam;
            BillingResult billingResult2 = zzdc.zzh;
            int i4 = zzcy.zza;
            zzczVar4.zzb(zzcy.zzb(zzjdVar4, 13, billingResult2, null, zzjk.zza), this.zzc);
            this.zza.onBillingConfigResponse(billingResult2, null);
        }
    }
}
