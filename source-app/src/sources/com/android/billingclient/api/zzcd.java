package com.android.billingclient.api;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.internal.play_billing.zzjd;
import com.google.android.gms.internal.play_billing.zzjk;

final class zzcd extends com.google.android.gms.internal.play_billing.zzaj {
    final AlternativeBillingOnlyAvailabilityListener zza;
    final zzcz zzb;
    final int zzc;

    zzcd(AlternativeBillingOnlyAvailabilityListener alternativeBillingOnlyAvailabilityListener, zzcz zzczVar, int i, zzch zzchVar) {
        this.zza = alternativeBillingOnlyAvailabilityListener;
        this.zzb = zzczVar;
        this.zzc = i;
    }

    public final void zza(Bundle bundle) throws RemoteException {
        if (bundle == null) {
            zzcz zzczVar = this.zzb;
            zzjd zzjdVar = zzjd.zzao;
            BillingResult billingResult = zzdc.zzh;
            int i = zzcy.zza;
            zzczVar.zzb(zzcy.zzb(zzjdVar, 14, billingResult, null, zzjk.zza), this.zzc);
            this.zza.onAlternativeBillingOnlyAvailabilityResponse(billingResult);
            return;
        }
        int iZzb = com.google.android.gms.internal.play_billing.zzc.zzb(bundle, "BillingClient");
        BillingResult billingResultZza = zzdc.zza(iZzb, com.google.android.gms.internal.play_billing.zzc.zzk(bundle, "BillingClient"));
        if (iZzb != 0) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "isAlternativeBillingOnlyAvailableAsync() failed. Response code: " + iZzb);
            zzcz zzczVar2 = this.zzb;
            zzjd zzjdVar2 = zzjd.zzw;
            int i2 = zzcy.zza;
            zzczVar2.zzb(zzcy.zzb(zzjdVar2, 14, billingResultZza, null, zzjk.zza), this.zzc);
        }
        this.zza.onAlternativeBillingOnlyAvailabilityResponse(billingResultZza);
    }
}
