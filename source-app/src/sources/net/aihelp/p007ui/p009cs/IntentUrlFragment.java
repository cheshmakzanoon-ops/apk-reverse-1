package net.aihelp.p007ui.p009cs;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import net.aihelp.common.IntentValues;
import net.aihelp.core.p004ui.BaseFragment;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.permission.AIHelpPermissions;
import net.aihelp.core.util.permission.IPermissionCallback;
import net.aihelp.core.util.permission.Permission;
import net.aihelp.data.attachment.AttachmentHelper;
import net.aihelp.data.event.SupportActionEvent;
import net.aihelp.p007ui.webkit.AIHelpWebChromeClient;
import net.aihelp.p007ui.webkit.AIHelpWebProgress;
import net.aihelp.p007ui.webkit.AIHelpWebView;
import net.aihelp.p007ui.webkit.AIHelpWebViewClient;
import net.aihelp.utils.DomainSupportHelper;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.TLog;
import net.aihelp.utils.ToastUtil;

public class IntentUrlFragment extends BaseFragment {
    private AIHelpWebChromeClient mClient;
    private AIHelpWebView mWebView;

    public static IntentUrlFragment newInstance(Bundle bundle) {
        IntentUrlFragment intentUrlFragment = new IntentUrlFragment();
        intentUrlFragment.setArguments(bundle);
        return intentUrlFragment;
    }

    @Override
    protected void initEventAndData(View view) {
        AIHelpWebView aIHelpWebView;
        AIHelpWebProgress aIHelpWebProgress = (AIHelpWebProgress) get("aihelp_progress_bar");
        this.mClient = new AIHelpWebChromeClient(this, aIHelpWebProgress);
        AIHelpWebView aIHelpWebView2 = (AIHelpWebView) get("aihelp_web_view");
        this.mWebView = aIHelpWebView2;
        aIHelpWebView2.setBackgroundColor(0);
        this.mWebView.setWebViewClient(new AIHelpWebViewClient(getContext(), aIHelpWebProgress));
        this.mWebView.setWebChromeClient(this.mClient);
        if (getActivity() == null || (aIHelpWebView = this.mWebView) == null) {
            return;
        }
        aIHelpWebView.addJavascriptInterface(getActivity(), "android");
    }

    @Override
    protected void getBundleAfterDataPrepared(Bundle bundle) {
        String string = bundle.getString(IntentValues.INTENT_URL);
        AIHelpWebView aIHelpWebView = this.mWebView;
        if (aIHelpWebView != null) {
            aIHelpWebView.loadUrl(DomainSupportHelper.getAdjustedUrl(string));
        }
        TLog.m138d("Intent URL is " + DomainSupportHelper.getAdjustedUrl(string));
    }

    @Override
    public void onResume() {
        super.onResume();
        EventBus.getDefault().post(new SupportActionEvent(1002));
    }

    @Override
    protected int getLayout() {
        return ResResolver.getLayoutId("aihelp_fra_intent_url");
    }

    public void onActivityResult(int i, int i2, Intent intent) {
        super.onActivityResult(i, i2, intent);
        AIHelpWebChromeClient aIHelpWebChromeClient = this.mClient;
        if (aIHelpWebChromeClient != null) {
            aIHelpWebChromeClient.onActivityResult(i, i2, intent);
        }
    }

    public boolean onBackPressed() {
        AIHelpWebView aIHelpWebView = this.mWebView;
        if (aIHelpWebView == null || !aIHelpWebView.canGoBack()) {
            return true;
        }
        this.mWebView.goBack();
        return false;
    }

    static class C07373 {
        static final int[] $SwitchMap$net$aihelp$core$util$permission$Permission$Result;

        static {
            int[] iArr = new int[Permission.Result.values().length];
            $SwitchMap$net$aihelp$core$util$permission$Permission$Result = iArr;
            try {
                iArr[Permission.Result.GRANTED.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$net$aihelp$core$util$permission$Permission$Result[Permission.Result.NONE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                $SwitchMap$net$aihelp$core$util$permission$Permission$Result[Permission.Result.DENIED.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                $SwitchMap$net$aihelp$core$util$permission$Permission$Result[Permission.Result.RATIONAL.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                $SwitchMap$net$aihelp$core$util$permission$Permission$Result[Permission.Result.GO_SETTING.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
        }
    }

    @Permission(requestCode = 1001)
    public void onPermissionRequested(Permission.Result result, final IPermissionCallback iPermissionCallback, int i) {
        int i2 = C07373.$SwitchMap$net$aihelp$core$util$permission$Permission$Result[result.ordinal()];
        if (i2 == 1 || i2 == 2) {
            startActivityForResult(AttachmentHelper.getIntentForMedia(i), 1);
            return;
        }
        if (i2 == 3) {
            AIHelpWebChromeClient aIHelpWebChromeClient = this.mClient;
            if (aIHelpWebChromeClient != null) {
                aIHelpWebChromeClient.cancelChooseFileDialog();
            }
            ToastUtil.INSTANCE.showRawSnackBar(getActivity(), ResResolver.getString("aihelp_permission_denied"), -1);
            return;
        }
        if (i2 == 4) {
            AIHelpWebChromeClient aIHelpWebChromeClient2 = this.mClient;
            if (aIHelpWebChromeClient2 != null) {
                aIHelpWebChromeClient2.cancelChooseFileDialog();
            }
            ToastUtil.INSTANCE.showRawSnackBar(getActivity(), ResResolver.getString("aihelp_permission_denied"), ResResolver.getString("aihelp_yes"), -2, new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    iPermissionCallback.onPermissionRational();
                }
            });
            return;
        }
        if (i2 == 5) {
            AIHelpWebChromeClient aIHelpWebChromeClient3 = this.mClient;
            if (aIHelpWebChromeClient3 != null) {
                aIHelpWebChromeClient3.cancelChooseFileDialog();
            }
            ToastUtil.INSTANCE.showRawSnackBar(getActivity(), ResResolver.getString("aihelp_permission_ignored"), ResResolver.getString("aihelp_permission_settings"), -1, new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    iPermissionCallback.onPermissionIgnored();
                }
            });
            return;
        }
        AIHelpWebChromeClient aIHelpWebChromeClient4 = this.mClient;
        if (aIHelpWebChromeClient4 != null) {
            aIHelpWebChromeClient4.cancelChooseFileDialog();
        }
    }

    public void onRequestPermissionsResult(int i, String[] strArr, int[] iArr) {
        AIHelpPermissions.getInstance().onRequestPermissionsResult(strArr, iArr);
    }
}
