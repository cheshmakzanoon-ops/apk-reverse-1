package net.aihelp.core.p004ui;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.KeyEvent;
import androidx.appcompat.app.AppCompatActivity;
import java.lang.reflect.Method;
import net.aihelp.common.Const;
import net.aihelp.config.AIHelpContext;
import net.aihelp.core.net.monitor.NetworkMonitorManager;
import net.aihelp.core.net.monitor.NetworkState;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.ToastUtil;

public abstract class BaseActivity extends AppCompatActivity {
    protected Context mContext;

    public abstract int getLayoutId();

    public void initView() {
    }

    public boolean isApplyPendingTransition() {
        return false;
    }

    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        this.mContext = getBaseContext();
        if (bundle != null) {
            Intent launchIntent = AppInfoUtil.getLaunchIntent(getApplicationContext(), getPackageName());
            if (launchIntent != null) {
                finish();
                startActivity(launchIntent);
                return;
            }
            return;
        }
        setContentView(getLayoutId());
        initView();
        if (isApplyPendingTransition()) {
            overridePendingTransition(ResResolver.getAnimId("aihelp_right_in"), ResResolver.getAnimId("aihelp_exit_trans"));
        }
        NetworkMonitorManager.getInstance().register(this);
        ActivityManager.INSTANCE.register(this);
    }

    public void finish() {
        super.finish();
        if (isApplyPendingTransition()) {
            overridePendingTransition(0, ResResolver.getAnimId("aihelp_right_out"));
        }
    }

    public void onConfigurationChanged(Configuration configuration) {
        try {
            Method declaredMethod = Class.forName("com.google.android.play.core.splitcompat.SplitCompat").getDeclaredMethod("installActivity", Context.class);
            declaredMethod.setAccessible(true);
            declaredMethod.invoke(null, getBaseContext());
        } catch (Exception unused) {
        }
        if (configuration.fontScale != 1.0f) {
            getResources();
        }
        super.onConfigurationChanged(configuration);
        getResources().updateConfiguration(configuration, getResources().getDisplayMetrics());
    }

    public Resources getResources() {
        Resources resources = super.getResources();
        if ("SHARP".equals(Build.MANUFACTURER)) {
            DisplayMetrics displayMetrics = resources.getDisplayMetrics();
            displayMetrics.density = 2.625f;
            displayMetrics.scaledDensity = 2.625f;
        } else if (resources.getConfiguration().fontScale != 1.0f) {
            Configuration configuration = new Configuration();
            configuration.setToDefaults();
            resources.updateConfiguration(configuration, resources.getDisplayMetrics());
        }
        return resources;
    }

    protected void onDestroy() {
        super.onDestroy();
        AIHelpContext.getInstance().setContext(getApplicationContext());
        NetworkMonitorManager.getInstance().unregister(this);
        ActivityManager.INSTANCE.unregister(this);
    }

    public void onNetworkStateChanged(NetworkState networkState) {
        if (networkState == NetworkState.NONE) {
            ToastUtil.INSTANCE.makeRawToast(this.mContext, ResResolver.getString("aihelp_network_no_connect"));
        }
        EventBus.getDefault().post(networkState);
    }

    protected void attachBaseContext(Context context) {
        Context localeUpdatedContext = AIHelpContext.getLocaleUpdatedContext(context, Const.CORRECT_LANGUAGE);
        AIHelpContext.getInstance().setContext(localeUpdatedContext);
        try {
            Method declaredMethod = Class.forName("com.google.android.play.core.splitcompat.SplitCompat").getDeclaredMethod("installActivity", Context.class);
            declaredMethod.setAccessible(true);
            declaredMethod.invoke(null, localeUpdatedContext);
        } catch (Exception unused) {
        }
        super.attachBaseContext(localeUpdatedContext);
    }

    public boolean onKeyDown(int i, KeyEvent keyEvent) {
        if (i != 4 || Const.isNestedFragmentOnResume) {
            return super.onKeyDown(i, keyEvent);
        }
        return false;
    }
}
