package zendesk.p026ui.android.internal;

import android.webkit.WebView;
import androidx.webkit.WebSettingsCompat;
import androidx.webkit.WebViewFeature;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import org.chromium.support_lib_boundary.util.Features;

@Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0000¨\u0006\u0003"}, m18d2 = {"setupContentTheming", "", "Landroid/webkit/WebView;", "zendesk.ui_ui-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class WebViewKtxKt {
    public static final void setupContentTheming(WebView webView) {
        Intrinsics.checkNotNullParameter(webView, "<this>");
        if ((webView.getResources().getConfiguration().uiMode & 48) == 32) {
            if (WebViewFeature.isFeatureSupported(Features.ALGORITHMIC_DARKENING)) {
                WebSettingsCompat.setAlgorithmicDarkeningAllowed(webView.getSettings(), true);
            } else if (WebViewFeature.isFeatureSupported(Features.FORCE_DARK)) {
                WebSettingsCompat.setForceDark(webView.getSettings(), 2);
            }
        }
    }
}
