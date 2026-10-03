package zendesk.p026ui.android.conversation.articleviewer;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import okhttp3.internal.http2.Settings;
import zendesk.logger.Logger;
import zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel.ArticleAttachmentItem;
import zendesk.p026ui.android.conversation.articleviewer.articleheader.ArticleHeaderState;
import zendesk.p026ui.android.conversation.quickreply.QuickReplyOption;

@Metadata(m17d1 = {"\u0000Z\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u0000 &2\u00020\u0001:\u0002%&B\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010$\u001a\u00020\u0004R/\u0010\u0006\u001a\u001d\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0004\u0012\u00020\f0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR/\u0010\u000f\u001a\u001d\u0012\u0013\u0012\u00110\u0010¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0011\u0012\u0004\u0012\u00020\f0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u000eR/\u0010\u0013\u001a\u001d\u0012\u0013\u0012\u00110\u0014¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0015\u0012\u0004\u0012\u00020\f0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u000eR\u001a\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\f0\u0018X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR1\u0010\u001b\u001a\u001f\u0012\u0015\u0012\u0013\u0018\u00010\u001c¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u001d\u0012\u0004\u0012\u00020\u001e0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u000eR\u0014\u0010 \u001a\u00020!X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010#¨\u0006'"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/ArticleViewerRendering;", "", "()V", "builder", "Lzendesk/ui/android/conversation/articleviewer/ArticleViewerRendering$Builder;", "(Lzendesk/ui/android/conversation/articleviewer/ArticleViewerRendering$Builder;)V", "onAttachmentItemClicked", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "Lkotlin/ParameterName;", "name", "attachmentItem", "", "getOnAttachmentItemClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "onFeedbackBannerOptionClicked", "Lzendesk/ui/android/conversation/quickreply/QuickReplyOption;", "optionSelected", "getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android", "onMenuItemClicked", "Lzendesk/ui/android/conversation/articleviewer/articleheader/ArticleHeaderState$ButtonName;", "itemClicked", "getOnMenuItemClicked$zendesk_ui_ui_android", "onRetryButtonClicked", "Lkotlin/Function0;", "getOnRetryButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "shouldOverrideUrl", "", "url", "", "getShouldOverrideUrl$zendesk_ui_ui_android", "state", "Lzendesk/ui/android/conversation/articleviewer/ArticleViewerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/articleviewer/ArticleViewerState;", "toBuilder", "Builder", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleViewerRendering {
    private static final String LOG_TAG = "ArticleViewerRendering";
    private final Function1<ArticleAttachmentItem, Unit> onAttachmentItemClicked;
    private final Function1<QuickReplyOption, Unit> onFeedbackBannerOptionClicked;
    private final Function1<ArticleHeaderState.ButtonName, Unit> onMenuItemClicked;
    private final Function0<Unit> onRetryButtonClicked;
    private final Function1<String, Boolean> shouldOverrideUrl;
    private final ArticleViewerState state;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    public ArticleViewerRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onFeedbackBannerOptionClicked = builder.getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android();
        this.onMenuItemClicked = builder.getOnMenuItemClicked$zendesk_ui_ui_android();
        this.shouldOverrideUrl = builder.getShouldOverrideUrl$zendesk_ui_ui_android();
        this.onRetryButtonClicked = builder.getOnRetryButtonClicked$zendesk_ui_ui_android();
        this.onAttachmentItemClicked = builder.getOnAttachmentItemClicked$zendesk_ui_ui_android();
        this.state = builder.getState();
    }

    public final Function1<QuickReplyOption, Unit> getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android() {
        return this.onFeedbackBannerOptionClicked;
    }

    public final Function1<ArticleHeaderState.ButtonName, Unit> getOnMenuItemClicked$zendesk_ui_ui_android() {
        return this.onMenuItemClicked;
    }

    public final Function1<String, Boolean> getShouldOverrideUrl$zendesk_ui_ui_android() {
        return this.shouldOverrideUrl;
    }

    public final Function0<Unit> getOnRetryButtonClicked$zendesk_ui_ui_android() {
        return this.onRetryButtonClicked;
    }

    public final Function1<ArticleAttachmentItem, Unit> getOnAttachmentItemClicked$zendesk_ui_ui_android() {
        return this.onAttachmentItemClicked;
    }

    public final ArticleViewerState getState() {
        return this.state;
    }

    public ArticleViewerRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000X\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010-\u001a\u00020\u0003J)\u0010\u0006\u001a\u00020\u00002!\u0010\u0006\u001a\u001d\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0004\u0012\u00020\f0\u0007J)\u0010\u0011\u001a\u00020\u00002!\u0010\u0011\u001a\u001d\u0012\u0013\u0012\u00110\u0012¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0013\u0012\u0004\u0012\u00020\f0\u0007J)\u0010\u0016\u001a\u00020\u00002!\u0010\u0016\u001a\u001d\u0012\u0013\u0012\u00110\u0017¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0018\u0012\u0004\u0012\u00020\f0\u0007J\u0014\u0010\u001b\u001a\u00020\u00002\f\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\f0\u001cJ+\u0010!\u001a\u00020\u00002#\u0010!\u001a\u001f\u0012\u0015\u0012\u0013\u0018\u00010\"¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(#\u0012\u0004\u0012\u00020$0\u0007J\u001a\u0010'\u001a\u00020\u00002\u0012\u0010.\u001a\u000e\u0012\u0004\u0012\u00020(\u0012\u0004\u0012\u00020(0\u0007R5\u0010\u0006\u001a\u001d\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0004\u0012\u00020\f0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R5\u0010\u0011\u001a\u001d\u0012\u0013\u0012\u00110\u0012¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0013\u0012\u0004\u0012\u00020\f0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\u000e\"\u0004\b\u0015\u0010\u0010R5\u0010\u0016\u001a\u001d\u0012\u0013\u0012\u00110\u0017¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0018\u0012\u0004\u0012\u00020\f0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0019\u0010\u000e\"\u0004\b\u001a\u0010\u0010R \u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\f0\u001cX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001d\u0010\u001e\"\u0004\b\u001f\u0010 R7\u0010!\u001a\u001f\u0012\u0015\u0012\u0013\u0018\u00010\"¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(#\u0012\u0004\u0012\u00020$0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b%\u0010\u000e\"\u0004\b&\u0010\u0010R\u001a\u0010'\u001a\u00020(X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b)\u0010*\"\u0004\b+\u0010,¨\u0006/"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/ArticleViewerRendering$Builder;", "", "rendering", "Lzendesk/ui/android/conversation/articleviewer/ArticleViewerRendering;", "(Lzendesk/ui/android/conversation/articleviewer/ArticleViewerRendering;)V", "()V", "onAttachmentItemClicked", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "Lkotlin/ParameterName;", "name", "attachmentItem", "", "getOnAttachmentItemClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "setOnAttachmentItemClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function1;)V", "onFeedbackBannerOptionClicked", "Lzendesk/ui/android/conversation/quickreply/QuickReplyOption;", "optionSelected", "getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android", "setOnFeedbackBannerOptionClicked$zendesk_ui_ui_android", "onMenuItemClicked", "Lzendesk/ui/android/conversation/articleviewer/articleheader/ArticleHeaderState$ButtonName;", "itemClicked", "getOnMenuItemClicked$zendesk_ui_ui_android", "setOnMenuItemClicked$zendesk_ui_ui_android", "onRetryButtonClicked", "Lkotlin/Function0;", "getOnRetryButtonClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function0;", "setOnRetryButtonClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function0;)V", "shouldOverrideUrl", "", "url", "", "getShouldOverrideUrl$zendesk_ui_ui_android", "setShouldOverrideUrl$zendesk_ui_ui_android", "state", "Lzendesk/ui/android/conversation/articleviewer/ArticleViewerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/articleviewer/ArticleViewerState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/conversation/articleviewer/ArticleViewerState;)V", "build", "stateUpdate", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private Function1<? super ArticleAttachmentItem, Unit> onAttachmentItemClicked;
        private Function1<? super QuickReplyOption, Unit> onFeedbackBannerOptionClicked;
        private Function1<? super ArticleHeaderState.ButtonName, Unit> onMenuItemClicked;
        private Function0<Unit> onRetryButtonClicked;
        private Function1<? super String, Boolean> shouldOverrideUrl;
        private ArticleViewerState state;

        public Builder() {
            this.onFeedbackBannerOptionClicked = new Function1<QuickReplyOption, Unit>() {
                @Override
                public Unit invoke(QuickReplyOption quickReplyOption) {
                    invoke2(quickReplyOption);
                    return Unit.INSTANCE;
                }

                public final void invoke2(QuickReplyOption it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    Logger.m225w("ArticleViewerRendering", "FeedbackBannerOptionClicked == null", new Object[0]);
                }
            };
            this.onMenuItemClicked = new Function1<ArticleHeaderState.ButtonName, Unit>() {
                @Override
                public Unit invoke(ArticleHeaderState.ButtonName buttonName) {
                    invoke2(buttonName);
                    return Unit.INSTANCE;
                }

                public final void invoke2(ArticleHeaderState.ButtonName it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    Logger.m225w("ArticleViewerRendering", "onMenuItemClicked == null", new Object[0]);
                }
            };
            this.shouldOverrideUrl = new Function1<String, Boolean>() {
                @Override
                public final Boolean invoke(String str) {
                    Logger.m225w("ArticleViewerRendering", "shouldOverrideUrl == null", new Object[0]);
                    return false;
                }
            };
            this.onRetryButtonClicked = new Function0<Unit>() {
                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    Logger.m225w("ArticleViewerRendering", "onRetryButtonClicked == null", new Object[0]);
                }
            };
            this.onAttachmentItemClicked = new Function1<ArticleAttachmentItem, Unit>() {
                @Override
                public Unit invoke(ArticleAttachmentItem articleAttachmentItem) {
                    invoke2(articleAttachmentItem);
                    return Unit.INSTANCE;
                }

                public final void invoke2(ArticleAttachmentItem it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    Logger.m225w("ArticleViewerRendering", "onAttachmentItemClicked == null", new Object[0]);
                }
            };
            this.state = new ArticleViewerState(null, null, 0, 0, 0, 0, 0, 0, false, false, null, 0, 0, 0, null, false, Settings.DEFAULT_INITIAL_WINDOW_SIZE, null);
        }

        public final Function1<QuickReplyOption, Unit> getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android() {
            return this.onFeedbackBannerOptionClicked;
        }

        public final void setOnFeedbackBannerOptionClicked$zendesk_ui_ui_android(Function1<? super QuickReplyOption, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onFeedbackBannerOptionClicked = function1;
        }

        public final Function1<ArticleHeaderState.ButtonName, Unit> getOnMenuItemClicked$zendesk_ui_ui_android() {
            return this.onMenuItemClicked;
        }

        public final void setOnMenuItemClicked$zendesk_ui_ui_android(Function1<? super ArticleHeaderState.ButtonName, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onMenuItemClicked = function1;
        }

        public final Function1<String, Boolean> getShouldOverrideUrl$zendesk_ui_ui_android() {
            return this.shouldOverrideUrl;
        }

        public final void setShouldOverrideUrl$zendesk_ui_ui_android(Function1<? super String, Boolean> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.shouldOverrideUrl = function1;
        }

        public final Function0<Unit> getOnRetryButtonClicked$zendesk_ui_ui_android() {
            return this.onRetryButtonClicked;
        }

        public final void setOnRetryButtonClicked$zendesk_ui_ui_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onRetryButtonClicked = function0;
        }

        public final Function1<ArticleAttachmentItem, Unit> getOnAttachmentItemClicked$zendesk_ui_ui_android() {
            return this.onAttachmentItemClicked;
        }

        public final void setOnAttachmentItemClicked$zendesk_ui_ui_android(Function1<? super ArticleAttachmentItem, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onAttachmentItemClicked = function1;
        }

        public final ArticleViewerState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(ArticleViewerState articleViewerState) {
            Intrinsics.checkNotNullParameter(articleViewerState, "<set-?>");
            this.state = articleViewerState;
        }

        public Builder(ArticleViewerRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.onFeedbackBannerOptionClicked = rendering.getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android();
            this.shouldOverrideUrl = rendering.getShouldOverrideUrl$zendesk_ui_ui_android();
            this.state = rendering.getState();
        }

        public Builder(ArticleViewerRendering articleViewerRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new ArticleViewerRendering() : articleViewerRendering);
        }

        public final Builder onFeedbackBannerOptionClicked(Function1<? super QuickReplyOption, Unit> onFeedbackBannerOptionClicked) {
            Intrinsics.checkNotNullParameter(onFeedbackBannerOptionClicked, "onFeedbackBannerOptionClicked");
            this.onFeedbackBannerOptionClicked = onFeedbackBannerOptionClicked;
            return this;
        }

        public final Builder onMenuItemClicked(Function1<? super ArticleHeaderState.ButtonName, Unit> onMenuItemClicked) {
            Intrinsics.checkNotNullParameter(onMenuItemClicked, "onMenuItemClicked");
            this.onMenuItemClicked = onMenuItemClicked;
            return this;
        }

        public final Builder shouldOverrideUrl(Function1<? super String, Boolean> shouldOverrideUrl) {
            Intrinsics.checkNotNullParameter(shouldOverrideUrl, "shouldOverrideUrl");
            this.shouldOverrideUrl = shouldOverrideUrl;
            return this;
        }

        public final Builder onRetryButtonClicked(Function0<Unit> onRetryButtonClicked) {
            Intrinsics.checkNotNullParameter(onRetryButtonClicked, "onRetryButtonClicked");
            this.onRetryButtonClicked = onRetryButtonClicked;
            return this;
        }

        public final Builder onAttachmentItemClicked(Function1<? super ArticleAttachmentItem, Unit> onAttachmentItemClicked) {
            Intrinsics.checkNotNullParameter(onAttachmentItemClicked, "onAttachmentItemClicked");
            this.onAttachmentItemClicked = onAttachmentItemClicked;
            return this;
        }

        public final Builder state(Function1<? super ArticleViewerState, ArticleViewerState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final ArticleViewerRendering build() {
            return new ArticleViewerRendering(this);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/ArticleViewerRendering$Companion;", "", "()V", "LOG_TAG", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
