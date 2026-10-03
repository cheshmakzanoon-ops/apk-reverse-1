package net.aihelp.p007ui;

import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Window;
import android.webkit.JavascriptInterface;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import java.lang.ref.WeakReference;
import net.aihelp.common.Const;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.BaseActivity;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.request.animation.GlideAnimation;
import net.aihelp.core.p004ui.glide.request.target.SimpleTarget;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.core.util.permission.AIHelpPermissions;
import net.aihelp.data.event.OrientationChangeEvent;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;
import okhttp3.internal.http2.Http2Connection;

public class HostActivity extends BaseActivity {
    private static WeakReference<Window> sPhoneWindow;
    FragmentManager fragmentManager;

    private void watchLeakCanary() {
    }

    public static Window getHostWindow() {
        WeakReference<Window> weakReference = sPhoneWindow;
        if (weakReference == null || weakReference.get() == null) {
            return null;
        }
        return sPhoneWindow.get();
    }

    @Override
    public int getLayoutId() {
        return ResResolver.getLayoutId("aihelp_act_host");
    }

    @Override
    protected void onCreate(Bundle bundle) {
        watchLeakCanary();
        if (Const.sSessionOpenListener != null) {
            Const.sSessionOpenListener.onAIHelpSessionOpened();
        }
        sPhoneWindow = new WeakReference<>(getWindow());
        Const.IS_SDK_SHOWING = true;
        getWindow().setFlags(Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE, Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE);
        int i = CustomConfig.CommonSetting.screenOrientation;
        if (i == 1) {
            CustomConfig.CommonSetting.isLandscape = true;
            setRequestedOrientation(6);
        } else if (i == 2) {
            CustomConfig.CommonSetting.isLandscape = false;
            setRequestedOrientation(1);
        } else if (i == 3) {
            CustomConfig.CommonSetting.isLandscape = getResources().getConfiguration().orientation == 2;
            setRequestedOrientation(-1);
        }
        if (CustomConfig.CommonSetting.isBackgroundRenderedWithImage) {
            updateWindowBackgroundImage();
        } else {
            getWindow().setBackgroundDrawable(new ColorDrawable(Styles.getColor(CustomConfig.CommonSetting.backgroundColorForAll)));
        }
        getWindow().clearFlags(67108864);
        getWindow().addFlags(Integer.MIN_VALUE);
        getWindow().setStatusBarColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.navigationBarBackground, CustomConfig.CommonSetting.navigationBarAlpha));
        getWindow().getDecorView().setSystemUiVisibility(Styles.isLightColor(Color.parseColor(CustomConfig.CommonSetting.textColor)) ? 0 : 8192);
        super.onCreate(bundle);
    }

    @Override
    public void onConfigurationChanged(Configuration configuration) {
        super.onConfigurationChanged(configuration);
        if (CustomConfig.CommonSetting.screenOrientation == 3) {
            CustomConfig.CommonSetting.isLandscape = configuration.orientation == 2;
            EventBus.getDefault().post(new OrientationChangeEvent(Integer.valueOf(configuration.orientation)));
            if (CustomConfig.CommonSetting.isBackgroundRenderedWithImage) {
                updateWindowBackgroundImage();
            }
        }
    }

    private void updateWindowBackgroundImage() {
        String str;
        if (Styles.isLandscape()) {
            str = CustomConfig.CommonSetting.backgroundImageForLandscape;
        } else {
            str = CustomConfig.CommonSetting.backgroundImageForPortrait;
        }
        if (TextUtils.isEmpty(str)) {
            return;
        }
        Glide.with(getApplicationContext()).load(str).asBitmap().into(new SimpleTarget<Bitmap>() {
            @Override
            public void onResourceReady(Object obj, GlideAnimation glideAnimation) {
                onResourceReady((Bitmap) obj, (GlideAnimation<? super Bitmap>) glideAnimation);
            }

            public void onResourceReady(Bitmap bitmap, GlideAnimation<? super Bitmap> glideAnimation) {
                HostActivity.this.getWindow().setBackgroundDrawable(new BitmapDrawable(HostActivity.this.getResources(), bitmap));
            }
        });
    }

    @Override
    public void initView() {
        this.fragmentManager = getSupportFragmentManager();
        Bundle extras = getIntent().getExtras();
        if (extras == null) {
            extras = new Bundle();
        }
        FragmentTransaction fragmentTransactionBeginTransaction = this.fragmentManager.beginTransaction();
        fragmentTransactionBeginTransaction.add(ResResolver.getViewId("aihelp_root_container"), SupportFragment.getInstance(extras));
        fragmentTransactionBeginTransaction.commit();
    }

    @JavascriptInterface
    public void finishFormPage() {
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                HostActivity.this.onBackPressed();
            }
        });
    }

    public void onBackPressed() {
        for (Fragment fragment : this.fragmentManager.getFragments()) {
            if (fragment != null && fragment.isVisible() && (fragment instanceof SupportFragment)) {
                if (!((SupportFragment) fragment).onBackPressed()) {
                    return;
                }
                FragmentManager childFragmentManager = fragment.getChildFragmentManager();
                if (childFragmentManager.getBackStackEntryCount() > 0) {
                    childFragmentManager.popBackStack();
                    return;
                }
            }
        }
        super.onBackPressed();
    }

    protected void onActivityResult(int i, int i2, Intent intent) {
        super.onActivityResult(i, i2, intent);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Const.IS_SDK_SHOWING = false;
        if (Const.sSessionCloseListener != null) {
            Const.sSessionCloseListener.onAIHelpSessionClosed();
        }
        AIHelpEventTracker.getInstance().calculateDurationInAIHelp();
        AIHelpPermissions.getInstance().recycle();
        sPhoneWindow = null;
    }
}
