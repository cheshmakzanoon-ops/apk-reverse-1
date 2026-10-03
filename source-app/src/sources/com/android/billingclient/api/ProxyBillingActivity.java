package com.android.billingclient.api;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.IntentSender;
import android.os.Bundle;
import android.os.ResultReceiver;
import androidx.core.content.ContextCompat;
import com.google.android.gms.internal.play_billing.zzjd;
import com.google.android.gms.internal.play_billing.zzjk;

public class ProxyBillingActivity extends Activity {
    static final String EXTERNAL_BROADCAST_PERMISSION = "com.google.android.finsky.permission.PLAY_BILLING_LIBRARY_BROADCAST";
    private static final String KEY_ACTIVITY_CODE = "activity_code";
    static final String KEY_IN_APP_MESSAGE_RESULT_RECEIVER = "in_app_message_result_receiver";
    private static final String KEY_SEND_CANCELLED_BROADCAST_IF_FINISHED = "send_cancelled_broadcast_if_finished";
    private static final int REQUEST_CODE_FIRST_PARTY_PURCHASE_FLOW = 110;
    private static final int REQUEST_CODE_IN_APP_MESSAGE_FLOW = 101;
    private static final int REQUEST_CODE_LAUNCH_ACTIVITY = 100;
    static final int RESULT_CODE_PLAY_CANCELED_WITH_ON_CREATE_RUNTIME_EXCEPTION = 5;
    static final int RESULT_CODE_PLAY_CANCELLED = 3;
    static final int RESULT_CODE_PLAY_CANCELLED_WITHOUT_COMPLETE_ACTION = 4;
    private static final String TAG = "ProxyBillingActivity";
    private static final zzei variantFlags = zzeg.zza;
    private int activityCode;
    private long billingClientTransactionId;
    private ResultReceiver inAppMessageResultReceiver;
    private boolean isFlowFromFirstPartyClient;
    zzdy proxyBillingBroadcastReceiver;
    private boolean sendCancelledBroadcastIfFinished;
    private boolean wasServiceAutoReconnected;

    private zzjd getLoggingErrorReason(int i, Intent intent) {
        if (intent != null) {
            if (intent.getExtras() == null) {
                return zzjd.zzv;
            }
            return i == 5 ? zzjd.zzbI : zzjd.zza;
        }
        if (i == -1) {
            return zzjd.zzbi;
        }
        if (i == 0) {
            return zzjd.zzbj;
        }
        if (i != 3) {
            return i != 4 ? zzjd.zzbm : zzjd.zzbl;
        }
        return zzjd.zzbk;
    }

    private boolean isKnownError(int i, Intent intent) {
        return !getLoggingErrorReason(i, intent).equals(zzjd.zza);
    }

    private boolean isProxyBillingBroadcastReceiverRegistered() {
        return false;
    }

    private Intent makeAlternativeBillingIntent(String str) {
        Intent intent = new Intent("com.android.vending.billing.ALTERNATIVE_BILLING");
        intent.setPackage(getApplicationContext().getPackageName());
        intent.putExtra("ALTERNATIVE_BILLING_USER_CHOICE_DATA", str);
        return intent;
    }

    private Intent makePurchaseUpdatedIntentWithInternalErrorReason(zzjd zzjdVar, long j, boolean z) {
        Intent intentMakePurchasesUpdatedIntent = makePurchasesUpdatedIntent();
        intentMakePurchasesUpdatedIntent.putExtra("RESPONSE_CODE", 6);
        intentMakePurchasesUpdatedIntent.putExtra("DEBUG_MESSAGE", "An internal error occurred.");
        BillingResult.Builder builderNewBuilder = BillingResult.newBuilder();
        builderNewBuilder.setResponseCode(6);
        builderNewBuilder.setDebugMessage("An internal error occurred.");
        BillingResult billingResultBuild = builderNewBuilder.build();
        int i = zzcy.zza;
        intentMakePurchasesUpdatedIntent.putExtra("FAILURE_LOGGING_PAYLOAD", zzcy.zzb(zzjdVar, 2, billingResultBuild, null, zzjk.zza).zzQ());
        intentMakePurchasesUpdatedIntent.putExtra("INTENT_SOURCE", "LAUNCH_BILLING_FLOW");
        intentMakePurchasesUpdatedIntent.putExtra("billingClientTransactionId", j);
        intentMakePurchasesUpdatedIntent.putExtra("wasServiceAutoReconnected", this.wasServiceAutoReconnected);
        return intentMakePurchasesUpdatedIntent;
    }

    private Intent makePurchasesUpdatedIntent() {
        Intent intent = new Intent("com.android.vending.billing.LOCAL_BROADCAST_PURCHASES_UPDATED");
        intent.setPackage(getApplicationContext().getPackageName());
        return intent;
    }

    private synchronized void registerProxyBillingBroadcastReceiver() {
        try {
            this.proxyBillingBroadcastReceiver = new zzdy();
            ContextCompat.registerReceiver(this, this.proxyBillingBroadcastReceiver, new IntentFilter("com.android.vending.billing.IN_APP_BILLING_RESULT_UPDATE_ACTION"), EXTERNAL_BROADCAST_PERMISSION, null, 2);
        } catch (RuntimeException e) {
            com.google.android.gms.internal.play_billing.zzc.zzp(TAG, "Failed to register receiver.", e);
        }
    }

    @Override
    protected void onActivityResult(int i, int i2, Intent intent) {
        boolean z;
        int responseCode;
        int i3;
        String string;
        Intent intentMakePurchasesUpdatedIntent;
        boolean z2;
        super.onActivityResult(i, i2, intent);
        if (i == 100) {
            if (intent == null) {
                z = false;
            } else {
                z = true;
            }
            responseCode = com.google.android.gms.internal.play_billing.zzc.zzi(intent, TAG).getResponseCode();
            i3 = -1;
            if (i2 != -1) {
                com.google.android.gms.internal.play_billing.zzc.zzo(TAG, "Activity finished with resultCode " + i2 + " and billing's responseCode: " + responseCode);
                i3 = i2;
            } else if (responseCode != 0) {
                i2 = -1;
                com.google.android.gms.internal.play_billing.zzc.zzo(TAG, "Activity finished with resultCode " + i2 + " and billing's responseCode: " + responseCode);
                i3 = i2;
            }
            if (true != z) {
                com.google.android.gms.internal.play_billing.zzc.zzo(TAG, "Got null data with resultCode " + i3 + "!");
            } else if (intent.getExtras() == null) {
                com.google.android.gms.internal.play_billing.zzc.zzo(TAG, "Got null bundle!");
            }
            if (isKnownError(i3, intent)) {
                zzjd loggingErrorReason = getLoggingErrorReason(i3, intent);
                long j = this.billingClientTransactionId;
                if (intent == null) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                intentMakePurchasesUpdatedIntent = makePurchaseUpdatedIntentWithInternalErrorReason(loggingErrorReason, j, z2);
            } else {
                string = intent.getExtras().getString("ALTERNATIVE_BILLING_USER_CHOICE_DATA");
                if (string != null) {
                    intentMakePurchasesUpdatedIntent = makeAlternativeBillingIntent(string);
                    intentMakePurchasesUpdatedIntent.putExtra("INTENT_SOURCE", "LAUNCH_BILLING_FLOW");
                } else {
                    intentMakePurchasesUpdatedIntent = makePurchasesUpdatedIntent();
                    intentMakePurchasesUpdatedIntent.putExtras(intent.getExtras());
                    intentMakePurchasesUpdatedIntent.putExtra("INTENT_SOURCE", "LAUNCH_BILLING_FLOW");
                }
                intentMakePurchasesUpdatedIntent.putExtra("billingClientTransactionId", this.billingClientTransactionId);
                intentMakePurchasesUpdatedIntent.putExtra("wasServiceAutoReconnected", this.wasServiceAutoReconnected);
            }
            if (i == REQUEST_CODE_FIRST_PARTY_PURCHASE_FLOW) {
                intentMakePurchasesUpdatedIntent.putExtra("IS_FIRST_PARTY_PURCHASE", true);
            }
            sendBroadcast(intentMakePurchasesUpdatedIntent);
        } else if (i == REQUEST_CODE_FIRST_PARTY_PURCHASE_FLOW) {
            if (intent == null) {
                z = false;
            } else {
                z = true;
            }
            responseCode = com.google.android.gms.internal.play_billing.zzc.zzi(intent, TAG).getResponseCode();
            i3 = -1;
            if (i2 != -1) {
                com.google.android.gms.internal.play_billing.zzc.zzo(TAG, "Activity finished with resultCode " + i2 + " and billing's responseCode: " + responseCode);
                i3 = i2;
            } else if (responseCode != 0) {
                i2 = -1;
                com.google.android.gms.internal.play_billing.zzc.zzo(TAG, "Activity finished with resultCode " + i2 + " and billing's responseCode: " + responseCode);
                i3 = i2;
            }
            if (true != z) {
                com.google.android.gms.internal.play_billing.zzc.zzo(TAG, "Got null data with resultCode " + i3 + "!");
            } else if (intent.getExtras() == null) {
                com.google.android.gms.internal.play_billing.zzc.zzo(TAG, "Got null bundle!");
            }
            if (isKnownError(i3, intent)) {
                zzjd loggingErrorReason2 = getLoggingErrorReason(i3, intent);
                long j2 = this.billingClientTransactionId;
                if (intent == null) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                intentMakePurchasesUpdatedIntent = makePurchaseUpdatedIntentWithInternalErrorReason(loggingErrorReason2, j2, z2);
            } else {
                string = intent.getExtras().getString("ALTERNATIVE_BILLING_USER_CHOICE_DATA");
                if (string != null) {
                    intentMakePurchasesUpdatedIntent = makeAlternativeBillingIntent(string);
                    intentMakePurchasesUpdatedIntent.putExtra("INTENT_SOURCE", "LAUNCH_BILLING_FLOW");
                } else {
                    intentMakePurchasesUpdatedIntent = makePurchasesUpdatedIntent();
                    intentMakePurchasesUpdatedIntent.putExtras(intent.getExtras());
                    intentMakePurchasesUpdatedIntent.putExtra("INTENT_SOURCE", "LAUNCH_BILLING_FLOW");
                }
                intentMakePurchasesUpdatedIntent.putExtra("billingClientTransactionId", this.billingClientTransactionId);
                intentMakePurchasesUpdatedIntent.putExtra("wasServiceAutoReconnected", this.wasServiceAutoReconnected);
            }
            if (i == REQUEST_CODE_FIRST_PARTY_PURCHASE_FLOW) {
                intentMakePurchasesUpdatedIntent.putExtra("IS_FIRST_PARTY_PURCHASE", true);
            }
            sendBroadcast(intentMakePurchasesUpdatedIntent);
        } else if (i == 101) {
            int iZza = com.google.android.gms.internal.play_billing.zzc.zza(intent, TAG);
            ResultReceiver resultReceiver = this.inAppMessageResultReceiver;
            if (resultReceiver != null) {
                resultReceiver.send(iZza, intent == null ? null : intent.getExtras());
            }
        } else {
            com.google.android.gms.internal.play_billing.zzc.zzo(TAG, "Got onActivityResult with wrong requestCode: " + i + "; skipping...");
        }
        this.sendCancelledBroadcastIfFinished = false;
        finish();
    }

    @Override
    protected void onCreate(Bundle bundle) {
        PendingIntent pendingIntent;
        super.onCreate(bundle);
        if (bundle != null) {
            com.google.android.gms.internal.play_billing.zzc.zzn(TAG, "Launching Play Store billing flow from savedInstanceState");
            this.sendCancelledBroadcastIfFinished = bundle.getBoolean(KEY_SEND_CANCELLED_BROADCAST_IF_FINISHED, false);
            if (bundle.containsKey(KEY_IN_APP_MESSAGE_RESULT_RECEIVER)) {
                this.inAppMessageResultReceiver = (ResultReceiver) bundle.getParcelable(KEY_IN_APP_MESSAGE_RESULT_RECEIVER);
            }
            this.isFlowFromFirstPartyClient = bundle.getBoolean("IS_FLOW_FROM_FIRST_PARTY_CLIENT", false);
            this.activityCode = bundle.getInt(KEY_ACTIVITY_CODE, 100);
            if (bundle.containsKey("billingClientTransactionId")) {
                this.billingClientTransactionId = bundle.getLong("billingClientTransactionId");
            }
            if (bundle.containsKey("wasServiceAutoReconnected")) {
                this.wasServiceAutoReconnected = bundle.getBoolean("wasServiceAutoReconnected");
                return;
            }
            return;
        }
        com.google.android.gms.internal.play_billing.zzc.zzn(TAG, "Launching Play Store billing flow");
        this.activityCode = 100;
        if (getIntent().hasExtra("BUY_INTENT")) {
            pendingIntent = (PendingIntent) getIntent().getParcelableExtra("BUY_INTENT");
            if (getIntent().hasExtra("IS_FLOW_FROM_FIRST_PARTY_CLIENT") && getIntent().getBooleanExtra("IS_FLOW_FROM_FIRST_PARTY_CLIENT", false)) {
                this.isFlowFromFirstPartyClient = true;
                this.activityCode = REQUEST_CODE_FIRST_PARTY_PURCHASE_FLOW;
            }
        } else if (getIntent().hasExtra("IN_APP_MESSAGE_INTENT")) {
            pendingIntent = (PendingIntent) getIntent().getParcelableExtra("IN_APP_MESSAGE_INTENT");
            this.inAppMessageResultReceiver = (ResultReceiver) getIntent().getParcelableExtra(KEY_IN_APP_MESSAGE_RESULT_RECEIVER);
            this.activityCode = 101;
        } else {
            pendingIntent = null;
        }
        if (getIntent().hasExtra("billingClientTransactionId")) {
            this.billingClientTransactionId = getIntent().getLongExtra("billingClientTransactionId", 0L);
        }
        if (getIntent().hasExtra("wasServiceAutoReconnected")) {
            this.wasServiceAutoReconnected = getIntent().getBooleanExtra("wasServiceAutoReconnected", false);
        }
        try {
            this.sendCancelledBroadcastIfFinished = true;
            startIntentSenderForResult(pendingIntent.getIntentSender(), this.activityCode, new Intent(), 0, 0, 0);
        } catch (IntentSender.SendIntentException e) {
            com.google.android.gms.internal.play_billing.zzc.zzp(TAG, "Got exception while trying to start a purchase flow.", e);
            ResultReceiver resultReceiver = this.inAppMessageResultReceiver;
            if (resultReceiver != null) {
                resultReceiver.send(0, null);
            } else {
                Intent intentMakePurchaseUpdatedIntentWithInternalErrorReason = makePurchaseUpdatedIntentWithInternalErrorReason(zzjd.zzbG, this.billingClientTransactionId, false);
                if (this.isFlowFromFirstPartyClient) {
                    intentMakePurchaseUpdatedIntentWithInternalErrorReason.putExtra("IS_FIRST_PARTY_PURCHASE", true);
                }
                sendBroadcast(intentMakePurchaseUpdatedIntentWithInternalErrorReason);
            }
            this.sendCancelledBroadcastIfFinished = false;
            finish();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (isFinishing() && this.sendCancelledBroadcastIfFinished) {
            Intent intentMakePurchasesUpdatedIntent = makePurchasesUpdatedIntent();
            intentMakePurchasesUpdatedIntent.putExtra("RESPONSE_CODE", 1);
            intentMakePurchasesUpdatedIntent.putExtra("DEBUG_MESSAGE", "Billing dialog closed.");
            if (this.isFlowFromFirstPartyClient) {
                intentMakePurchasesUpdatedIntent.putExtra("IS_FIRST_PARTY_PURCHASE", true);
            }
            int i = this.activityCode;
            if (i == REQUEST_CODE_FIRST_PARTY_PURCHASE_FLOW || i == 100) {
                intentMakePurchasesUpdatedIntent.putExtra("INTENT_SOURCE", "LAUNCH_BILLING_FLOW");
                intentMakePurchasesUpdatedIntent.putExtra("billingClientTransactionId", this.billingClientTransactionId);
            }
            sendBroadcast(intentMakePurchasesUpdatedIntent);
        }
    }

    @Override
    protected void onSaveInstanceState(Bundle bundle) {
        super.onSaveInstanceState(bundle);
        ResultReceiver resultReceiver = this.inAppMessageResultReceiver;
        if (resultReceiver != null) {
            bundle.putParcelable(KEY_IN_APP_MESSAGE_RESULT_RECEIVER, resultReceiver);
        }
        bundle.putBoolean(KEY_SEND_CANCELLED_BROADCAST_IF_FINISHED, this.sendCancelledBroadcastIfFinished);
        bundle.putBoolean("IS_FLOW_FROM_FIRST_PARTY_CLIENT", this.isFlowFromFirstPartyClient);
        bundle.putInt(KEY_ACTIVITY_CODE, this.activityCode);
        bundle.putLong("billingClientTransactionId", this.billingClientTransactionId);
        bundle.putBoolean("wasServiceAutoReconnected", this.wasServiceAutoReconnected);
    }
}
