package zendesk.p026ui.android.conversation.articleviewer.articlecontent;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.constraintlayout.widget.ConstraintSet;
import androidx.webkit.WebResourceErrorCompat;
import androidx.webkit.WebViewClientCompat;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import okhttp3.internal.Util;
import zendesk.logger.Logger;
import zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel.ArticleAttachmentCarouselCellState;
import zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel.ArticleAttachmentCarouselCellView;
import zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel.ArticleAttachmentCarouselRendering;
import zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel.ArticleAttachmentItem;
import zendesk.p026ui.android.conversations.LoadingIndicatorRendering;
import zendesk.p026ui.android.conversations.LoadingIndicatorState;
import zendesk.p026ui.android.conversations.LoadingIndicatorView;
import zendesk.p026ui.android.internal.WebViewKtxKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;
import zendesk.ui.android.common.retryerror.RetryErrorRendering;
import zendesk.ui.android.common.retryerror.RetryErrorState;
import zendesk.ui.android.common.retryerror.RetryErrorView;

@Metadata(m17d1 = {"\u0000j\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\b\u0007\u0018\u0000 ,2\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002:\u0001,B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u0012\u0010\u001e\u001a\u0004\u0018\u00010\u001b2\u0006\u0010\u0004\u001a\u00020\u0005H\u0002J\u001c\u0010\u001f\u001a\u00020 2\u0012\u0010!\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\"H\u0016J\b\u0010#\u001a\u00020 H\u0002J\b\u0010$\u001a\u00020 H\u0002J\b\u0010%\u001a\u00020 H\u0002J\b\u0010&\u001a\u00020 H\u0002J\b\u0010'\u001a\u00020 H\u0002J\b\u0010(\u001a\u00020 H\u0002J\b\u0010)\u001a\u00020 H\u0002J\b\u0010*\u001a\u00020 H\u0002J\b\u0010+\u001a\u00020 H\u0002R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u000e\u001a\u0004\u0018\u00010\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0010\u001a\u0004\u0018\u00010\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0015X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0016\u001a\u00020\u0017X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0018\u001a\u00020\u0019X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u001a\u001a\u0004\u0018\u00010\u001bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u001c\u001a\u00020\u001dX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006-"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentView;", "Landroidx/constraintlayout/widget/ConstraintLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "articleAttachmentCarousel", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselCellView;", "bottomSpacer", "Landroid/view/View;", "constraintLayout", "loadingIndicatorView", "Lzendesk/ui/android/conversations/LoadingIndicatorView;", "rendering", "retryErrorView", "Lzendesk/ui/android/common/retryerror/RetryErrorView;", "scrollView", "Landroid/widget/ScrollView;", "title", "Landroid/widget/TextView;", "webView", "Lzendesk/ui/android/conversation/articleviewer/articlecontent/NonScrollingWebView;", "webViewContainer", "Landroid/widget/FrameLayout;", "createWebView", "render", "", "renderingUpdate", "Lkotlin/Function1;", "renderAttachmentListCarousel", "renderHtmlBodyWithCss", "renderLoadingIndicatorView", "renderRetryErrorView", "renderWebViewContent", "setupWebViewClient", "showArticleView", "showErrorView", "showLoading", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleContentView extends ConstraintLayout implements Renderer<ArticleContentRendering> {

    @Deprecated
    public static final int COMPLETED_LOADING = 100;

    @Deprecated
    public static final int REMOVE_ALPHA = 2;

    @Deprecated
    public static final String TYPE_TEXT_HTML = "text/html";

    @Deprecated
    public static final String UTF_8_ENCODING_TYPE = "UTF-8";
    private final ArticleAttachmentCarouselCellView articleAttachmentCarousel;
    private final View bottomSpacer;
    private final ConstraintLayout constraintLayout;
    private final LoadingIndicatorView loadingIndicatorView;
    private ArticleContentRendering rendering;
    private final RetryErrorView retryErrorView;
    private final ScrollView scrollView;
    private final TextView title;
    private final NonScrollingWebView webView;
    private final FrameLayout webViewContainer;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[ArticleContentState.ArticleLoadingStatus.values().length];
            try {
                iArr[ArticleContentState.ArticleLoadingStatus.FAILED.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ArticleContentState.ArticleLoadingStatus.SUCCESS.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[ArticleContentState.ArticleLoadingStatus.LOADING.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[ArticleContentState.ArticleLoadingStatus.IDLE.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public ArticleContentView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ArticleContentView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ArticleContentView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ArticleContentView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public ArticleContentView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ArticleContentRendering();
        ConstraintLayout.inflate(context, R.layout.zuia_view_article_content, (ViewGroup) this);
        View viewFindViewById = findViewById(R.id.zuia_article_webview_container);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        FrameLayout frameLayout = (FrameLayout) viewFindViewById;
        this.webViewContainer = frameLayout;
        NonScrollingWebView nonScrollingWebViewCreateWebView = createWebView(context);
        this.webView = nonScrollingWebViewCreateWebView;
        if (nonScrollingWebViewCreateWebView != null) {
            frameLayout.addView(nonScrollingWebViewCreateWebView);
        }
        View viewFindViewById2 = findViewById(R.id.zuia_article_loading_indicator_view);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.loadingIndicatorView = (LoadingIndicatorView) viewFindViewById2;
        RetryErrorView retryErrorViewFindViewById = findViewById(R.id.zuia_article_retry_error_view);
        Intrinsics.checkNotNullExpressionValue(retryErrorViewFindViewById, "findViewById(...)");
        this.retryErrorView = retryErrorViewFindViewById;
        View viewFindViewById3 = findViewById(R.id.zuia_article_title);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        this.title = (TextView) viewFindViewById3;
        View viewFindViewById4 = findViewById(R.id.zuia_article_scrollview);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById4, "findViewById(...)");
        this.scrollView = (ScrollView) viewFindViewById4;
        this.bottomSpacer = findViewById(R.id.zuia_article_bottom_spacer);
        this.constraintLayout = findViewById(R.id.zuia_article_content_constraint_layout);
        View viewFindViewById5 = findViewById(R.id.zuia_article_attachment_carousel);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById5, "findViewById(...)");
        this.articleAttachmentCarousel = (ArticleAttachmentCarouselCellView) viewFindViewById5;
        WebSettings settings = nonScrollingWebViewCreateWebView != null ? nonScrollingWebViewCreateWebView.getSettings() : null;
        if (settings != null) {
            settings.setJavaScriptEnabled(true);
        }
        WebSettings settings2 = nonScrollingWebViewCreateWebView != null ? nonScrollingWebViewCreateWebView.getSettings() : null;
        if (settings2 != null) {
            settings2.setDomStorageEnabled(true);
        }
        if (nonScrollingWebViewCreateWebView != null) {
            WebViewKtxKt.setupContentTheming(nonScrollingWebViewCreateWebView);
        }
        setupWebViewClient();
    }

    private final NonScrollingWebView createWebView(Context context) {
        try {
            NonScrollingWebView nonScrollingWebView = new NonScrollingWebView(context, null, 0, 0, 14, null);
            nonScrollingWebView.setLayoutParams((ViewGroup.LayoutParams) new ConstraintLayout.LayoutParams(-1, -2));
            return nonScrollingWebView;
        } catch (Exception unused) {
            return null;
        }
    }

    public void render(Function1<? super ArticleContentRendering, ArticleContentRendering> renderingUpdate) {
        Unit unit;
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        ArticleContentState state = this.rendering.getState();
        ArticleContentRendering articleContentRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = articleContentRenderingInvoke;
        ArticleContentState state2 = articleContentRenderingInvoke.getState();
        renderLoadingIndicatorView();
        renderRetryErrorView();
        if (!this.rendering.getState().getAttachmentList$zendesk_ui_ui_android().isEmpty()) {
            renderAttachmentListCarousel();
        }
        int i = WhenMappings.$EnumSwitchMapping$0[this.rendering.getState().getStatus$zendesk_ui_ui_android().ordinal()];
        if (i == 1) {
            showErrorView();
            return;
        }
        if (i != 2) {
            if (i != 3) {
                return;
            }
            showLoading();
            return;
        }
        if (this.webView != null) {
            if (!Intrinsics.areEqual(state, state2)) {
                renderWebViewContent();
            }
            unit = Unit.INSTANCE;
        } else {
            unit = null;
        }
        if (unit == null) {
            Logger.m219e("ArticleContentView", "Failed to render WebView", new Object[0]);
            showErrorView();
            this.rendering.getOnLoadingUpdated$zendesk_ui_ui_android().invoke(ArticleContentState.ArticleLoadingStatus.FAILED);
        }
    }

    private final void renderAttachmentListCarousel() {
        this.articleAttachmentCarousel.render(new Function1<ArticleAttachmentCarouselRendering, ArticleAttachmentCarouselRendering>() {
            {
                super(1);
            }

            @Override
            public final ArticleAttachmentCarouselRendering invoke(ArticleAttachmentCarouselRendering attachmentCarouselRendering) {
                Intrinsics.checkNotNullParameter(attachmentCarouselRendering, "attachmentCarouselRendering");
                ArticleAttachmentCarouselRendering.Builder builder = attachmentCarouselRendering.toBuilder();
                final ArticleContentView articleContentView = ArticleContentView.this;
                ArticleAttachmentCarouselRendering.Builder builderState = builder.state(new Function1<ArticleAttachmentCarouselCellState, ArticleAttachmentCarouselCellState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ArticleAttachmentCarouselCellState invoke(ArticleAttachmentCarouselCellState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return state.copy(articleContentView.rendering.getState().getAttachmentList$zendesk_ui_ui_android(), articleContentView.rendering.getState().getAttachmentListTextColor(), articleContentView.rendering.getState().getNavigationButtonBackgroundColor(), articleContentView.rendering.getState().getFocusedStateBorderColor());
                    }
                });
                final ArticleContentView articleContentView2 = ArticleContentView.this;
                return builderState.onAttachmentItemClicked(new Function1<ArticleAttachmentItem, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(ArticleAttachmentItem articleAttachmentItem) {
                        invoke2(articleAttachmentItem);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(ArticleAttachmentItem it) {
                        Intrinsics.checkNotNullParameter(it, "it");
                        articleContentView2.rendering.getOnAttachmentItemClicked$zendesk_ui_ui_android().invoke(it);
                    }
                }).build();
            }
        });
    }

    private final void renderWebViewContent() {
        this.title.setVisibility(8);
        renderHtmlBodyWithCss();
    }

    private final void renderHtmlBodyWithCss() {
        String title;
        ArticleContentState.ArticleData articleData$zendesk_ui_ui_android = this.rendering.getState().getArticleData$zendesk_ui_ui_android();
        if (articleData$zendesk_ui_ui_android != null && (title = articleData$zendesk_ui_ui_android.getTitle()) != null) {
            this.title.setText(title);
        }
        this.title.setTextColor(this.rendering.getState().getTextColor$zendesk_ui_ui_android());
        ArticleContentState.ArticleData articleData$zendesk_ui_ui_android2 = this.rendering.getState().getArticleData$zendesk_ui_ui_android();
        if (articleData$zendesk_ui_ui_android2 != null) {
            ArticleHTMLGenerator articleHTMLGenerator = ArticleHTMLGenerator.INSTANCE;
            String strSubstring = Util.toHexString(this.rendering.getState().getTextColor$zendesk_ui_ui_android()).substring(2);
            Intrinsics.checkNotNullExpressionValue(strSubstring, "substring(...)");
            String strSubstring2 = Util.toHexString(this.rendering.getState().getBackgroundColor$zendesk_ui_ui_android()).substring(2);
            Intrinsics.checkNotNullExpressionValue(strSubstring2, "substring(...)");
            String strCreateHTML = articleHTMLGenerator.createHTML(strSubstring, strSubstring2, articleData$zendesk_ui_ui_android2.getHtmlBody());
            NonScrollingWebView nonScrollingWebView = this.webView;
            if (nonScrollingWebView != null) {
                nonScrollingWebView.loadDataWithBaseURL(articleData$zendesk_ui_ui_android2.getBaseUrl(), strCreateHTML, TYPE_TEXT_HTML, "UTF-8", null);
            }
        }
    }

    @Metadata(m17d1 = {"\u00009\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000*\u0001\u0000\b\n\u0018\u00002\u00020\u0001J\u001c\u0010\u0002\u001a\u00020\u00032\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007H\u0016J&\u0010\b\u001a\u00020\u00032\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\b\u0010\u0006\u001a\u0004\u0018\u00010\u00072\b\u0010\t\u001a\u0004\u0018\u00010\nH\u0016J \u0010\u000b\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000fH\u0016J\u0018\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\f\u001a\u00020\rH\u0016J\u001c\u0010\u0010\u001a\u00020\u00112\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007H\u0017¨\u0006\u0012"}, m18d2 = {"zendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentView$setupWebViewClient$1", "Landroidx/webkit/WebViewClientCompat;", "onPageFinished", "", "view", "Landroid/webkit/WebView;", "url", "", "onPageStarted", "facIcon", "Landroid/graphics/Bitmap;", "onReceivedError", "request", "Landroid/webkit/WebResourceRequest;", "error", "Landroidx/webkit/WebResourceErrorCompat;", "shouldOverrideUrlLoading", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class C15501 extends WebViewClientCompat {
        C15501() {
        }

        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
            Intrinsics.checkNotNullParameter(view, "view");
            Intrinsics.checkNotNullParameter(request, "request");
            return ArticleContentView.this.rendering.getShouldOverrideUrl$zendesk_ui_ui_android().invoke(request.getUrl().toString()).booleanValue();
        }

        @Deprecated(message = "Deprecated in Java")
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            if (url != null) {
                return ArticleContentView.this.rendering.getShouldOverrideUrl$zendesk_ui_ui_android().invoke(url).booleanValue();
            }
            return super.shouldOverrideUrlLoading(view, url);
        }

        public void onPageStarted(WebView view, String url, Bitmap facIcon) {
            ArticleContentView.this.showLoading();
            ScrollView scrollView = ArticleContentView.this.scrollView;
            final ArticleContentView articleContentView = ArticleContentView.this;
            scrollView.post(new Runnable() {
                @Override
                public final void run() {
                    ArticleContentView.C15501.onPageStarted$lambda$0(articleContentView);
                }
            });
            ArticleContentView.this.rendering.getOnLoadingUpdated$zendesk_ui_ui_android().invoke(ArticleContentState.ArticleLoadingStatus.LOADING);
        }

        public static final void onPageStarted$lambda$0(ArticleContentView this$0) {
            Intrinsics.checkNotNullParameter(this$0, "this$0");
            this$0.scrollView.smoothScrollTo(0, 0);
        }

        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
            if (view == null || view.getProgress() != 100) {
                return;
            }
            ArticleContentView.this.showArticleView();
            ArticleContentView.this.rendering.getOnLoadingUpdated$zendesk_ui_ui_android().invoke(ArticleContentState.ArticleLoadingStatus.SUCCESS);
        }

        public void onReceivedError(WebView view, WebResourceRequest request, WebResourceErrorCompat error) {
            Intrinsics.checkNotNullParameter(view, "view");
            Intrinsics.checkNotNullParameter(request, "request");
            Intrinsics.checkNotNullParameter(error, "error");
            ArticleContentView.this.showErrorView();
            ArticleContentView.this.rendering.getOnLoadingUpdated$zendesk_ui_ui_android().invoke(ArticleContentState.ArticleLoadingStatus.FAILED);
            super.onReceivedError(view, request, error);
        }
    }

    private final void setupWebViewClient() {
        NonScrollingWebView nonScrollingWebView = this.webView;
        if (nonScrollingWebView != null) {
            nonScrollingWebView.setWebChromeClient(new WebChromeClient());
        }
        NonScrollingWebView nonScrollingWebView2 = this.webView;
        if (nonScrollingWebView2 == null) {
            return;
        }
        nonScrollingWebView2.setWebViewClient((WebViewClient) new C15501());
    }

    private final void renderRetryErrorView() {
        this.retryErrorView.render(new Function1<RetryErrorRendering, RetryErrorRendering>() {
            {
                super(1);
            }

            @Override
            public final RetryErrorRendering invoke(RetryErrorRendering retryErrorRendering) {
                Intrinsics.checkNotNullParameter(retryErrorRendering, "retryErrorRendering");
                final String string = ArticleContentView.this.getContext().getString(R.string.zuia_guide_article_view_article_failed_to_load_label);
                Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
                RetryErrorRendering.Builder builder = retryErrorRendering.toBuilder();
                final ArticleContentView articleContentView = ArticleContentView.this;
                RetryErrorRendering.Builder builderState = builder.state(new Function1<RetryErrorState, RetryErrorState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final RetryErrorState invoke(RetryErrorState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        int textColor$zendesk_ui_ui_android = articleContentView.rendering.getState().getTextColor$zendesk_ui_ui_android();
                        String string2 = articleContentView.getContext().getString(R.string.zuia_guide_article_view_tap_to_retry_label);
                        int textColor$zendesk_ui_ui_android2 = articleContentView.rendering.getState().getTextColor$zendesk_ui_ui_android();
                        String str = string;
                        Intrinsics.checkNotNull(string2);
                        return state.copy(str, textColor$zendesk_ui_ui_android2, string2, textColor$zendesk_ui_ui_android);
                    }
                });
                final ArticleContentView articleContentView2 = ArticleContentView.this;
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
                        Unit unit;
                        if (articleContentView2.webView != null) {
                            ArticleContentView articleContentView3 = articleContentView2;
                            articleContentView3.rendering.getOnRetryButtonClicked$zendesk_ui_ui_android().invoke();
                            articleContentView3.showLoading();
                            unit = Unit.INSTANCE;
                        } else {
                            unit = null;
                        }
                        if (unit == null) {
                            ArticleContentView articleContentView4 = articleContentView2;
                            Logger.m219e("ArticleContentView", "Failed to render WebView", new Object[0]);
                            articleContentView4.showErrorView();
                            articleContentView4.rendering.getOnLoadingUpdated$zendesk_ui_ui_android().invoke(ArticleContentState.ArticleLoadingStatus.FAILED);
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
                final ArticleContentView articleContentView = ArticleContentView.this;
                return builder.state(new Function1<LoadingIndicatorState, LoadingIndicatorState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final LoadingIndicatorState invoke(LoadingIndicatorState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return state.copy(true, articleContentView.rendering.getState().getIndicatorColor$zendesk_ui_ui_android());
                    }
                }).build();
            }
        });
    }

    public final void showArticleView() {
        this.retryErrorView.setVisibility(8);
        this.loadingIndicatorView.setVisibility(8);
        this.scrollView.setVisibility(0);
        this.title.setVisibility(0);
        this.articleAttachmentCarousel.setVisibility(!this.rendering.getState().getAttachmentList$zendesk_ui_ui_android().isEmpty() ? 0 : 8);
        if (!this.rendering.getState().getAttachmentList$zendesk_ui_ui_android().isEmpty()) {
            this.articleAttachmentCarousel.setVisibility(0);
            ConstraintSet constraintSet = new ConstraintSet();
            constraintSet.clone(this.constraintLayout);
            constraintSet.connect(R.id.zuia_article_bottom_spacer, 3, R.id.zuia_article_attachment_carousel, 4);
            constraintSet.applyTo(this.constraintLayout);
            return;
        }
        this.articleAttachmentCarousel.setVisibility(8);
        ConstraintSet constraintSet2 = new ConstraintSet();
        constraintSet2.clone(this.constraintLayout);
        constraintSet2.connect(R.id.zuia_article_bottom_spacer, 3, R.id.zuia_article_webview_container, 4);
        constraintSet2.applyTo(this.constraintLayout);
    }

    public final void showLoading() {
        this.retryErrorView.setVisibility(8);
        this.scrollView.setVisibility(8);
        this.loadingIndicatorView.setVisibility(0);
    }

    public final void showErrorView() {
        this.loadingIndicatorView.setVisibility(8);
        this.scrollView.setVisibility(8);
        this.retryErrorView.setVisibility(0);
    }

    @Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0007X\u0086T¢\u0006\u0002\n\u0000¨\u0006\t"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentView$Companion;", "", "()V", "COMPLETED_LOADING", "", "REMOVE_ALPHA", "TYPE_TEXT_HTML", "", "UTF_8_ENCODING_TYPE", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
