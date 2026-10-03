package net.gree.unitywebview;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Point;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Build;
import android.util.Base64;
import android.view.Display;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.webkit.CookieManager;
import android.webkit.GeolocationPermissions;
import android.webkit.HttpAuthHandler;
import android.webkit.JsPromptResult;
import android.webkit.JsResult;
import android.webkit.PermissionRequest;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import cn.thinkingdata.android.j$;
import com.unity3d.player.UnityPlayer;
import cz.msebera.android.httpclient.cookie.InterfaceC0009SM;
import java.net.HttpURLConnection;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayDeque;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;
import java.util.regex.Pattern;
import zendesk.p026ui.android.conversation.articleviewer.articlecontent.ArticleContentView;

public class CWebViewPlugin {
    private static final int ALLOWED_INTENT_FLAGS = 1007171600;
    private static boolean forceBringToFront;
    private static FrameLayout layout;
    private boolean canGoBack;
    private boolean canGoForward;
    private boolean mAlertDialogEnabled;
    private boolean mAllowAudioCapture;
    private Pattern mAllowRegex;
    private boolean mAllowVideoCapture;
    private String mBasicAuthPassword;
    private String mBasicAuthUserName;
    private Hashtable<String, String> mCustomHeaders;
    private Pattern mDenyRegex;
    private ViewTreeObserver.OnGlobalLayoutListener mGlobalLayoutListener;
    private Pattern mHookRegex;
    private View mVideoView;
    private WebView mWebView;
    private CWebViewPluginInterface mWebViewPlugin;
    private String mWebViewUA;
    private int progress;
    private Queue<String> mMessages = new ArrayDeque();
    private boolean mInteractionEnabled = true;

    public static void sanitizeQueryIntentActivitiesIntent(Intent intent) {
        intent.setFlags(intent.getFlags() & ALLOWED_INTENT_FLAGS);
        intent.addCategory("android.intent.category.BROWSABLE");
        intent.setComponent(null);
        intent.setSelector(null);
    }

    public static boolean isDestroyed(Activity activity) {
        if (activity == null) {
            return true;
        }
        return activity.isDestroyed();
    }

    public static boolean IsWebViewAvailable() {
        final Activity activity = UnityPlayer.currentActivity;
        FutureTask futureTask = new FutureTask(new Callable<Boolean>() {
            @Override
            public Boolean call() throws Exception {
                boolean z;
                try {
                    new WebView(activity);
                    z = true;
                } catch (Exception unused) {
                    z = false;
                }
                return Boolean.valueOf(z);
            }
        });
        if (isDestroyed(activity)) {
            return false;
        }
        activity.runOnUiThread(futureTask);
        try {
            return ((Boolean) futureTask.get()).booleanValue();
        } catch (Exception unused) {
            return false;
        }
    }

    public String GetMessage() {
        String strPoll;
        synchronized (this.mMessages) {
            strPoll = this.mMessages.size() > 0 ? this.mMessages.poll() : null;
        }
        return strPoll;
    }

    public void MyUnitySendMessage(String str, String str2, String str3) {
        synchronized (this.mMessages) {
            this.mMessages.add(str2 + ":" + str3);
        }
    }

    public boolean IsInitialized() {
        return this.mWebView != null;
    }

    public void Init(final String str, boolean z, boolean z2, int i, String str2, int i2) {
        final Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new RunnableC08452(i2, activity, this, str, str2, z2, i, z));
        final View rootView = activity.getWindow().getDecorView().getRootView();
        this.mGlobalLayoutListener = new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                Rect rect = new Rect();
                rootView.getWindowVisibleDisplayFrame(rect);
                Display defaultDisplay = activity.getWindowManager().getDefaultDisplay();
                try {
                    Point point = new Point();
                    defaultDisplay.getSize(point);
                    int i3 = point.y;
                } catch (NoSuchMethodError unused) {
                    defaultDisplay.getHeight();
                }
                int height = rootView.getRootView().getHeight() - (rect.bottom - rect.top);
                if (CWebViewPlugin.this.IsInitialized()) {
                    CWebViewPlugin.this.MyUnitySendMessage(str, "SetKeyboardVisible", Integer.toString(height));
                }
            }
        };
        rootView.getViewTreeObserver().addOnGlobalLayoutListener(this.mGlobalLayoutListener);
    }

    class RunnableC08452 implements Runnable {
        final Activity val$a;
        final int val$androidForceDarkMode;
        final String val$gameObject;
        final int val$radius;
        final CWebViewPlugin val$self;
        final boolean val$transparent;
        final String val$ua;
        final boolean val$zoom;

        RunnableC08452(int i, Activity activity, CWebViewPlugin cWebViewPlugin, String str, String str2, boolean z, int i2, boolean z2) {
            this.val$radius = i;
            this.val$a = activity;
            this.val$self = cWebViewPlugin;
            this.val$gameObject = str;
            this.val$ua = str2;
            this.val$zoom = z;
            this.val$androidForceDarkMode = i2;
            this.val$transparent = z2;
        }

        @Override
        public void run() {
            if (CWebViewPlugin.this.mWebView != null) {
                return;
            }
            CWebViewPlugin.this.mAlertDialogEnabled = true;
            CWebViewPlugin.this.mAllowVideoCapture = false;
            CWebViewPlugin.this.mAllowAudioCapture = false;
            CWebViewPlugin.this.mCustomHeaders = new Hashtable();
            final WebView roundedWebView = this.val$radius > 0 ? new RoundedWebView(this.val$a, this.val$radius) : new WebView(this.val$a);
            roundedWebView.setVisibility(8);
            roundedWebView.setFocusable(true);
            roundedWebView.setFocusableInTouchMode(true);
            roundedWebView.setWebChromeClient(new WebChromeClient() {
                @Override
                public void onPermissionRequest(PermissionRequest permissionRequest) {
                    String[] resources = permissionRequest.getResources();
                    for (String str : resources) {
                        if ((str.equals("android.webkit.resource.VIDEO_CAPTURE") && CWebViewPlugin.this.mAllowVideoCapture) || ((str.equals("android.webkit.resource.AUDIO_CAPTURE") && CWebViewPlugin.this.mAllowAudioCapture) || str.equals("android.webkit.resource.PROTECTED_MEDIA_ID"))) {
                            permissionRequest.grant(resources);
                            return;
                        }
                    }
                }

                @Override
                public void onProgressChanged(WebView webView, int i) {
                    CWebViewPlugin.this.progress = i;
                }

                @Override
                public void onShowCustomView(View view, WebChromeClient.CustomViewCallback customViewCallback) {
                    super.onShowCustomView(view, customViewCallback);
                    if (CWebViewPlugin.layout != null) {
                        CWebViewPlugin.this.mVideoView = view;
                        CWebViewPlugin.layout.setBackgroundColor(-16777216);
                        CWebViewPlugin.layout.addView(CWebViewPlugin.this.mVideoView);
                    }
                }

                @Override
                public void onHideCustomView() {
                    super.onHideCustomView();
                    if (CWebViewPlugin.layout != null) {
                        CWebViewPlugin.layout.removeView(CWebViewPlugin.this.mVideoView);
                        CWebViewPlugin.layout.setBackgroundColor(0);
                        CWebViewPlugin.this.mVideoView = null;
                    }
                }

                @Override
                public boolean onJsAlert(WebView webView, String str, String str2, JsResult jsResult) {
                    if (!CWebViewPlugin.this.mAlertDialogEnabled) {
                        jsResult.cancel();
                        return true;
                    }
                    return super.onJsAlert(webView, str, str2, jsResult);
                }

                @Override
                public boolean onJsConfirm(WebView webView, String str, String str2, JsResult jsResult) {
                    if (!CWebViewPlugin.this.mAlertDialogEnabled) {
                        jsResult.cancel();
                        return true;
                    }
                    return super.onJsConfirm(webView, str, str2, jsResult);
                }

                @Override
                public boolean onJsPrompt(WebView webView, String str, String str2, String str3, JsPromptResult jsPromptResult) {
                    if (!CWebViewPlugin.this.mAlertDialogEnabled) {
                        jsPromptResult.cancel();
                        return true;
                    }
                    return super.onJsPrompt(webView, str, str2, str3, jsPromptResult);
                }

                @Override
                public void onGeolocationPermissionsShowPrompt(String str, GeolocationPermissions.Callback callback) {
                    callback.invoke(str, true, false);
                }
            });
            CWebViewPlugin.this.mWebViewPlugin = new CWebViewPluginInterface(this.val$self, this.val$gameObject);
            roundedWebView.setWebViewClient(new WebViewClient() {
                @Override
                public void onReceivedError(WebView webView, int i, String str, String str2) {
                    roundedWebView.loadUrl("about:blank");
                    CWebViewPlugin.this.canGoBack = roundedWebView.canGoBack();
                    CWebViewPlugin.this.canGoForward = roundedWebView.canGoForward();
                    CWebViewPlugin.this.mWebViewPlugin.call("CallOnError", i + "\t" + str + "\t" + str2);
                }

                @Override
                public void onReceivedHttpError(WebView webView, WebResourceRequest webResourceRequest, WebResourceResponse webResourceResponse) {
                    CWebViewPlugin.this.canGoBack = roundedWebView.canGoBack();
                    CWebViewPlugin.this.canGoForward = roundedWebView.canGoForward();
                    CWebViewPlugin.this.mWebViewPlugin.call("CallOnHttpError", Integer.toString(webResourceResponse.getStatusCode()));
                }

                @Override
                public void onPageStarted(WebView webView, String str, Bitmap bitmap) {
                    CWebViewPlugin.this.canGoBack = roundedWebView.canGoBack();
                    CWebViewPlugin.this.canGoForward = roundedWebView.canGoForward();
                    CWebViewPlugin.this.mWebViewPlugin.call("CallOnStarted", str);
                }

                @Override
                public void onPageFinished(WebView webView, String str) {
                    CWebViewPlugin.this.canGoBack = roundedWebView.canGoBack();
                    CWebViewPlugin.this.canGoForward = roundedWebView.canGoForward();
                    CWebViewPlugin.this.mWebViewPlugin.call("CallOnLoaded", str);
                }

                @Override
                public void onLoadResource(WebView webView, String str) {
                    CWebViewPlugin.this.canGoBack = roundedWebView.canGoBack();
                    CWebViewPlugin.this.canGoForward = roundedWebView.canGoForward();
                }

                @Override
                public void onReceivedHttpAuthRequest(WebView webView, HttpAuthHandler httpAuthHandler, String str, String str2) {
                    if (CWebViewPlugin.this.mBasicAuthUserName != null && CWebViewPlugin.this.mBasicAuthPassword != null) {
                        httpAuthHandler.proceed(CWebViewPlugin.this.mBasicAuthUserName, CWebViewPlugin.this.mBasicAuthPassword);
                    } else {
                        httpAuthHandler.cancel();
                    }
                }

                @Override
                public WebResourceResponse shouldInterceptRequest(WebView webView, String str) {
                    if (CWebViewPlugin.this.mCustomHeaders == null || CWebViewPlugin.this.mCustomHeaders.isEmpty()) {
                        return super.shouldInterceptRequest(webView, str);
                    }
                    return shouldInterceptRequest(webView, str, null);
                }

                @Override
                public WebResourceResponse shouldInterceptRequest(WebView webView, WebResourceRequest webResourceRequest) {
                    if (CWebViewPlugin.this.mCustomHeaders == null || CWebViewPlugin.this.mCustomHeaders.isEmpty()) {
                        return super.shouldInterceptRequest(webView, webResourceRequest);
                    }
                    return shouldInterceptRequest(webView, webResourceRequest.getUrl().toString(), webResourceRequest.getRequestHeaders());
                }

                public WebResourceResponse shouldInterceptRequest(WebView webView, String str, Map<String, String> map) {
                    try {
                        HttpURLConnection httpURLConnection = (HttpURLConnection) new URL(str).openConnection();
                        httpURLConnection.setInstanceFollowRedirects(false);
                        httpURLConnection.setRequestProperty("User-Agent", CWebViewPlugin.this.mWebViewUA);
                        if (CWebViewPlugin.this.mBasicAuthUserName != null && CWebViewPlugin.this.mBasicAuthPassword != null) {
                            httpURLConnection.setRequestProperty("Authorization", "Basic " + Base64.encodeToString((CWebViewPlugin.this.mBasicAuthUserName + ":" + CWebViewPlugin.this.mBasicAuthPassword).getBytes(), 2));
                        }
                        String cookie = CookieManager.getInstance().getCookie(str);
                        if (cookie != null && !cookie.isEmpty()) {
                            httpURLConnection.addRequestProperty(InterfaceC0009SM.COOKIE, cookie);
                        }
                        if (map != null) {
                            for (Map.Entry<String, String> entry : map.entrySet()) {
                                httpURLConnection.setRequestProperty(entry.getKey(), entry.getValue());
                            }
                        }
                        for (Map.Entry entry2 : CWebViewPlugin.this.mCustomHeaders.entrySet()) {
                            httpURLConnection.setRequestProperty((String) entry2.getKey(), (String) entry2.getValue());
                        }
                        httpURLConnection.connect();
                        int responseCode = httpURLConnection.getResponseCode();
                        if (responseCode >= 300 && responseCode < 400) {
                            return null;
                        }
                        List<String> list = httpURLConnection.getHeaderFields().get(InterfaceC0009SM.SET_COOKIE);
                        if (list != null) {
                            CWebViewPlugin.this.SetCookies(str, list);
                        }
                        return new WebResourceResponse(httpURLConnection.getContentType().split(";", 2)[0], httpURLConnection.getContentEncoding(), httpURLConnection.getInputStream());
                    } catch (Exception unused) {
                        return super.shouldInterceptRequest(webView, str);
                    }
                }

                class AnonymousClass1 implements Runnable {
                    final List val$setCookieHeaders;
                    final String val$url;

                    AnonymousClass1(String str, List list) {
                        this.val$url = str;
                        this.val$setCookieHeaders = list;
                    }

                    @Override
                    public void run() {
                        CWebViewPlugin.this.SetCookies(this.val$url, this.val$setCookieHeaders);
                    }
                }

                @Override
                public boolean shouldOverrideUrlLoading(WebView webView, String str) {
                    Intent uri;
                    CWebViewPlugin.this.canGoBack = roundedWebView.canGoBack();
                    CWebViewPlugin.this.canGoForward = roundedWebView.canGoForward();
                    if ((CWebViewPlugin.this.mAllowRegex == null || !CWebViewPlugin.this.mAllowRegex.matcher(str).find()) && CWebViewPlugin.this.mDenyRegex != null && CWebViewPlugin.this.mDenyRegex.matcher(str).find()) {
                        return true;
                    }
                    if (!str.startsWith("unity:")) {
                        if (CWebViewPlugin.this.mHookRegex != null && CWebViewPlugin.this.mHookRegex.matcher(str).find()) {
                            CWebViewPlugin.this.mWebViewPlugin.call("CallOnHooked", str);
                            return true;
                        }
                        if (!str.toLowerCase().endsWith(".pdf") && !str.startsWith("https://maps.app.goo.gl") && (str.startsWith("http://") || str.startsWith("https://") || str.startsWith("file://") || str.startsWith("javascript:"))) {
                            CWebViewPlugin.this.mWebViewPlugin.call("CallOnStarted", str);
                            return false;
                        }
                        if (str.startsWith("intent://") || str.startsWith("android-app://")) {
                            try {
                                try {
                                    uri = Intent.parseUri(str, 1);
                                    try {
                                        CWebViewPlugin.sanitizeQueryIntentActivitiesIntent(uri);
                                        webView.getContext().startActivity(uri);
                                    } catch (ActivityNotFoundException unused) {
                                        launchMarket(webView.getContext(), uri);
                                    }
                                } catch (URISyntaxException unused2) {
                                }
                            } catch (ActivityNotFoundException unused3) {
                                uri = null;
                            }
                            return true;
                        }
                        try {
                            webView.getContext().startActivity(new Intent("android.intent.action.VIEW", Uri.parse(str)));
                        } catch (ActivityNotFoundException unused4) {
                        }
                        return true;
                    }
                    CWebViewPlugin.this.mWebViewPlugin.call("CallFromJS", str.substring(6));
                    return true;
                }

                private void launchMarket(Context context, Intent intent) {
                    String str;
                    if (intent == null || (str = intent.getPackage()) == null) {
                        return;
                    }
                    try {
                        try {
                            context.startActivity(new Intent("android.intent.action.VIEW", Uri.parse("market://details?id=" + str)));
                        } catch (ActivityNotFoundException unused) {
                            context.startActivity(new Intent("android.intent.action.VIEW", Uri.parse("https://play.google.com/store/apps/details?id=" + str)));
                        }
                    } catch (ActivityNotFoundException unused2) {
                    }
                }
            });
            roundedWebView.addJavascriptInterface(CWebViewPlugin.this.mWebViewPlugin, "Unity");
            WebSettings settings = roundedWebView.getSettings();
            String str = this.val$ua;
            if (str != null && str.length() > 0) {
                settings.setUserAgentString(this.val$ua);
            }
            CWebViewPlugin.this.mWebViewUA = settings.getUserAgentString();
            if (this.val$zoom) {
                settings.setSupportZoom(true);
                settings.setBuiltInZoomControls(true);
            } else {
                settings.setSupportZoom(false);
                settings.setBuiltInZoomControls(false);
            }
            settings.setDisplayZoomControls(false);
            settings.setLoadWithOverviewMode(true);
            settings.setUseWideViewPort(true);
            settings.setJavaScriptEnabled(true);
            settings.setGeolocationEnabled(true);
            settings.setAllowUniversalAccessFromFileURLs(true);
            settings.setMediaPlaybackRequiresUserGesture(false);
            settings.setDatabaseEnabled(true);
            settings.setDomStorageEnabled(true);
            settings.setDatabasePath(roundedWebView.getContext().getDir("databases", 0).getPath());
            settings.setAllowFileAccess(true);
            if (Build.VERSION.SDK_INT >= 29) {
                int i = this.val$androidForceDarkMode;
                if (i == 0) {
                    int i2 = UnityPlayer.currentActivity.getResources().getConfiguration().uiMode & 48;
                    if (i2 == 16) {
                        j$.ExternalSyntheticApiModelOutline0.m(settings, 0);
                    } else if (i2 == 32) {
                        j$.ExternalSyntheticApiModelOutline0.m(settings, 2);
                    }
                } else if (i == 1) {
                    j$.ExternalSyntheticApiModelOutline0.m(settings, 0);
                } else if (i == 2) {
                    j$.ExternalSyntheticApiModelOutline0.m(settings, 2);
                }
            }
            if (this.val$transparent) {
                roundedWebView.setBackgroundColor(0);
            }
            roundedWebView.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View view, MotionEvent motionEvent) {
                    return !CWebViewPlugin.this.mInteractionEnabled;
                }
            });
            if (CWebViewPlugin.layout == null || CWebViewPlugin.layout.getParent() != this.val$a.findViewById(android.R.id.content)) {
                FrameLayout unused = CWebViewPlugin.layout = new FrameLayout(this.val$a);
                this.val$a.addContentView(CWebViewPlugin.layout, new ViewGroup.LayoutParams(-1, -1));
                CWebViewPlugin.layout.setFocusable(true);
                CWebViewPlugin.layout.setFocusableInTouchMode(true);
            }
            CWebViewPlugin.layout.addView(roundedWebView, new FrameLayout.LayoutParams(-1, -1, 0));
            CWebViewPlugin.this.mWebView = roundedWebView;
        }
    }

    public void Destroy() {
        final Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                WebView webView = CWebViewPlugin.this.mWebView;
                CWebViewPlugin.this.mWebView = null;
                if (webView == null) {
                    return;
                }
                if (CWebViewPlugin.this.mGlobalLayoutListener != null) {
                    activity.getWindow().getDecorView().getRootView().getViewTreeObserver().removeOnGlobalLayoutListener(CWebViewPlugin.this.mGlobalLayoutListener);
                    CWebViewPlugin.this.mGlobalLayoutListener = null;
                }
                webView.stopLoading();
                if (CWebViewPlugin.this.mVideoView != null) {
                    CWebViewPlugin.layout.removeView(CWebViewPlugin.this.mVideoView);
                    CWebViewPlugin.layout.setBackgroundColor(0);
                    CWebViewPlugin.this.mVideoView = null;
                }
                CWebViewPlugin.layout.removeView(webView);
                webView.destroy();
            }
        });
    }

    public boolean SetURLPattern(String str, String str2, String str3) {
        final Pattern patternCompile;
        final Pattern patternCompile2 = null;
        if (str != null) {
            try {
                patternCompile = str.length() == 0 ? null : Pattern.compile(str);
            } catch (Exception unused) {
                return false;
            }
        }
        final Pattern patternCompile3 = (str2 == null || str2.length() == 0) ? null : Pattern.compile(str2);
        if (str3 != null && str3.length() != 0) {
            patternCompile2 = Pattern.compile(str3);
        }
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return false;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                CWebViewPlugin.this.mAllowRegex = patternCompile;
                CWebViewPlugin.this.mDenyRegex = patternCompile3;
                CWebViewPlugin.this.mHookRegex = patternCompile2;
            }
        });
        return true;
    }

    public void LoadURL(final String str) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                if (CWebViewPlugin.this.mCustomHeaders == null || CWebViewPlugin.this.mCustomHeaders.isEmpty()) {
                    CWebViewPlugin.this.mWebView.loadUrl(str);
                } else {
                    CWebViewPlugin.this.mWebView.loadUrl(str, CWebViewPlugin.this.mCustomHeaders);
                }
            }
        });
    }

    public void LoadHTML(final String str, final String str2) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                CWebViewPlugin.this.mWebView.loadDataWithBaseURL(str2, str, ArticleContentView.TYPE_TEXT_HTML, "UTF8", null);
            }
        });
    }

    public void EvaluateJS(final String str) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                CWebViewPlugin.this.mWebView.evaluateJavascript(str, null);
            }
        });
    }

    public void GoBack() {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                CWebViewPlugin.this.mWebView.goBack();
            }
        });
    }

    public void GoForward() {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                CWebViewPlugin.this.mWebView.goForward();
            }
        });
    }

    public void Reload() {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                CWebViewPlugin.this.mWebView.reload();
            }
        });
    }

    public void SetMargins(int i, int i2, int i3, int i4) {
        final FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(-1, -1, 0);
        layoutParams.setMargins(i, i2, i3, i4);
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                CWebViewPlugin.this.mWebView.setLayoutParams(layoutParams);
            }
        });
    }

    public void SetVisibility(final boolean z) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                if (z) {
                    CWebViewPlugin.this.mWebView.setVisibility(0);
                    CWebViewPlugin.layout.requestFocus();
                    CWebViewPlugin.this.mWebView.requestFocus();
                    if (CWebViewPlugin.layout != null && CWebViewPlugin.layout.getParent() != null && CWebViewPlugin.layout.getParent().getParent() != null) {
                        ((ViewGroup) CWebViewPlugin.layout.getParent().getParent()).requestLayout();
                    }
                    if (!CWebViewPlugin.forceBringToFront || CWebViewPlugin.layout == null) {
                        return;
                    }
                    CWebViewPlugin.layout.bringToFront();
                    return;
                }
                CWebViewPlugin.this.mWebView.setVisibility(8);
            }
        });
    }

    public void SetInteractionEnabled(final boolean z) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                CWebViewPlugin.this.mInteractionEnabled = z;
            }
        });
    }

    public void SetScrollbarsVisibility(final boolean z) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                CWebViewPlugin.this.mWebView.setHorizontalScrollBarEnabled(z);
                CWebViewPlugin.this.mWebView.setVerticalScrollBarEnabled(z);
            }
        });
    }

    public void SetAlertDialogEnabled(final boolean z) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                CWebViewPlugin.this.mAlertDialogEnabled = z;
            }
        });
    }

    public void SetCameraAccess(final boolean z) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                CWebViewPlugin.this.mAllowVideoCapture = z;
            }
        });
    }

    public void SetMicrophoneAccess(final boolean z) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                CWebViewPlugin.this.mAllowAudioCapture = z;
            }
        });
    }

    public void SetNetworkAvailable(final boolean z) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                CWebViewPlugin.this.mWebView.setNetworkAvailable(z);
            }
        });
    }

    public void Pause() {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                CWebViewPlugin.this.mWebView.onPause();
                CWebViewPlugin.this.mWebView.pauseTimers();
            }
        });
    }

    public void Resume() {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                CWebViewPlugin.this.mWebView.onResume();
                CWebViewPlugin.this.mWebView.resumeTimers();
            }
        });
    }

    public void OnApplicationPause(final boolean z) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                if (z) {
                    CWebViewPlugin.this.mWebView.onPause();
                    if (CWebViewPlugin.this.mWebView.getVisibility() == 0) {
                        CWebViewPlugin.this.mWebView.pauseTimers();
                        return;
                    }
                    return;
                }
                CWebViewPlugin.this.mWebView.onResume();
                CWebViewPlugin.this.mWebView.resumeTimers();
                if (!CWebViewPlugin.forceBringToFront || CWebViewPlugin.layout == null) {
                    return;
                }
                CWebViewPlugin.layout.bringToFront();
            }
        });
    }

    public void AddCustomHeader(final String str, final String str2) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mCustomHeaders == null) {
                    return;
                }
                CWebViewPlugin.this.mCustomHeaders.put(str, str2);
            }
        });
    }

    public String GetCustomHeaderValue(String str) {
        Hashtable<String, String> hashtable = this.mCustomHeaders;
        if (hashtable != null && hashtable.containsKey(str)) {
            return this.mCustomHeaders.get(str);
        }
        return null;
    }

    public void RemoveCustomHeader(final String str) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mCustomHeaders != null && CWebViewPlugin.this.mCustomHeaders.containsKey(str)) {
                    CWebViewPlugin.this.mCustomHeaders.remove(str);
                }
            }
        });
    }

    public void ClearCustomHeader() {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mCustomHeaders == null) {
                    return;
                }
                CWebViewPlugin.this.mCustomHeaders.clear();
            }
        });
    }

    public void ClearCookies() {
        CookieManager.getInstance().removeAllCookies(null);
        CookieManager.getInstance().flush();
    }

    public void SaveCookies() {
        CookieManager.getInstance().flush();
    }

    public void GetCookies(String str) {
        this.mWebViewPlugin.call("CallOnCookies", CookieManager.getInstance().getCookie(str));
    }

    public void SetCookies(String str, List<String> list) {
        CookieManager cookieManager = CookieManager.getInstance();
        Iterator<String> it = list.iterator();
        while (it.hasNext()) {
            cookieManager.setCookie(str, it.next());
        }
        cookieManager.flush();
    }

    public void SetBasicAuthInfo(String str, String str2) {
        this.mBasicAuthUserName = str;
        this.mBasicAuthPassword = str2;
    }

    public void ClearCache(final boolean z) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                CWebViewPlugin.this.mWebView.clearCache(z);
            }
        });
    }

    public void SetTextZoom(final int i) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                CWebViewPlugin.this.mWebView.getSettings().setTextZoom(i);
            }
        });
    }

    public void SetMixedContentMode(final int i) {
        Activity activity = UnityPlayer.currentActivity;
        if (isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPlugin.this.mWebView == null) {
                    return;
                }
                CWebViewPlugin.this.mWebView.getSettings().setMixedContentMode(i);
            }
        });
    }
}
