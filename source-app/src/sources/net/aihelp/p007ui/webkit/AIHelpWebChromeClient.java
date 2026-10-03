package net.aihelp.p007ui.webkit;

import android.R;
import android.content.ClipData;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import androidx.fragment.app.Fragment;
import java.io.File;
import net.aihelp.config.AIHelpContext;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.permission.AIHelpPermissions;
import net.aihelp.data.attachment.AttachmentHelper;
import net.aihelp.data.event.UpdateTitleEvent;
import net.aihelp.p007ui.p009cs.IntentUrlFragment;

public class AIHelpWebChromeClient extends WebChromeClient {
    public static final int REQUEST_CODE = 1;
    private final Fragment fragment;
    private ViewGroup fullScreenContainer;
    private View mCustomView = null;
    private ValueCallback<Uri[]> mUploadCallbackAboveL;
    private ValueCallback<Uri> mUploadMessage;
    private final AIHelpWebProgress webProgress;
    private Window window;

    public AIHelpWebChromeClient(Fragment fragment, AIHelpWebProgress aIHelpWebProgress) {
        this.fragment = fragment;
        this.webProgress = aIHelpWebProgress;
        if (fragment == null || fragment.getActivity() == null) {
            return;
        }
        Window window = fragment.getActivity().getWindow();
        this.window = window;
        this.fullScreenContainer = (ViewGroup) window.getDecorView().findViewById(R.id.content);
    }

    @Override
    public void onShowCustomView(View view, WebChromeClient.CustomViewCallback customViewCallback) {
        super.onShowCustomView(view, customViewCallback);
        if (view == null || this.fullScreenContainer == null) {
            return;
        }
        this.mCustomView = view;
        view.setBackgroundColor(Color.parseColor("#000000"));
        this.fullScreenContainer.addView(this.mCustomView);
        this.window.setFlags(1024, 1024);
    }

    @Override
    public void onHideCustomView() {
        ViewGroup viewGroup;
        super.onHideCustomView();
        View view = this.mCustomView;
        if (view == null || (viewGroup = this.fullScreenContainer) == null) {
            return;
        }
        viewGroup.removeView(view);
        this.mCustomView = null;
        WindowManager.LayoutParams attributes = this.window.getAttributes();
        attributes.flags &= -1025;
        this.window.setAttributes(attributes);
        this.window.clearFlags(512);
    }

    @Override
    public void onReceivedTitle(WebView webView, String str) {
        super.onReceivedTitle(webView, str);
        if (TextUtils.isEmpty(str) || "AIHelp".equals(str) || "about:blank".equals(str) || !(this.fragment instanceof IntentUrlFragment)) {
            return;
        }
        EventBus.getDefault().post(new UpdateTitleEvent(str));
    }

    @Override
    public void onProgressChanged(WebView webView, int i) {
        super.onProgressChanged(webView, i);
        this.webProgress.setProgress(i);
    }

    @Override
    public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> valueCallback, WebChromeClient.FileChooserParams fileChooserParams) {
        this.mUploadCallbackAboveL = valueCallback;
        tryGetFileFromData();
        return true;
    }

    public void openFileChooser(ValueCallback<Uri> valueCallback) {
        this.mUploadMessage = valueCallback;
        tryGetFileFromData();
    }

    public void openFileChooser(ValueCallback<Uri> valueCallback, String str) {
        this.mUploadMessage = valueCallback;
        tryGetFileFromData();
    }

    public void openFileChooser(ValueCallback<Uri> valueCallback, String str, String str2) {
        this.mUploadMessage = valueCallback;
        tryGetFileFromData();
    }

    public void onActivityResult(int i, int i2, Intent intent) {
        if (i == 1) {
            try {
                if (this.mUploadMessage == null && this.mUploadCallbackAboveL == null) {
                    return;
                }
                Uri data = (intent == null || i2 != -1) ? null : intent.getData();
                if (this.mUploadCallbackAboveL != null) {
                    File copiedUriFile = AttachmentHelper.getCopiedUriFile(AIHelpContext.getInstance().getContext(), data);
                    this.mUploadCallbackAboveL.onReceiveValue(copiedUriFile != null ? new Uri[]{Uri.fromFile(copiedUriFile)} : null);
                    this.mUploadCallbackAboveL = null;
                    return;
                }
                ValueCallback<Uri> valueCallback = this.mUploadMessage;
                if (valueCallback != null) {
                    if (data != null) {
                        File copiedUriFile2 = AttachmentHelper.getCopiedUriFile(AIHelpContext.getInstance().getContext(), data);
                        this.mUploadMessage.onReceiveValue(copiedUriFile2 != null ? Uri.fromFile(copiedUriFile2) : null);
                    } else {
                        valueCallback.onReceiveValue(null);
                    }
                    this.mUploadMessage = null;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void cancelChooseFileDialog() {
        ValueCallback<Uri[]> valueCallback = this.mUploadCallbackAboveL;
        if (valueCallback != null) {
            valueCallback.onReceiveValue(null);
            this.mUploadCallbackAboveL = null;
        }
        ValueCallback<Uri> valueCallback2 = this.mUploadMessage;
        if (valueCallback2 != null) {
            valueCallback2.onReceiveValue(null);
            this.mUploadMessage = null;
        }
    }

    private void onActivityResultAboveL(int i, int i2, Intent intent) {
        Uri[] uriArr;
        if (i != 1 || this.mUploadCallbackAboveL == null) {
            return;
        }
        if (i2 != -1 || intent == null) {
            uriArr = null;
        } else {
            String dataString = intent.getDataString();
            ClipData clipData = intent.getClipData();
            if (clipData != null) {
                uriArr = new Uri[clipData.getItemCount()];
                for (int i3 = 0; i3 < clipData.getItemCount(); i3++) {
                    uriArr[i3] = clipData.getItemAt(i3).getUri();
                }
            } else {
                uriArr = null;
            }
            if (dataString != null) {
                uriArr = new Uri[]{Uri.parse(dataString)};
            }
        }
        if (uriArr != null) {
            this.mUploadCallbackAboveL.onReceiveValue(uriArr);
            this.mUploadCallbackAboveL = null;
        } else {
            this.mUploadCallbackAboveL.onReceiveValue(null);
            this.mUploadCallbackAboveL = null;
        }
    }

    private void tryGetFileFromData() {
        String[] strArr = {"android.permission.READ_EXTERNAL_STORAGE"};
        if (Build.VERSION.SDK_INT >= 33) {
            strArr = new String[]{"android.permission.READ_MEDIA_IMAGES", "android.permission.READ_MEDIA_VIDEO"};
        }
        AIHelpPermissions.getInstance().setHost(this.fragment).setRequestCode(1001).setRequestPermission(strArr).request(this.fragment.getContext(), 1);
    }
}
