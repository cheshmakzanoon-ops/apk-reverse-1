package com.android.billingclient.api;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.internal.play_billing.zzjd;
import com.google.android.gms.internal.play_billing.zzjk;
import org.json.JSONException;

final class zzbx extends com.google.android.gms.internal.play_billing.zzw {
    final AlternativeBillingOnlyReportingDetailsListener zza;
    final zzcz zzb;
    final int zzc;

    zzbx(AlternativeBillingOnlyReportingDetailsListener alternativeBillingOnlyReportingDetailsListener, zzcz zzczVar, int i, zzch zzchVar) {
        this.zza = alternativeBillingOnlyReportingDetailsListener;
        this.zzb = zzczVar;
        this.zzc = i;
    }

    public final void zza(Bundle bundle) throws RemoteException {
        if (bundle == null) {
            zzcz zzczVar = this.zzb;
            zzjd zzjdVar = zzjd.zzas;
            BillingResult billingResult = zzdc.zzh;
            int i = zzcy.zza;
            zzczVar.zzb(zzcy.zzb(zzjdVar, 15, billingResult, null, zzjk.zza), this.zzc);
            this.zza.onAlternativeBillingOnlyTokenResponse(billingResult, null);
            return;
        }
        int iZzb = com.google.android.gms.internal.play_billing.zzc.zzb(bundle, "BillingClient");
        BillingResult billingResultZza = zzdc.zza(iZzb, com.google.android.gms.internal.play_billing.zzc.zzk(bundle, "BillingClient"));
        if (iZzb != 0) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "createAlternativeBillingOnlyReportingDetailsAsync() failed. Response code: " + iZzb);
            zzcz zzczVar2 = this.zzb;
            zzjd zzjdVar2 = zzjd.zzw;
            int i2 = zzcy.zza;
            zzczVar2.zzb(zzcy.zzb(zzjdVar2, 15, billingResultZza, null, zzjk.zza), this.zzc);
            this.zza.onAlternativeBillingOnlyTokenResponse(billingResultZza, null);
            return;
        }
        try {
            this.zza.onAlternativeBillingOnlyTokenResponse(billingResultZza, new AlternativeBillingOnlyReportingDetails(bundle.getString("CREATE_ALTERNATIVE_BILLING_ONLY_REPORTING_DETAILS")));
        } catch (JSONException e) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Error when parsing invalid alternative billing only reporting details. \n Exception: ", e);
            zzcz zzczVar3 = this.zzb;
            zzjd zzjdVar3 = zzjd.zzat;
            BillingResult billingResult2 = zzdc.zzh;
            int i3 = zzcy.zza;
            zzczVar3.zzb(zzcy.zzb(zzjdVar3, 15, billingResult2, null, zzjk.zza), this.zzc);
            this.zza.onAlternativeBillingOnlyTokenResponse(billingResult2, null);
        }
    }
}
