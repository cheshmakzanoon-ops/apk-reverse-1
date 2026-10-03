package net.aihelp.p007ui.webkit;

import android.content.Context;
import android.util.AttributeSet;
import android.webkit.WebSettings;
import android.webkit.WebView;

public class AIHelpWebView extends WebView {
    public AIHelpWebView(Context context) {
        super(context);
        if (isInEditMode()) {
            return;
        }
        configureWebView();
    }

    public AIHelpWebView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        if (isInEditMode()) {
            return;
        }
        configureWebView();
    }

    private void configureWebView() {
        WebSettings settings = getSettings();
        settings.setCacheMode(-1);
        settings.setJavaScriptEnabled(true);
        settings.setGeolocationEnabled(true);
        settings.setUseWideViewPort(true);
        settings.setJavaScriptCanOpenWindowsAutomatically(true);
        settings.setSupportZoom(true);
        settings.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NARROW_COLUMNS);
        settings.setPluginState(WebSettings.PluginState.ON);
        settings.setUserAgentString(settings.getUserAgentString() + "Rong/2.0");
        settings.setLoadWithOverviewMode(true);
        settings.setBlockNetworkImage(false);
        settings.setAllowFileAccess(true);
        settings.setDomStorageEnabled(true);
        settings.setDatabaseEnabled(true);
    }

    @Override
    protected void onMeasure(int i, int i2) {
        super.onMeasure(i, i2);
    }
}
