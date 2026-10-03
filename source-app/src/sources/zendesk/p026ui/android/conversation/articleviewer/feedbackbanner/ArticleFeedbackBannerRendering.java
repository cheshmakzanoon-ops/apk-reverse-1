package zendesk.p026ui.android.conversation.articleviewer.feedbackbanner;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;
import zendesk.p026ui.android.conversation.quickreply.QuickReplyOption;

@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u0000 \u00152\u00020\u0001:\u0002\u0014\u0015B\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0013\u001a\u00020\u0004R/\u0010\u0006\u001a\u001d\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0004\u0012\u00020\f0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u000f\u001a\u00020\u0010X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012¨\u0006\u0016"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerRendering;", "", "()V", "builder", "Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerRendering$Builder;", "(Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerRendering$Builder;)V", "onFeedbackBannerOptionClicked", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/quickreply/QuickReplyOption;", "Lkotlin/ParameterName;", "name", "optionSelected", "", "getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "state", "Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerState;", "toBuilder", "Builder", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleFeedbackBannerRendering {
    private static final String LOG_TAG = "ArticleFeedbackBannerRendering";
    private final Function1<QuickReplyOption, Unit> onFeedbackBannerOptionClicked;
    private final ArticleFeedbackBannerState state;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    public ArticleFeedbackBannerRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onFeedbackBannerOptionClicked = builder.getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android();
        this.state = builder.getState();
    }

    public final Function1<QuickReplyOption, Unit> getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android() {
        return this.onFeedbackBannerOptionClicked;
    }

    public final ArticleFeedbackBannerState getState() {
        return this.state;
    }

    public ArticleFeedbackBannerRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0017\u001a\u00020\u0003J)\u0010\u0006\u001a\u00020\u00002!\u0010\u0006\u001a\u001d\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0004\u0012\u00020\f0\u0007J\u001a\u0010\u0011\u001a\u00020\u00002\u0012\u0010\u0018\u001a\u000e\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020\u00120\u0007R5\u0010\u0006\u001a\u001d\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0004\u0012\u00020\f0\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R\u001a\u0010\u0011\u001a\u00020\u0012X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0013\u0010\u0014\"\u0004\b\u0015\u0010\u0016¨\u0006\u0019"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerRendering$Builder;", "", "rendering", "Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerRendering;", "(Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerRendering;)V", "()V", "onFeedbackBannerOptionClicked", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/quickreply/QuickReplyOption;", "Lkotlin/ParameterName;", "name", "optionSelected", "", "getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "setOnFeedbackBannerOptionClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function1;)V", "state", "Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerState;)V", "build", "stateUpdate", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private Function1<? super QuickReplyOption, Unit> onFeedbackBannerOptionClicked;
        private ArticleFeedbackBannerState state;

        public Builder() {
            this.onFeedbackBannerOptionClicked = new Function1<QuickReplyOption, Unit>() {
                @Override
                public Unit invoke(QuickReplyOption quickReplyOption) {
                    invoke2(quickReplyOption);
                    return Unit.INSTANCE;
                }

                public final void invoke2(QuickReplyOption it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    Logger.m225w("ArticleFeedbackBannerRendering", "FeedbackBannerOptionClicked == null", new Object[0]);
                }
            };
            this.state = new ArticleFeedbackBannerState(0, 0, 0, null, 15, null);
        }

        public final Function1<QuickReplyOption, Unit> getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android() {
            return this.onFeedbackBannerOptionClicked;
        }

        public final void setOnFeedbackBannerOptionClicked$zendesk_ui_ui_android(Function1<? super QuickReplyOption, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onFeedbackBannerOptionClicked = function1;
        }

        public final ArticleFeedbackBannerState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(ArticleFeedbackBannerState articleFeedbackBannerState) {
            Intrinsics.checkNotNullParameter(articleFeedbackBannerState, "<set-?>");
            this.state = articleFeedbackBannerState;
        }

        public Builder(ArticleFeedbackBannerRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.onFeedbackBannerOptionClicked = rendering.getOnFeedbackBannerOptionClicked$zendesk_ui_ui_android();
            this.state = rendering.getState();
        }

        public Builder(ArticleFeedbackBannerRendering articleFeedbackBannerRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new ArticleFeedbackBannerRendering() : articleFeedbackBannerRendering);
        }

        public final Builder onFeedbackBannerOptionClicked(Function1<? super QuickReplyOption, Unit> onFeedbackBannerOptionClicked) {
            Intrinsics.checkNotNullParameter(onFeedbackBannerOptionClicked, "onFeedbackBannerOptionClicked");
            this.onFeedbackBannerOptionClicked = onFeedbackBannerOptionClicked;
            return this;
        }

        public final Builder state(Function1<? super ArticleFeedbackBannerState, ArticleFeedbackBannerState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final ArticleFeedbackBannerRendering build() {
            return new ArticleFeedbackBannerRendering(this);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/feedbackbanner/ArticleFeedbackBannerRendering$Companion;", "", "()V", "LOG_TAG", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
