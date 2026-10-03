package zendesk.p026ui.android.conversation.articleviewer;

import android.content.Context;
import android.util.AttributeSet;
import android.view.ViewGroup;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.transition.Slide;
import androidx.transition.Transition;
import androidx.transition.TransitionManager;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.conversation.articleviewer.articlecontent.ArticleContentRendering;
import zendesk.p026ui.android.conversation.articleviewer.articlecontent.ArticleContentState;
import zendesk.p026ui.android.conversation.articleviewer.articlecontent.ArticleContentView;
import zendesk.p026ui.android.conversation.articleviewer.articleheader.ArticleHeaderRendering;
import zendesk.p026ui.android.conversation.articleviewer.articleheader.ArticleHeaderState;
import zendesk.p026ui.android.conversation.articleviewer.articleheader.ArticleHeaderView;
import zendesk.p026ui.android.conversation.articleviewer.feedbackbanner.ArticleFeedbackBannerRendering;
import zendesk.p026ui.android.conversation.articleviewer.feedbackbanner.ArticleFeedbackBannerState;
import zendesk.p026ui.android.conversation.articleviewer.feedbackbanner.ArticleFeedbackBannerView;
import zendesk.p026ui.android.conversation.quickreply.QuickReplyOption;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000Z\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\t\n\u0000\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u001c\u0010\u0013\u001a\u00020\u00142\u0012\u0010\u0015\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0016H\u0016J\b\u0010\u0017\u001a\u00020\u0014H\u0002J\b\u0010\u0018\u001a\u00020\u0014H\u0002J\b\u0010\u0019\u001a\u00020\u0014H\u0002J(\u0010\u001a\u001a\u00020\u0014*\u00020\u000f2\b\u0010\u001b\u001a\u0004\u0018\u00010\u001c2\u0006\u0010\u001d\u001a\u00020\u001e2\b\b\u0002\u0010\u001f\u001a\u00020 H\u0002R\u0010\u0010\f\u001a\u0004\u0018\u00010\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u000e\u001a\u0004\u0018\u00010\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0010\u001a\u0004\u0018\u00010\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006!"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/ArticleViewer;", "Landroidx/constraintlayout/widget/ConstraintLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/articleviewer/ArticleViewerRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "articleContent", "Lzendesk/ui/android/conversation/articleviewer/articlecontent/ArticleContentView;", "feedbackBanner", "Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerView;", "header", "Lzendesk/ui/android/conversation/articleviewer/articleheader/ArticleHeaderView;", "rendering", "render", "", "renderingUpdate", "Lkotlin/Function1;", "renderArticleContent", "renderArticleFeedbackBanner", "renderArticleHeader", "setBannerVisibility", "parent", "Landroid/view/ViewGroup;", "show", "", "duration", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleViewer extends ConstraintLayout implements Renderer<ArticleViewerRendering> {
    public static final int $stable = 8;
    private final ArticleContentView articleContent;
    private final ArticleFeedbackBannerView feedbackBanner;
    private final ArticleHeaderView header;
    private ArticleViewerRendering rendering;

    public ArticleViewer(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ArticleViewer(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ArticleViewer(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ArticleViewer(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public ArticleViewer(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ArticleViewerRendering();
        ConstraintLayout.inflate(context, R.layout.zuia_view_article_viewer, (ViewGroup) this);
        this.header = (ArticleHeaderView) findViewById(R.id.zuia_article_viewer_header);
        this.articleContent = (ArticleContentView) findViewById(R.id.zuia_article_viewer_content);
        this.feedbackBanner = (ArticleFeedbackBannerView) findViewById(R.id.zuia_article_viewer_feedback_banner);
    }

    public void render(Function1<? super ArticleViewerRendering, ArticleViewerRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        ArticleViewerRendering articleViewerRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = articleViewerRenderingInvoke;
        setBackgroundColor(articleViewerRenderingInvoke.getState().getBackgroundColor$zendesk_ui_ui_android());
        renderArticleHeader();
        renderArticleContent();
        if (this.rendering.getState().getShouldShowFeedbackBanner$zendesk_ui_ui_android()) {
            renderArticleFeedbackBanner();
            return;
        }
        ArticleFeedbackBannerView articleFeedbackBannerView = this.feedbackBanner;
        if (articleFeedbackBannerView == null) {
            return;
        }
        articleFeedbackBannerView.setVisibility(8);
    }

    private final void renderArticleFeedbackBanner() {
        ArticleFeedbackBannerView articleFeedbackBannerView = this.feedbackBanner;
        if (articleFeedbackBannerView != null) {
            articleFeedbackBannerView.render(new Function1<ArticleFeedbackBannerRendering, ArticleFeedbackBannerRendering>() {
                {
                    super(1);
                }

                @Override
                public final ArticleFeedbackBannerRendering invoke(ArticleFeedbackBannerRendering feedbackBannerRendering) {
                    Intrinsics.checkNotNullParameter(feedbackBannerRendering, "feedbackBannerRendering");
                    ArticleFeedbackBannerRendering.Builder builder = feedbackBannerRendering.toBuilder();
                    final ArticleViewer articleViewer = ArticleViewer.this;
                    ArticleFeedbackBannerRendering.Builder builderState = builder.state(new Function1<ArticleFeedbackBannerState, ArticleFeedbackBannerState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final ArticleFeedbackBannerState invoke(ArticleFeedbackBannerState state) {
                            Intrinsics.checkNotNullParameter(state, "state");
                            return state.copy(articleViewer.rendering.getState().getTextColor$zendesk_ui_ui_android(), articleViewer.rendering.getState().getBackgroundColor$zendesk_ui_ui_android(), articleViewer.rendering.getState().getButtonColor$zendesk_ui_ui_android(), articleViewer.rendering.getState().getFeedBackBannerOptions$zendesk_ui_ui_android());
                        }
                    });
                    final ArticleViewer articleViewer2 = ArticleViewer.this;
                    return builderState.onFeedbackBannerOptionClicked(new Function1<QuickReplyOption, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(QuickReplyOption quickReplyOption) {
                            invoke2(quickReplyOption);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(QuickReplyOption it) {
                            Intrinsics.checkNotNullParameter(it, "it");
                            articleViewer2.rendering.getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android().invoke(it);
                            ArticleViewer articleViewer3 = articleViewer2;
                            ArticleViewer.setBannerVisibility$default(articleViewer3, articleViewer3.feedbackBanner, (ViewGroup) articleViewer2, false, 0L, 4, null);
                        }
                    }).build();
                }
            });
        }
    }

    private final void renderArticleContent() {
        ArticleContentView articleContentView = this.articleContent;
        if (articleContentView != null) {
            articleContentView.render(new Function1<ArticleContentRendering, ArticleContentRendering>() {
                {
                    super(1);
                }

                @Override
                public final ArticleContentRendering invoke(ArticleContentRendering articleContentRendering) {
                    Intrinsics.checkNotNullParameter(articleContentRendering, "articleContentRendering");
                    ArticleContentRendering.Builder builder = articleContentRendering.toBuilder();
                    final ArticleViewer articleViewer = ArticleViewer.this;
                    ArticleContentRendering.Builder builderShouldOverrideUrl = builder.state(new Function1<ArticleContentState, ArticleContentState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final ArticleContentState invoke(ArticleContentState state) {
                            Intrinsics.checkNotNullParameter(state, "state");
                            return state.copy(articleViewer.rendering.getState().getArticleData$zendesk_ui_ui_android(), articleViewer.rendering.getState().getTextColor$zendesk_ui_ui_android(), articleViewer.rendering.getState().getBackgroundColor$zendesk_ui_ui_android(), articleViewer.rendering.getState().getIndicatorColor$zendesk_ui_ui_android(), articleViewer.rendering.getState().getContentState$zendesk_ui_ui_android(), articleViewer.rendering.getState().getAttachmentList$zendesk_ui_ui_android(), articleViewer.rendering.getState().getAttachmentListTextColor(), articleViewer.rendering.getState().getNavigationButtonBackgroundColor(), articleViewer.rendering.getState().getFocusedStateBorderColor());
                        }
                    }).shouldOverrideUrl(ArticleViewer.this.rendering.getShouldOverrideUrl$zendesk_ui_ui_android());
                    final ArticleViewer articleViewer2 = ArticleViewer.this;
                    return builderShouldOverrideUrl.onLoadingUpdated(new Function1<ArticleContentState.ArticleLoadingStatus, Unit>() {

                        @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                        public class WhenMappings {
                            public static final int[] $EnumSwitchMapping$0;

                            static {
                                int[] iArr = new int[ArticleContentState.ArticleLoadingStatus.values().length];
                                try {
                                    iArr[ArticleContentState.ArticleLoadingStatus.SUCCESS.ordinal()] = 1;
                                } catch (NoSuchFieldError unused) {
                                }
                                try {
                                    iArr[ArticleContentState.ArticleLoadingStatus.FAILED.ordinal()] = 2;
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

                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(ArticleContentState.ArticleLoadingStatus articleLoadingStatus) {
                            invoke2(articleLoadingStatus);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(ArticleContentState.ArticleLoadingStatus status) {
                            ArticleFeedbackBannerView articleFeedbackBannerView;
                            Intrinsics.checkNotNullParameter(status, "status");
                            if (WhenMappings.$EnumSwitchMapping$0[status.ordinal()] == 1 && (articleFeedbackBannerView = articleViewer2.feedbackBanner) != null) {
                                ArticleViewer articleViewer3 = articleViewer2;
                                ArticleViewer.setBannerVisibility$default(articleViewer3, articleFeedbackBannerView, (ViewGroup) articleViewer3, articleViewer3.rendering.getState().getShouldShowFeedbackBanner$zendesk_ui_ui_android(), 0L, 4, null);
                            }
                        }
                    }).onRetryButtonClicked(ArticleViewer.this.rendering.getOnRetryButtonClicked$zendesk_ui_ui_android()).onAttachmentItemClicked(ArticleViewer.this.rendering.getOnAttachmentItemClicked$zendesk_ui_ui_android()).build();
                }
            });
        }
    }

    private final void renderArticleHeader() {
        ArticleHeaderView articleHeaderView = this.header;
        if (articleHeaderView != null) {
            articleHeaderView.render(new Function1<ArticleHeaderRendering, ArticleHeaderRendering>() {
                {
                    super(1);
                }

                @Override
                public final ArticleHeaderRendering invoke(ArticleHeaderRendering headerRendering) {
                    Intrinsics.checkNotNullParameter(headerRendering, "headerRendering");
                    ArticleHeaderRendering.Builder builder = headerRendering.toBuilder();
                    final ArticleViewer articleViewer = ArticleViewer.this;
                    return builder.state(new Function1<ArticleHeaderState, ArticleHeaderState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final ArticleHeaderState invoke(ArticleHeaderState state) {
                            Intrinsics.checkNotNullParameter(state, "state");
                            boolean showShareButton$zendesk_ui_ui_android = articleViewer.rendering.getState().getShowShareButton$zendesk_ui_ui_android();
                            boolean showBackButton$zendesk_ui_ui_android = articleViewer.rendering.getState().getShowBackButton$zendesk_ui_ui_android();
                            return ArticleHeaderState.copy$default(state, articleViewer.rendering.getState().getBackgroundColor$zendesk_ui_ui_android(), articleViewer.rendering.getState().getButtonBackgroundColor$zendesk_ui_ui_android(), articleViewer.rendering.getState().getIconColor$zendesk_ui_ui_android(), 0, showShareButton$zendesk_ui_ui_android, showBackButton$zendesk_ui_ui_android, 8, null);
                        }
                    }).onMenuItemClicked(ArticleViewer.this.rendering.getOnMenuItemClicked$zendesk_ui_ui_android()).build();
                }
            });
        }
    }

    static void setBannerVisibility$default(ArticleViewer articleViewer, ArticleFeedbackBannerView articleFeedbackBannerView, ViewGroup viewGroup, boolean z, long j, int i, Object obj) {
        if ((i & 4) != 0) {
            j = 600;
        }
        articleViewer.setBannerVisibility(articleFeedbackBannerView, viewGroup, z, j);
    }

    private final void setBannerVisibility(ArticleFeedbackBannerView articleFeedbackBannerView, ViewGroup viewGroup, boolean z, long j) {
        Transition slide = new Slide(80);
        slide.setDuration(j);
        ArticleFeedbackBannerView articleFeedbackBannerView2 = articleFeedbackBannerView;
        slide.addTarget(articleFeedbackBannerView2);
        if (viewGroup != null) {
            TransitionManager.beginDelayedTransition(viewGroup, slide);
        }
        articleFeedbackBannerView2.setVisibility(z ? 0 : 8);
    }
}
