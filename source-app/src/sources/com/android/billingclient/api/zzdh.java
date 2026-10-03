package com.android.billingclient.api;

import android.os.Bundle;
import com.google.android.gms.internal.play_billing.zzjd;

final class zzdh {
    public static BillingResult zza(Bundle bundle, String str, int i, zzcz zzczVar, int i2) {
        if (!bundle.containsKey("BILLING_RESULT")) {
            com.google.android.gms.internal.play_billing.zzc.zzo(str, "delegateToBackendAsync does not contain a billing result in the response");
            zzjd zzjdVar = zzjd.zzaU;
            BillingResult billingResult = zzdc.zzh;
            zzde.zza(zzjdVar, billingResult, zzczVar, i, i2);
            return billingResult;
        }
        try {
            byte[] byteArray = bundle.getByteArray("BILLING_RESULT");
            if (byteArray == null) {
                throw new Exception("Billing result is null");
            }
            com.google.android.gms.internal.play_billing.zzdw zzdwVarZzc = com.google.android.gms.internal.play_billing.zzdw.zzc(byteArray);
            BillingResult.Builder builderNewBuilder = BillingResult.newBuilder();
            builderNewBuilder.setResponseCode(zzdwVarZzc.zza());
            builderNewBuilder.setDebugMessage(zzdwVarZzc.zze());
            BillingResult billingResultBuild = builderNewBuilder.build();
            if (billingResultBuild.getResponseCode() != 0) {
                zzde.zza(zzjd.zzw, billingResultBuild, zzczVar, i, i2);
                return billingResultBuild;
            }
            if (bundle.containsKey("RESPONSE_DATA")) {
                return billingResultBuild;
            }
            com.google.android.gms.internal.play_billing.zzc.zzo(str, "delegateToBackendAsync returned a bundle with neither an error nor response data");
            zzjd zzjdVar2 = zzjd.zzaW;
            BillingResult billingResult2 = zzdc.zzh;
            zzde.zza(zzjdVar2, billingResult2, zzczVar, i, i2);
            return billingResult2;
        } catch (Exception e) {
            com.google.android.gms.internal.play_billing.zzc.zzp(str, "Failed parsing BillingResult.", e);
            zzjd zzjdVar3 = zzjd.zzaV;
            BillingResult billingResult3 = zzdc.zzh;
            zzde.zzb(zzjdVar3, billingResult3, zzczVar, i, i2, zzcy.zza(e));
            return billingResult3;
        }
    }
}
