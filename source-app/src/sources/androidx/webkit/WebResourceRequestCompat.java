package androidx.webkit;

import android.webkit.WebResourceRequest;
import androidx.webkit.internal.ApiFeature;
import androidx.webkit.internal.ApiHelperForN;
import androidx.webkit.internal.WebResourceRequestAdapter;
import androidx.webkit.internal.WebViewFeatureInternal;
import androidx.webkit.internal.WebViewGlueCommunicator;

public class WebResourceRequestCompat {
    private WebResourceRequestCompat() {
    }

    public static boolean isRedirect(WebResourceRequest webResourceRequest) {
        ApiFeature.C0690N c0690n = WebViewFeatureInternal.WEB_RESOURCE_REQUEST_IS_REDIRECT;
        if (c0690n.isSupportedByFramework()) {
            return ApiHelperForN.isRedirect(webResourceRequest);
        }
        if (c0690n.isSupportedByWebView()) {
            return getAdapter(webResourceRequest).isRedirect();
        }
        throw WebViewFeatureInternal.getUnsupportedOperationException();
    }

    private static WebResourceRequestAdapter getAdapter(WebResourceRequest webResourceRequest) {
        return WebViewGlueCommunicator.getCompatConverter().convertWebResourceRequest(webResourceRequest);
    }
}
