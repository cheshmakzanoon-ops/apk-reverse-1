package com.android.billingclient.api;

import android.os.Bundle;
import android.os.Handler;
import com.google.android.gms.internal.play_billing.zzjd;
import java.util.concurrent.ExecutorService;

final class CreateBillingProgramReportingDetailsDelegateToBackendCallback extends com.google.android.gms.internal.play_billing.zzab {
    private static final String DELEGATE_TO_BACKEND_RESPONSE_DATA_KEY = "RESPONSE_DATA";
    private static final String TAG = "CreateBillingProgramReportingDetailsDelegateToBackendCallback";
    final int billingApiVersion;
    final zzcz billingLogger;
    final int billingProgram;
    final ExecutorService executorService;
    final Handler handler;
    final BillingProgramReportingDetailsListener listener;

    CreateBillingProgramReportingDetailsDelegateToBackendCallback(BillingProgramReportingDetailsListener billingProgramReportingDetailsListener, int i, zzcz zzczVar, int i2, Handler handler, ExecutorService executorService) {
        billingProgramReportingDetailsListener.getClass();
        this.listener = billingProgramReportingDetailsListener;
        this.billingProgram = i;
        this.billingLogger = zzczVar;
        this.billingApiVersion = i2;
        this.handler = handler;
        this.executorService = executorService;
    }

    private BillingProgramReportingDetails parseReportingDetails(Bundle bundle) throws Exception {
        byte[] byteArray = bundle.getByteArray(DELEGATE_TO_BACKEND_RESPONSE_DATA_KEY);
        if (byteArray != null) {
            return new BillingProgramReportingDetails(com.google.android.gms.internal.play_billing.zzdm.zzb(byteArray).zzc().zzc(), this.billingProgram);
        }
        throw new Exception("Response data is null");
    }

    private void returnListenerResponseOnSuccess(BillingResult billingResult, Bundle bundle) {
        try {
            this.listener.onCreateBillingProgramReportingDetailsResponse(billingResult, parseReportingDetails(bundle));
        } catch (Exception e) {
            com.google.android.gms.internal.play_billing.zzc.zzo(TAG, "Got a JSON exception trying to decode billing program reporting details.");
            zzcz zzczVar = this.billingLogger;
            zzjd zzjdVar = zzjd.zzaS;
            BillingResult billingResult2 = zzdc.zzh;
            zzde.zzb(zzjdVar, billingResult2, zzczVar, zzdf.CREATE_BILLING_PROGRAM_REPORTING_DETAILS_ASYNC.zzb(), this.billingApiVersion, zzcy.zza(e));
            this.listener.onCreateBillingProgramReportingDetailsResponse(billingResult2, null);
        }
    }

    public void onDelegateToBackendResponse(Bundle bundle) {
        if (bundle == null) {
            zzcz zzczVar = this.billingLogger;
            zzjd zzjdVar = zzjd.zzaT;
            BillingResult billingResult = zzdc.zzh;
            zzde.zza(zzjdVar, billingResult, zzczVar, zzdf.CREATE_BILLING_PROGRAM_REPORTING_DETAILS_ASYNC.zzb(), this.billingApiVersion);
            this.listener.onCreateBillingProgramReportingDetailsResponse(billingResult, null);
            return;
        }
        zzdf zzdfVar = zzdf.CREATE_BILLING_PROGRAM_REPORTING_DETAILS_ASYNC;
        BillingResult billingResultZza = zzdh.zza(bundle, TAG, zzdfVar.zzb(), this.billingLogger, this.billingApiVersion);
        BillingProgramReportingDetailsListener billingProgramReportingDetailsListener = this.listener;
        if (billingProgramReportingDetailsListener == null) {
            zzde.zza(zzjd.zzaR, billingResultZza, this.billingLogger, zzdfVar.zzb(), this.billingApiVersion);
        } else if (billingResultZza.getResponseCode() != 0) {
            billingProgramReportingDetailsListener.onCreateBillingProgramReportingDetailsResponse(billingResultZza, null);
        } else {
            returnListenerResponseOnSuccess(billingResultZza, bundle);
        }
    }
}
