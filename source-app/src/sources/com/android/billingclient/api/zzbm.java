package com.android.billingclient.api;

import android.text.TextUtils;
import com.google.android.gms.internal.play_billing.zzjd;
import j$.util.Objects;
import java.util.concurrent.Callable;

final class zzbm implements Callable {
    final PurchasesResponseListener zza;
    final String zzb;
    final boolean zzc;
    final BillingClientImpl zzd;

    zzbm(BillingClientImpl billingClientImpl, PurchasesResponseListener purchasesResponseListener, String str, boolean z) {
        this.zza = purchasesResponseListener;
        this.zzb = str;
        this.zzc = z;
        Objects.requireNonNull(billingClientImpl);
        this.zzd = billingClientImpl;
    }

    @Override
    public final Object call() throws Exception {
        BillingClientImpl billingClientImpl = this.zzd;
        if (!billingClientImpl.zzbl(30000L)) {
            zzjd zzjdVar = zzjd.zzb;
            BillingResult billingResult = zzdc.zzj;
            billingClientImpl.zzbs(zzjdVar, 9, billingResult);
            this.zza.onQueryPurchasesResponse(billingResult, com.google.android.gms.internal.play_billing.zzbw.zzk());
            return null;
        }
        String str = this.zzb;
        if (TextUtils.isEmpty(str)) {
            com.google.android.gms.internal.play_billing.zzc.zzo("BillingClient", "Please provide a valid product type.");
            zzjd zzjdVar2 = zzjd.zzX;
            BillingResult billingResult2 = zzdc.zze;
            billingClientImpl.zzbs(zzjdVar2, 9, billingResult2);
            this.zza.onQueryPurchasesResponse(billingResult2, com.google.android.gms.internal.play_billing.zzbw.zzk());
            return null;
        }
        zzdz zzdzVarZzbq = billingClientImpl.zzbq(str, this.zzc, 9);
        if (zzdzVarZzbq.zzb() != null) {
            this.zza.onQueryPurchasesResponse(zzdzVarZzbq.zza(), zzdzVarZzbq.zzb());
            return null;
        }
        this.zza.onQueryPurchasesResponse(zzdzVarZzbq.zza(), com.google.android.gms.internal.play_billing.zzbw.zzk());
        return null;
    }
}
