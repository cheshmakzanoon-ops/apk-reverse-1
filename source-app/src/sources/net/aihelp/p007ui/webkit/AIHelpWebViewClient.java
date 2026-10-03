package net.aihelp.p007ui.webkit;

import android.content.Context;
import android.graphics.Bitmap;
import android.net.http.SslError;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.webkit.SslErrorHandler;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import cz.msebera.android.httpclient.HttpHost;
import net.aihelp.common.Const;
import net.aihelp.common.IntentValues;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.data.event.PageHoppingEvent;
import net.aihelp.utils.AppInfoUtil;

public class AIHelpWebViewClient extends WebViewClient {
    public static final String TAG = "AIHelpWebViewClient";
    private Context context;
    private OnPageLoadingProgressListener mPageLoadingProgressListener;
    private ShouldOverrideUrlLoadingListener mUrlLoadingListener;
    private boolean openInNewWindow;
    private AIHelpWebProgress webProgress;

    public interface OnPageLoadingProgressListener {
        void onPageFinished(WebView webView, String str);

        void onPageStarted(WebView webView, String str);
    }

    public interface ShouldOverrideUrlLoadingListener {
        void handleUrlClick(boolean z);
    }

    public void setOpenInNewWindow(boolean z) {
        this.openInNewWindow = z;
    }

    public void setOnPageLoadingProgressListener(OnPageLoadingProgressListener onPageLoadingProgressListener) {
        this.mPageLoadingProgressListener = onPageLoadingProgressListener;
    }

    public void setUrlLoadingListener(ShouldOverrideUrlLoadingListener shouldOverrideUrlLoadingListener) {
        this.mUrlLoadingListener = shouldOverrideUrlLoadingListener;
    }

    public AIHelpWebViewClient(Context context, AIHelpWebProgress aIHelpWebProgress) {
        this.context = context;
        this.webProgress = aIHelpWebProgress;
    }

    public AIHelpWebViewClient(Context context, AIHelpWebProgress aIHelpWebProgress, boolean z) {
        this.context = context;
        this.webProgress = aIHelpWebProgress;
        this.openInNewWindow = z;
    }

    @Override
    public boolean shouldOverrideUrlLoading(WebView webView, WebResourceRequest webResourceRequest) {
        boolean z = (Build.VERSION.SDK_INT >= 24 && handleUrlClickAndCancelCurrentLoad(webView, webResourceRequest.getUrl().toString())) || super.shouldOverrideUrlLoading(webView, webResourceRequest);
        ShouldOverrideUrlLoadingListener shouldOverrideUrlLoadingListener = this.mUrlLoadingListener;
        if (shouldOverrideUrlLoadingListener != null) {
            shouldOverrideUrlLoadingListener.handleUrlClick(z);
        }
        return z;
    }

    @Override
    public boolean shouldOverrideUrlLoading(WebView webView, String str) {
        boolean z = (Build.VERSION.SDK_INT < 24 && handleUrlClickAndCancelCurrentLoad(webView, str)) || super.shouldOverrideUrlLoading(webView, str);
        ShouldOverrideUrlLoadingListener shouldOverrideUrlLoadingListener = this.mUrlLoadingListener;
        if (shouldOverrideUrlLoadingListener != null) {
            shouldOverrideUrlLoadingListener.handleUrlClick(z);
        }
        return z;
    }

    @Override
    public void onPageStarted(WebView webView, String str, Bitmap bitmap) {
        super.onPageStarted(webView, str, bitmap);
        this.webProgress.show();
        OnPageLoadingProgressListener onPageLoadingProgressListener = this.mPageLoadingProgressListener;
        if (onPageLoadingProgressListener != null) {
            onPageLoadingProgressListener.onPageStarted(webView, str);
        }
    }

    @Override
    public void onPageFinished(WebView webView, String str) {
        super.onPageFinished(webView, str);
        OnPageLoadingProgressListener onPageLoadingProgressListener = this.mPageLoadingProgressListener;
        if (onPageLoadingProgressListener != null) {
            onPageLoadingProgressListener.onPageFinished(webView, str);
        }
    }

    private boolean handleUrlClickAndCancelCurrentLoad(WebView webView, String str) {
        if (!AppInfoUtil.isUrlStillNeedResponding(this.context, str) || !this.openInNewWindow) {
            return (!TextUtils.isEmpty(str) && !str.startsWith(HttpHost.DEFAULT_SCHEME_NAME)) || (!TextUtils.isEmpty(str) && str.contains("js-bridge=enable") && Const.sOnSpecificUrlClickedListener != null);
        }
        Bundle bundle = new Bundle();
        bundle.putString(IntentValues.INTENT_URL, str);
        EventBus.getDefault().post(new PageHoppingEvent(1009, bundle));
        return true;
    }

    @Override
    public void onReceivedSslError(WebView webView, SslErrorHandler sslErrorHandler, SslError sslError) {
        String str;
        super.onReceivedSslError(webView, sslErrorHandler, sslError);
        int primaryError = sslError.getPrimaryError();
        if (primaryError == 0) {
            str = "SSL_NOTYETVALID";
        } else if (primaryError == 1) {
            str = "SSL_EXPIRED";
        } else if (primaryError == 2) {
            str = "SSL_IDMISMATCH";
        } else if (primaryError == 3) {
            str = "SSL_UNTRUSTED";
        } else if (primaryError == 4) {
            str = "SSL_DATE_INVALID";
        } else if (primaryError == 5) {
            str = "SSL_INVALID";
        } else {
            str = "SslError unknown";
        }
        Log.d(TAG, "onReceivedSslError: ".concat(str));
    }
}
