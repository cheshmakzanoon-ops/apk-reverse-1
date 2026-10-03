package com.android.billingclient.api;

import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import android.os.ResultReceiver;
import androidx.activity.ComponentActivity;
import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.IntentSenderRequest;
import androidx.activity.result.contract.ActivityResultContracts;
import com.google.android.gms.internal.play_billing.zzjd;

public class ProxyBillingActivityV2 extends ComponentActivity {
    private ActivityResultLauncher zza;
    private ActivityResultLauncher zzb;
    private ActivityResultLauncher zzc;
    private ActivityResultLauncher zzd;
    private ResultReceiver zze;
    private ResultReceiver zzf;
    private ResultReceiver zzg;
    private ResultReceiver zzh;

    protected final void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        this.zza = registerForActivityResult(new ActivityResultContracts.StartIntentSenderForResult(), new ActivityResultCallback() {
            public final void onActivityResult(Object obj) {
                this.zza.zza((ActivityResult) obj);
            }
        });
        this.zzb = registerForActivityResult(new ActivityResultContracts.StartIntentSenderForResult(), new ActivityResultCallback() {
            public final void onActivityResult(Object obj) {
                this.zza.zzb((ActivityResult) obj);
            }
        });
        this.zzc = registerForActivityResult(new ActivityResultContracts.StartIntentSenderForResult(), new ActivityResultCallback() {
            public final void onActivityResult(Object obj) {
                this.zza.zzc((ActivityResult) obj);
            }
        });
        this.zzd = registerForActivityResult(new ActivityResultContracts.StartIntentSenderForResult(), new ActivityResultCallback() {
            public final void onActivityResult(Object obj) {
                this.zza.zzd((ActivityResult) obj);
            }
        });
        if (bundle != null) {
            if (bundle.containsKey("alternative_billing_only_dialog_result_receiver")) {
                this.zze = (ResultReceiver) bundle.getParcelable("alternative_billing_only_dialog_result_receiver");
            }
            if (bundle.containsKey("external_payment_dialog_result_receiver")) {
                this.zzf = (ResultReceiver) bundle.getParcelable("external_payment_dialog_result_receiver");
            }
            if (bundle.containsKey("external_offer_flow_result_receiver")) {
                this.zzg = (ResultReceiver) bundle.getParcelable("external_offer_flow_result_receiver");
            }
            if (bundle.containsKey("launch_external_link_result_receiver")) {
                this.zzh = (ResultReceiver) bundle.getParcelable("launch_external_link_result_receiver");
                return;
            }
            return;
        }
        com.google.android.gms.internal.play_billing.zzc.zzn("ProxyBillingActivityV2", "Launching Play Store billing dialog");
        if (getIntent().hasExtra("ALTERNATIVE_BILLING_ONLY_DIALOG_INTENT")) {
            PendingIntent pendingIntent = (PendingIntent) getIntent().getParcelableExtra("ALTERNATIVE_BILLING_ONLY_DIALOG_INTENT");
            this.zze = (ResultReceiver) getIntent().getParcelableExtra("alternative_billing_only_dialog_result_receiver");
            this.zza.launch(new IntentSenderRequest.Builder(pendingIntent).build());
            return;
        }
        if (getIntent().hasExtra("external_payment_dialog_pending_intent")) {
            PendingIntent pendingIntent2 = (PendingIntent) getIntent().getParcelableExtra("external_payment_dialog_pending_intent");
            this.zzf = (ResultReceiver) getIntent().getParcelableExtra("external_payment_dialog_result_receiver");
            this.zzb.launch(new IntentSenderRequest.Builder(pendingIntent2).build());
        } else if (getIntent().hasExtra("external_offer_flow_pending_intent")) {
            PendingIntent pendingIntent3 = (PendingIntent) getIntent().getParcelableExtra("external_offer_flow_pending_intent");
            this.zzg = (ResultReceiver) getIntent().getParcelableExtra("external_offer_flow_result_receiver");
            this.zzc.launch(new IntentSenderRequest.Builder(pendingIntent3).build());
        } else if (getIntent().hasExtra("launch_external_link_flow_pending_intent")) {
            PendingIntent pendingIntent4 = (PendingIntent) getIntent().getParcelableExtra("launch_external_link_flow_pending_intent");
            this.zzh = (ResultReceiver) getIntent().getParcelableExtra("launch_external_link_result_receiver");
            this.zzd.launch(new IntentSenderRequest.Builder(pendingIntent4).build());
        }
    }

    protected final void onSaveInstanceState(Bundle bundle) {
        super.onSaveInstanceState(bundle);
        ResultReceiver resultReceiver = this.zze;
        if (resultReceiver != null) {
            bundle.putParcelable("alternative_billing_only_dialog_result_receiver", resultReceiver);
        }
        ResultReceiver resultReceiver2 = this.zzf;
        if (resultReceiver2 != null) {
            bundle.putParcelable("external_payment_dialog_result_receiver", resultReceiver2);
        }
        ResultReceiver resultReceiver3 = this.zzg;
        if (resultReceiver3 != null) {
            bundle.putParcelable("external_offer_flow_result_receiver", resultReceiver3);
        }
        ResultReceiver resultReceiver4 = this.zzh;
        if (resultReceiver4 != null) {
            bundle.putParcelable("launch_external_link_result_receiver", resultReceiver4);
        }
    }

    final void zza(ActivityResult activityResult) {
        Intent data = activityResult.getData();
        int responseCode = com.google.android.gms.internal.play_billing.zzc.zzi(data, "ProxyBillingActivityV2").getResponseCode();
        ResultReceiver resultReceiver = this.zze;
        if (resultReceiver != null) {
            resultReceiver.send(responseCode, data == null ? null : data.getExtras());
        }
        if (activityResult.getResultCode() != -1 || responseCode != 0) {
            com.google.android.gms.internal.play_billing.zzc.zzo("ProxyBillingActivityV2", "Alternative billing only dialog finished with resultCode " + activityResult.getResultCode() + " and billing's responseCode: " + responseCode);
        }
        finish();
    }

    final void zzb(ActivityResult activityResult) {
        Intent data = activityResult.getData();
        int responseCode = com.google.android.gms.internal.play_billing.zzc.zzi(data, "ProxyBillingActivityV2").getResponseCode();
        ResultReceiver resultReceiver = this.zzf;
        if (resultReceiver != null) {
            resultReceiver.send(responseCode, data == null ? null : data.getExtras());
        }
        if (activityResult.getResultCode() != -1 || responseCode != 0) {
            com.google.android.gms.internal.play_billing.zzc.zzo("ProxyBillingActivityV2", String.format("External offer dialog finished with resultCode: %s and billing's responseCode: %s", Integer.valueOf(activityResult.getResultCode()), Integer.valueOf(responseCode)));
        }
        finish();
    }

    final void zzc(ActivityResult activityResult) {
        Intent data = activityResult.getData();
        Bundle extras = data == null ? null : data.getExtras();
        if (activityResult.getResultCode() != -1) {
            if (extras == null) {
                extras = new Bundle();
            }
            com.google.android.gms.internal.play_billing.zzc.zzo("ProxyBillingActivityV2", String.format("External offer flow finished with resultCode: %s", Integer.valueOf(activityResult.getResultCode())));
            extras.putInt("INTERNAL_LOG_ERROR_REASON", zzjd.zzbv.zza());
            extras.putString("INTERNAL_LOG_ERROR_ADDITIONAL_DETAILS", String.format("External offer flow finished with error resultCode: %s", Integer.valueOf(activityResult.getResultCode())));
        }
        int responseCode = com.google.android.gms.internal.play_billing.zzc.zzi(data, "ProxyBillingActivityV2").getResponseCode();
        ResultReceiver resultReceiver = this.zzg;
        if (resultReceiver != null) {
            resultReceiver.send(responseCode, extras);
        } else {
            com.google.android.gms.internal.play_billing.zzc.zzo("ProxyBillingActivityV2", "External offer flow result receiver is null");
        }
        if (responseCode != 0) {
            com.google.android.gms.internal.play_billing.zzc.zzo("ProxyBillingActivityV2", String.format("External offer flow finished with billing responseCode: %s", Integer.valueOf(responseCode)));
        }
        finish();
    }

    final void zzd(ActivityResult activityResult) {
        Intent data = activityResult.getData();
        Bundle extras = data == null ? null : data.getExtras();
        if (activityResult.getResultCode() != -1) {
            if (extras == null) {
                extras = new Bundle();
            }
            com.google.android.gms.internal.play_billing.zzc.zzo("ProxyBillingActivityV2", String.format("Launch external link flow finished with resultCode: %s", Integer.valueOf(activityResult.getResultCode())));
            extras.putInt("INTERNAL_LOG_ERROR_REASON", zzjd.zzbv.zza());
            extras.putString("INTERNAL_LOG_ERROR_ADDITIONAL_DETAILS", String.format("Launch external link flow finished with error resultCode: %s", Integer.valueOf(activityResult.getResultCode())));
        }
        int responseCode = com.google.android.gms.internal.play_billing.zzc.zzi(data, "ProxyBillingActivityV2").getResponseCode();
        ResultReceiver resultReceiver = this.zzh;
        if (resultReceiver != null) {
            resultReceiver.send(responseCode, extras);
        } else {
            com.google.android.gms.internal.play_billing.zzc.zzo("ProxyBillingActivityV2", "Launch external link flow result receiver is null");
        }
        if (responseCode != 0) {
            com.google.android.gms.internal.play_billing.zzc.zzo("ProxyBillingActivityV2", String.format("Launch external link flow finished with billing responseCode: %s", Integer.valueOf(responseCode)));
        }
        finish();
    }
}
