package net.aihelp.p007ui.helper;

import android.content.Context;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import androidx.fragment.app.Fragment;
import net.aihelp.p007ui.preview.PreviewActivity;
import net.aihelp.p007ui.preview.data.PreviewInfo;
import net.aihelp.p007ui.webkit.AIHelpWebViewClient;

public class WebViewInjector {
    private Context context;
    private Fragment fragment;

    public static WebViewInjector getInstance() {
        return new WebViewInjector();
    }

    public WebViewInjector setHostFragment(Fragment fragment) {
        this.fragment = fragment;
        return this;
    }

    public WebViewInjector setContext(Context context) {
        this.context = context;
        return this;
    }

    public void inject(WebView webView, AIHelpWebViewClient aIHelpWebViewClient) {
        webView.addJavascriptInterface(this, "AIHelp");
        aIHelpWebViewClient.setOnPageLoadingProgressListener(new AIHelpWebViewClient.OnPageLoadingProgressListener() {
            @Override
            public void onPageStarted(WebView webView2, String str) {
            }

            @Override
            public void onPageFinished(WebView webView2, String str) {
                webView2.evaluateJavascript("setTimeout(function() {\n  var script = document.createElement('script');\n  script.innerHTML = `var imgList = document.getElementsByTagName('img');\n  for (const img of imgList) {\n    img.onclick = function() {\n      window.AIHelp.showImage(img.src)\n    }\n}`;\n  document.head.appendChild(script);\n}, 500);", null);
            }
        });
    }

    @JavascriptInterface
    public void showImage(String str) {
        Fragment fragment = this.fragment;
        if (fragment != null) {
            PreviewActivity.startAct(fragment, PreviewInfo.get(str));
            return;
        }
        Context context = this.context;
        if (context != null) {
            PreviewActivity.startAct(context, PreviewInfo.get(str));
        }
    }
}
