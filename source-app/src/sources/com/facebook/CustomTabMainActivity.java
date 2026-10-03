package com.facebook;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.Bundle;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.internal.CustomTab;
import com.facebook.internal.InstagramCustomTab;
import com.facebook.internal.NativeProtocol;
import com.facebook.internal.Utility;
import com.facebook.login.LoginTargetApp;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0003\u0018\u0000 \u00132\u00020\u0001:\u0001\u0013B\u0005¢\u0006\u0002\u0010\u0002J\u0012\u0010\u0007\u001a\u00020\b2\b\u0010\t\u001a\u0004\u0018\u00010\nH\u0014J\u0010\u0010\u000b\u001a\u00020\b2\u0006\u0010\f\u001a\u00020\rH\u0014J\b\u0010\u000e\u001a\u00020\bH\u0014J\u001a\u0010\u000f\u001a\u00020\b2\u0006\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\rH\u0002R\u0010\u0010\u0003\u001a\u0004\u0018\u00010\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0014"}, d2 = {"Lcom/facebook/CustomTabMainActivity;", "Landroid/app/Activity;", "()V", "redirectReceiver", "Landroid/content/BroadcastReceiver;", "shouldCloseCustomTab", "", "onCreate", "", "savedInstanceState", "Landroid/os/Bundle;", "onNewIntent", SDKConstants.PARAM_INTENT, "Landroid/content/Intent;", "onResume", "sendResult", "resultCode", "", "resultIntent", "Companion", "facebook-common_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class CustomTabMainActivity extends Activity {
    private BroadcastReceiver redirectReceiver;
    private boolean shouldCloseCustomTab = true;

    public static final Companion INSTANCE = new Companion(null);
    public static final String EXTRA_ACTION = Intrinsics.stringPlus("CustomTabMainActivity", ".extra_action");
    public static final String EXTRA_PARAMS = Intrinsics.stringPlus("CustomTabMainActivity", ".extra_params");
    public static final String EXTRA_CHROME_PACKAGE = Intrinsics.stringPlus("CustomTabMainActivity", ".extra_chromePackage");
    public static final String EXTRA_URL = Intrinsics.stringPlus("CustomTabMainActivity", ".extra_url");
    public static final String EXTRA_TARGET_APP = Intrinsics.stringPlus("CustomTabMainActivity", ".extra_targetApp");
    public static final String REFRESH_ACTION = Intrinsics.stringPlus("CustomTabMainActivity", ".action_refresh");
    public static final String NO_ACTIVITY_EXCEPTION = Intrinsics.stringPlus("CustomTabMainActivity", ".no_activity_exception");

    @Metadata(k = 3, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[LoginTargetApp.valuesCustom().length];
            iArr[LoginTargetApp.INSTAGRAM.ordinal()] = 1;
            $EnumSwitchMapping$0 = iArr;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        String stringExtra;
        InstagramCustomTab customTab;
        super.onCreate(savedInstanceState);
        if (Intrinsics.areEqual(CustomTabActivity.CUSTOM_TAB_REDIRECT_ACTION, getIntent().getAction())) {
            setResult(0);
            finish();
            return;
        }
        if (savedInstanceState != null || (stringExtra = getIntent().getStringExtra(EXTRA_ACTION)) == null) {
            return;
        }
        Bundle bundleExtra = getIntent().getBundleExtra(EXTRA_PARAMS);
        String stringExtra2 = getIntent().getStringExtra(EXTRA_CHROME_PACKAGE);
        if (WhenMappings.$EnumSwitchMapping$0[LoginTargetApp.INSTANCE.fromString(getIntent().getStringExtra(EXTRA_TARGET_APP)).ordinal()] == 1) {
            customTab = new InstagramCustomTab(stringExtra, bundleExtra);
        } else {
            customTab = new CustomTab(stringExtra, bundleExtra);
        }
        boolean zOpenCustomTab = customTab.openCustomTab(this, stringExtra2);
        this.shouldCloseCustomTab = false;
        if (!zOpenCustomTab) {
            setResult(0, getIntent().putExtra(NO_ACTIVITY_EXCEPTION, true));
            finish();
        } else {
            BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
                @Override
                public void onReceive(Context context, Intent intent) {
                    Intrinsics.checkNotNullParameter(context, "context");
                    Intrinsics.checkNotNullParameter(intent, SDKConstants.PARAM_INTENT);
                    Intent intent2 = new Intent(this.this$0, (Class<?>) CustomTabMainActivity.class);
                    intent2.setAction(CustomTabMainActivity.REFRESH_ACTION);
                    intent2.putExtra(CustomTabMainActivity.EXTRA_URL, intent.getStringExtra(CustomTabMainActivity.EXTRA_URL));
                    intent2.addFlags(603979776);
                    this.this$0.startActivity(intent2);
                }
            };
            this.redirectReceiver = broadcastReceiver;
            LocalBroadcastManager.getInstance(this).registerReceiver(broadcastReceiver, new IntentFilter(CustomTabActivity.CUSTOM_TAB_REDIRECT_ACTION));
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        Intrinsics.checkNotNullParameter(intent, SDKConstants.PARAM_INTENT);
        super.onNewIntent(intent);
        if (Intrinsics.areEqual(REFRESH_ACTION, intent.getAction())) {
            LocalBroadcastManager.getInstance(this).sendBroadcast(new Intent(CustomTabActivity.DESTROY_ACTION));
            sendResult(-1, intent);
        } else if (Intrinsics.areEqual(CustomTabActivity.CUSTOM_TAB_REDIRECT_ACTION, intent.getAction())) {
            sendResult(-1, intent);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (this.shouldCloseCustomTab) {
            sendResult(0, null);
        }
        this.shouldCloseCustomTab = true;
    }

    private final void sendResult(int resultCode, Intent resultIntent) {
        BroadcastReceiver broadcastReceiver = this.redirectReceiver;
        if (broadcastReceiver != null) {
            LocalBroadcastManager.getInstance(this).unregisterReceiver(broadcastReceiver);
        }
        if (resultIntent != null) {
            String stringExtra = resultIntent.getStringExtra(EXTRA_URL);
            Bundle responseUri = stringExtra != null ? INSTANCE.parseResponseUri(stringExtra) : new Bundle();
            NativeProtocol nativeProtocol = NativeProtocol.INSTANCE;
            Intent intent = getIntent();
            Intrinsics.checkNotNullExpressionValue(intent, SDKConstants.PARAM_INTENT);
            Intent intentCreateProtocolResultIntent = NativeProtocol.createProtocolResultIntent(intent, responseUri, null);
            if (intentCreateProtocolResultIntent != null) {
                resultIntent = intentCreateProtocolResultIntent;
            }
            setResult(resultCode, resultIntent);
        } else {
            NativeProtocol nativeProtocol2 = NativeProtocol.INSTANCE;
            Intent intent2 = getIntent();
            Intrinsics.checkNotNullExpressionValue(intent2, SDKConstants.PARAM_INTENT);
            setResult(resultCode, NativeProtocol.createProtocolResultIntent(intent2, null, null));
        }
        finish();
    }

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u0004H\u0002R\u0010\u0010\u0003\u001a\u00020\u00048\u0006X\u0087\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0005\u001a\u00020\u00048\u0006X\u0087\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0006\u001a\u00020\u00048\u0006X\u0087\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0007\u001a\u00020\u00048\u0006X\u0087\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\b\u001a\u00020\u00048\u0006X\u0087\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\t\u001a\u00020\u00048\u0006X\u0087\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\n\u001a\u00020\u00048\u0006X\u0087\u0004¢\u0006\u0002\n\u0000¨\u0006\u000e"}, d2 = {"Lcom/facebook/CustomTabMainActivity$Companion;", "", "()V", "EXTRA_ACTION", "", "EXTRA_CHROME_PACKAGE", "EXTRA_PARAMS", "EXTRA_TARGET_APP", "EXTRA_URL", "NO_ACTIVITY_EXCEPTION", "REFRESH_ACTION", "parseResponseUri", "Landroid/os/Bundle;", "urlString", "facebook-common_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final Bundle parseResponseUri(String urlString) {
            Uri uri = Uri.parse(urlString);
            Utility utility = Utility.INSTANCE;
            Bundle urlQueryString = Utility.parseUrlQueryString(uri.getQuery());
            Utility utility2 = Utility.INSTANCE;
            urlQueryString.putAll(Utility.parseUrlQueryString(uri.getFragment()));
            return urlQueryString;
        }
    }
}
