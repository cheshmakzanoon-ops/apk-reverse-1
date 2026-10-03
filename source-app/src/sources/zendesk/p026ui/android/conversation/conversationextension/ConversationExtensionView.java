package zendesk.p026ui.android.conversation.conversationextension;

import android.content.Context;
import android.net.Uri;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.URLUtil;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;
import zendesk.p026ui.android.conversation.conversationextension.conversationextensionheader.ConversationExtensionHeaderRendering;
import zendesk.p026ui.android.conversation.conversationextension.conversationextensionheader.ConversationExtensionHeaderState;
import zendesk.p026ui.android.conversation.conversationextension.conversationextensionheader.ConversationExtensionHeaderView;
import zendesk.p026ui.android.conversations.LoadingIndicatorRendering;
import zendesk.p026ui.android.conversations.LoadingIndicatorState;
import zendesk.p026ui.android.conversations.LoadingIndicatorView;
import zendesk.p026ui.android.internal.WebViewKtxKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;
import zendesk.ui.android.common.retryerror.RetryErrorRendering;
import zendesk.ui.android.common.retryerror.RetryErrorState;
import zendesk.ui.android.common.retryerror.RetryErrorView;

@Metadata(m17d1 = {"\u0000j\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\n\b\u0007\u0018\u0000 .2\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u0001.B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u000f\u0010\u001b\u001a\u0004\u0018\u00010\u001cH\u0003¢\u0006\u0002\u0010\u001dJ\u0012\u0010\u001e\u001a\u0004\u0018\u00010\u00162\u0006\u0010\u0004\u001a\u00020\u0005H\u0002J\u0012\u0010\u001f\u001a\u00020\u001c2\b\u0010 \u001a\u0004\u0018\u00010!H\u0002J\b\u0010\"\u001a\u00020\u001cH\u0002J\u001c\u0010#\u001a\u00020\u001c2\u0012\u0010$\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030%H\u0016J\b\u0010&\u001a\u00020\u001cH\u0002J\b\u0010'\u001a\u00020\u001cH\u0002J\b\u0010(\u001a\u00020\u001cH\u0002J\b\u0010)\u001a\u00020\u001cH\u0002J\u000f\u0010*\u001a\u0004\u0018\u00010\u001cH\u0002¢\u0006\u0002\u0010\u001dJ\b\u0010+\u001a\u00020\u001cH\u0002J\b\u0010,\u001a\u00020\u001cH\u0002J\b\u0010-\u001a\u00020\u001cH\u0002R\u000e\u0010\f\u001a\u00020\rX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0015\u001a\u0004\u0018\u00010\u0016X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0018X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0019\u001a\u00020\u001aX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006/"}, m18d2 = {"Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionView;", "Landroidx/constraintlayout/widget/ConstraintLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "errorReceived", "", "header", "Lzendesk/ui/android/conversation/conversationextension/conversationextensionheader/ConversationExtensionHeaderView;", "loadingIndicatorView", "Lzendesk/ui/android/conversations/LoadingIndicatorView;", "rendering", "retryErrorView", "Lzendesk/ui/android/common/retryerror/RetryErrorView;", "webView", "Landroid/webkit/WebView;", "webViewContainer", "Landroid/widget/FrameLayout;", "webViewJavaScriptApi", "Lzendesk/ui/android/conversation/conversationextension/WebViewJavaScriptApi;", "configureWebView", "", "()Lkotlin/Unit;", "createWebView", "handleError", "request", "Landroid/webkit/WebResourceRequest;", "onErrorReceived", "render", "renderingUpdate", "Lkotlin/Function1;", "renderHeader", "renderLoadingIndicatorView", "renderRetryErrorView", "renderWebViewContent", "setupWebViewClient", "showContentView", "showErrorView", "showLoading", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationExtensionView extends ConstraintLayout implements Renderer<ConversationExtensionRendering> {

    @Deprecated
    public static final int COMPLETED_LOADING = 100;

    @Deprecated
    public static final String JAVASCRIPT_INTERFACE_API_NAME = "AndroidWebviewInterface";
    private boolean errorReceived;
    private final ConversationExtensionHeaderView header;
    private final LoadingIndicatorView loadingIndicatorView;
    private ConversationExtensionRendering rendering;
    private final RetryErrorView retryErrorView;
    private final WebView webView;
    private final FrameLayout webViewContainer;
    private final WebViewJavaScriptApi webViewJavaScriptApi;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[ConversationExtensionLoadingState.values().length];
            try {
                iArr[ConversationExtensionLoadingState.IDLE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ConversationExtensionLoadingState.LOADING.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[ConversationExtensionLoadingState.FAILED.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[ConversationExtensionLoadingState.SUCCESS.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public ConversationExtensionView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationExtensionView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationExtensionView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationExtensionView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public ConversationExtensionView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ConversationExtensionRendering();
        this.webViewJavaScriptApi = new WebViewJavaScriptApi(new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                this.this$0.rendering.getOnWebSdkClose$zendesk_ui_ui_android().invoke();
            }
        }, new Function1<String, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(String str) {
                invoke2(str);
                return Unit.INSTANCE;
            }

            public final void invoke2(String str) {
                this.this$0.rendering.getOnWebSdkUpdateTitle$zendesk_ui_ui_android().invoke(str);
            }
        });
        ConstraintLayout.inflate(context, R.layout.zuia_view_conversation_extension, (ViewGroup) this);
        Object objFindViewById = findViewById(R.id.zuia_conversation_extension_header_view);
        Intrinsics.checkNotNullExpressionValue(objFindViewById, "findViewById(...)");
        this.header = (ConversationExtensionHeaderView) objFindViewById;
        View viewFindViewById = findViewById(R.id.zuia_conversation_extension_web_view_container);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        FrameLayout frameLayout = (FrameLayout) viewFindViewById;
        this.webViewContainer = frameLayout;
        WebView webViewCreateWebView = createWebView(context);
        this.webView = webViewCreateWebView;
        if (webViewCreateWebView != null) {
            frameLayout.addView(webViewCreateWebView);
        }
        View viewFindViewById2 = findViewById(R.id.zuia_conversation_extension_loading_indicator_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.loadingIndicatorView = (LoadingIndicatorView) viewFindViewById2;
        RetryErrorView retryErrorViewFindViewById = findViewById(R.id.zuia_conversation_extension_retry_error_view);
        Intrinsics.checkNotNullExpressionValue(retryErrorViewFindViewById, "findViewById(...)");
        this.retryErrorView = retryErrorViewFindViewById;
        configureWebView();
    }

    private final WebView createWebView(Context context) {
        try {
            WebView webView = new WebView(context);
            webView.setLayoutParams((ViewGroup.LayoutParams) new ConstraintLayout.LayoutParams(-1, -1));
            return webView;
        } catch (Exception unused) {
            return null;
        }
    }

    private final Unit configureWebView() {
        WebView webView = this.webView;
        if (webView == null) {
            return null;
        }
        WebViewKtxKt.setupContentTheming(webView);
        setupWebViewClient();
        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setDomStorageEnabled(true);
        webView.addJavascriptInterface(this.webViewJavaScriptApi, JAVASCRIPT_INTERFACE_API_NAME);
        return Unit.INSTANCE;
    }

    private final Unit setupWebViewClient() {
        WebView webView = this.webView;
        if (webView == null) {
            return null;
        }
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                if (view == null || view.getProgress() != 100 || this.this$0.errorReceived) {
                    return;
                }
                this.this$0.rendering.getOnPageLoadingComplete$zendesk_ui_ui_android().invoke();
                if (Intrinsics.areEqual(view.getTitle(), view.getUrl())) {
                    return;
                }
                this.this$0.rendering.getOnWebSdkUpdateTitle$zendesk_ui_ui_android().invoke(view.getTitle());
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                Uri url;
                boolean zIsValidUrl = (request == null || (url = request.getUrl()) == null) ? false : URLUtil.isValidUrl(url.toString());
                if (request != null && request.isForMainFrame() && zIsValidUrl) {
                    this.this$0.showLoading();
                    Uri url2 = request.getUrl();
                    if (url2 != null) {
                        Function1<String, Unit> onUrlUpdated$zendesk_ui_ui_android = this.this$0.rendering.getOnUrlUpdated$zendesk_ui_ui_android();
                        String string = url2.toString();
                        Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
                        onUrlUpdated$zendesk_ui_ui_android.invoke(string);
                    }
                    return true;
                }
                return super.shouldOverrideUrlLoading(view, request);
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                if (url != null ? URLUtil.isValidUrl(url) : false) {
                    this.this$0.showLoading();
                    if (url == null) {
                        return true;
                    }
                    this.this$0.rendering.getOnUrlUpdated$zendesk_ui_ui_android().invoke(url);
                    return true;
                }
                return super.shouldOverrideUrlLoading(view, url);
            }

            @Override
            public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
                this.this$0.handleError(request);
                super.onReceivedError(view, request, error);
            }

            @Override
            public void onReceivedHttpError(WebView view, WebResourceRequest request, WebResourceResponse errorResponse) {
                this.this$0.handleError(request);
                super.onReceivedHttpError(view, request, errorResponse);
            }

            @Override
            public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
                this.this$0.onErrorReceived();
                super.onReceivedError(view, errorCode, description, failingUrl);
            }
        });
        return Unit.INSTANCE;
    }

    public final void handleError(WebResourceRequest request) {
        if (request == null || !request.isForMainFrame()) {
            return;
        }
        onErrorReceived();
    }

    public final void onErrorReceived() {
        this.rendering.getOnWebViewError$zendesk_ui_ui_android().invoke();
        this.errorReceived = true;
    }

    private final void showContentView() {
        this.retryErrorView.setVisibility(8);
        this.loadingIndicatorView.setVisibility(8);
        this.webViewContainer.setVisibility(0);
    }

    public void render(Function1<? super ConversationExtensionRendering, ConversationExtensionRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        ConversationExtensionRendering conversationExtensionRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = conversationExtensionRenderingInvoke;
        setBackgroundColor(conversationExtensionRenderingInvoke.getState().getBackgroundColor$zendesk_ui_ui_android());
        renderHeader();
        renderLoadingIndicatorView();
        renderRetryErrorView();
        renderWebViewContent();
    }

    private final void renderHeader() {
        this.header.render(new Function1<ConversationExtensionHeaderRendering, ConversationExtensionHeaderRendering>() {
            {
                super(1);
            }

            @Override
            public final ConversationExtensionHeaderRendering invoke(ConversationExtensionHeaderRendering headerRendering) {
                Intrinsics.checkNotNullParameter(headerRendering, "headerRendering");
                ConversationExtensionHeaderRendering.Builder builder = headerRendering.toBuilder();
                final ConversationExtensionView conversationExtensionView = ConversationExtensionView.this;
                ConversationExtensionHeaderRendering.Builder builderState = builder.state(new Function1<ConversationExtensionHeaderState, ConversationExtensionHeaderState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ConversationExtensionHeaderState invoke(ConversationExtensionHeaderState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        boolean showBackButton$zendesk_ui_ui_android = conversationExtensionView.rendering.getState().getShowBackButton$zendesk_ui_ui_android();
                        return ConversationExtensionHeaderState.copy$default(state, conversationExtensionView.rendering.getState().getBackgroundColor$zendesk_ui_ui_android(), conversationExtensionView.rendering.getState().getButtonBackgroundColor$zendesk_ui_ui_android(), conversationExtensionView.rendering.getState().getIconColor$zendesk_ui_ui_android(), 0, showBackButton$zendesk_ui_ui_android, conversationExtensionView.rendering.getState().getTitle$zendesk_ui_ui_android(), conversationExtensionView.rendering.getState().getTextColor$zendesk_ui_ui_android(), 8, null);
                    }
                });
                final ConversationExtensionView conversationExtensionView2 = ConversationExtensionView.this;
                return builderState.onMenuItemClicked(new Function1<ConversationExtensionHeaderState.ButtonName, Unit>() {

                    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                    public class WhenMappings {
                        public static final int[] $EnumSwitchMapping$0;

                        static {
                            int[] iArr = new int[ConversationExtensionHeaderState.ButtonName.values().length];
                            try {
                                iArr[ConversationExtensionHeaderState.ButtonName.CLOSE.ordinal()] = 1;
                            } catch (NoSuchFieldError unused) {
                            }
                            try {
                                iArr[ConversationExtensionHeaderState.ButtonName.BACK.ordinal()] = 2;
                            } catch (NoSuchFieldError unused2) {
                            }
                            $EnumSwitchMapping$0 = iArr;
                        }
                    }

                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(ConversationExtensionHeaderState.ButtonName buttonName) {
                        invoke2(buttonName);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(ConversationExtensionHeaderState.ButtonName it) {
                        Intrinsics.checkNotNullParameter(it, "it");
                        int i = WhenMappings.$EnumSwitchMapping$0[it.ordinal()];
                        if (i == 1) {
                            conversationExtensionView2.rendering.getOnCloseButtonClicked$zendesk_ui_ui_android().invoke();
                        } else {
                            if (i != 2) {
                                return;
                            }
                            conversationExtensionView2.rendering.getOnBackButtonClicked$zendesk_ui_ui_android().invoke();
                        }
                    }
                }).build();
            }
        });
    }

    private final void renderLoadingIndicatorView() {
        this.loadingIndicatorView.render(new Function1<LoadingIndicatorRendering, LoadingIndicatorRendering>() {
            {
                super(1);
            }

            @Override
            public final LoadingIndicatorRendering invoke(LoadingIndicatorRendering loadingRendering) {
                Intrinsics.checkNotNullParameter(loadingRendering, "loadingRendering");
                LoadingIndicatorRendering.Builder builder = loadingRendering.toBuilder();
                final ConversationExtensionView conversationExtensionView = ConversationExtensionView.this;
                return builder.state(new Function1<LoadingIndicatorState, LoadingIndicatorState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final LoadingIndicatorState invoke(LoadingIndicatorState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return state.copy(true, conversationExtensionView.rendering.getState().getIndicatorColor$zendesk_ui_ui_android());
                    }
                }).build();
            }
        });
    }

    private final void renderRetryErrorView() {
        this.retryErrorView.render(new Function1<RetryErrorRendering, RetryErrorRendering>() {
            {
                super(1);
            }

            @Override
            public final RetryErrorRendering invoke(RetryErrorRendering retryErrorRendering) {
                Intrinsics.checkNotNullParameter(retryErrorRendering, "retryErrorRendering");
                final String string = ConversationExtensionView.this.getContext().getString(R.string.zuia_guide_article_view_article_failed_to_load_label);
                Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
                RetryErrorRendering.Builder builder = retryErrorRendering.toBuilder();
                final ConversationExtensionView conversationExtensionView = ConversationExtensionView.this;
                RetryErrorRendering.Builder builderState = builder.state(new Function1<RetryErrorState, RetryErrorState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final RetryErrorState invoke(RetryErrorState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        int textColor$zendesk_ui_ui_android = conversationExtensionView.rendering.getState().getTextColor$zendesk_ui_ui_android();
                        String string2 = conversationExtensionView.getContext().getString(R.string.zuia_guide_article_view_tap_to_retry_label);
                        int textColor$zendesk_ui_ui_android2 = conversationExtensionView.rendering.getState().getTextColor$zendesk_ui_ui_android();
                        String str = string;
                        Intrinsics.checkNotNull(string2);
                        return state.copy(str, textColor$zendesk_ui_ui_android2, string2, textColor$zendesk_ui_ui_android);
                    }
                });
                final ConversationExtensionView conversationExtensionView2 = ConversationExtensionView.this;
                return builderState.onButtonClicked(new Function0<Unit>() {
                    {
                        super(0);
                    }

                    @Override
                    public Unit invoke() {
                        invoke2();
                        return Unit.INSTANCE;
                    }

                    public final void invoke2() {
                        conversationExtensionView2.rendering.getOnRetryButtonClicked$zendesk_ui_ui_android().invoke();
                    }
                }).build();
            }
        });
    }

    private final void renderWebViewContent() {
        Unit unit;
        int i = WhenMappings.$EnumSwitchMapping$0[this.rendering.getState().getContentState$zendesk_ui_ui_android().ordinal()];
        if (i != 2) {
            if (i == 3) {
                showErrorView();
                return;
            } else {
                if (i != 4) {
                    return;
                }
                showContentView();
                return;
            }
        }
        WebView webView = this.webView;
        if (webView != null) {
            this.errorReceived = false;
            showLoading();
            webView.getSettings().setUserAgentString(webView.getSettings().getUserAgentString() + " AndroidWebview/" + this.rendering.getState().getUserAgent$zendesk_ui_ui_android());
            webView.loadUrl(this.rendering.getState().getUrl$zendesk_ui_ui_android());
            unit = Unit.INSTANCE;
        } else {
            unit = null;
        }
        if (unit == null) {
            Logger.m219e("ConversationExtensionView", "Error inflating WebView", new Object[0]);
            this.errorReceived = true;
            showErrorView();
        }
    }

    public final void showLoading() {
        this.retryErrorView.setVisibility(8);
        this.webViewContainer.setVisibility(8);
        this.loadingIndicatorView.setVisibility(0);
    }

    private final void showErrorView() {
        this.loadingIndicatorView.setVisibility(8);
        this.webViewContainer.setVisibility(8);
        this.retryErrorView.setVisibility(0);
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0007"}, m18d2 = {"Lzendesk/ui/android/conversation/conversationextension/ConversationExtensionView$Companion;", "", "()V", "COMPLETED_LOADING", "", "JAVASCRIPT_INTERFACE_API_NAME", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
