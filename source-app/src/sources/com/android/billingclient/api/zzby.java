package com.android.billingclient.api;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.internal.play_billing.zzjd;
import com.google.android.gms.internal.play_billing.zzjk;
import org.json.JSONException;

final class zzby extends com.google.android.gms.internal.play_billing.zzy {
    final ExternalOfferReportingDetailsListener zza;
    final zzcz zzb;
    final int zzc;

    zzby(ExternalOfferReportingDetailsListener externalOfferReportingDetailsListener, zzcz zzczVar, int i, zzch zzchVar) {
        this.zza = externalOfferReportingDetailsListener;
        this.zzb = zzczVar;
        this.zzc = i;
    }

    public final void zza(Bundle bundle) throws RemoteException {
        if (bundle == null) {
            zzcz zzczVar = this.zzb;
            zzjd zzjdVar = zzjd.zzaG;
            BillingResult billingResult = zzdc.zzh;
            int i = zzcy.zza;
            zzczVar.zzb(zzcy.zzb(zzjdVar, 24, billingResult, null, zzjk.zza), this.zzc);
            this.zza.onExternalOfferReportingDetailsResponse(billingResult, null);
            return;
        }
        int iZzb = com.google.android.gms.internal.play_billing.zzc.zzb(bundle, "BillingClient");
        BillingResult billingResultZza = zzdc.zza(iZzb, com.google.android.gms.internal.play_billing.zzc.zzk(bundle, "BillingClient"));
        if (iZzb != 0) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "createExternalOfferReportingDetailsAsync() failed. Response code: " + iZzb);
            zzcz zzczVar2 = this.zzb;
            zzjd zzjdVar2 = zzjd.zzw;
            int i2 = zzcy.zza;
            zzczVar2.zzb(zzcy.zzb(zzjdVar2, 24, billingResultZza, null, zzjk.zza), this.zzc);
            this.zza.onExternalOfferReportingDetailsResponse(billingResultZza, null);
            return;
        }
        try {
            this.zza.onExternalOfferReportingDetailsResponse(billingResultZza, new ExternalOfferReportingDetails(bundle.getString("CREATE_EXTERNAL_PAYMENT_REPORTING_DETAILS")));
        } catch (JSONException e) {
            com.google.android.gms.internal.play_billing.zzc.zzp("BillingClient", "Error when parsing invalid external offer reporting details. \n Exception: ", e);
            zzcz zzczVar3 = this.zzb;
            zzjd zzjdVar3 = zzjd.zzaH;
            BillingResult billingResult2 = zzdc.zzh;
            int i3 = zzcy.zza;
            zzczVar3.zzb(zzcy.zzb(zzjdVar3, 24, billingResult2, null, zzjk.zza), this.zzc);
            this.zza.onExternalOfferReportingDetailsResponse(billingResult2, null);
        }
    }
}
