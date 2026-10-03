package zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0007\u0018\u00002\u00020\u0001:\u0001\u0012B\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0011\u001a\u00020\u0004R(\u0010\u0006\u001a\u0016\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t\u0018\u00010\u0007j\u0004\u0018\u0001`\nX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\r\u001a\u00020\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselRendering;", "", "()V", "builder", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselRendering$Builder;", "(Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselRendering$Builder;)V", "onAttachmentItemClicked", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/OnAttachmentItemClicked;", "getOnAttachmentItemClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "state", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselCellState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselCellState;", "toBuilder", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleAttachmentCarouselRendering {
    public static final int $stable = 8;
    private final Function1<ArticleAttachmentItem, Unit> onAttachmentItemClicked;
    private final ArticleAttachmentCarouselCellState state;

    public ArticleAttachmentCarouselRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onAttachmentItemClicked = builder.getOnAttachmentItemClicked$zendesk_ui_ui_android();
        this.state = builder.getState();
    }

    public final Function1<ArticleAttachmentItem, Unit> getOnAttachmentItemClicked$zendesk_ui_ui_android() {
        return this.onAttachmentItemClicked;
    }

    public final ArticleAttachmentCarouselCellState getState() {
        return this.state;
    }

    public ArticleAttachmentCarouselRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0015\u001a\u00020\u0003J\"\u0010\u0006\u001a\u00020\u00002\u001a\u0010\u0006\u001a\u0016\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t\u0018\u00010\u0007j\u0004\u0018\u0001`\nJ\u001a\u0010\u000f\u001a\u00020\u00002\u0012\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u00100\u0007R.\u0010\u0006\u001a\u0016\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\t\u0018\u00010\u0007j\u0004\u0018\u0001`\nX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR\u001a\u0010\u000f\u001a\u00020\u0010X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\u0012\"\u0004\b\u0013\u0010\u0014¨\u0006\u0017"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselRendering$Builder;", "", "rendering", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselRendering;", "(Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselRendering;)V", "()V", "onAttachmentItemClicked", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/OnAttachmentItemClicked;", "getOnAttachmentItemClicked$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "setOnAttachmentItemClicked$zendesk_ui_ui_android", "(Lkotlin/jvm/functions/Function1;)V", "state", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselCellState;", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselCellState;", "setState$zendesk_ui_ui_android", "(Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentCarouselCellState;)V", "build", "stateUpdate", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private Function1<? super ArticleAttachmentItem, Unit> onAttachmentItemClicked;
        private ArticleAttachmentCarouselCellState state;

        public Builder() {
            this.state = new ArticleAttachmentCarouselCellState(null, 0, 0, 0, 15, null);
        }

        public final Function1<ArticleAttachmentItem, Unit> getOnAttachmentItemClicked$zendesk_ui_ui_android() {
            return this.onAttachmentItemClicked;
        }

        public final void setOnAttachmentItemClicked$zendesk_ui_ui_android(Function1<? super ArticleAttachmentItem, Unit> function1) {
            this.onAttachmentItemClicked = function1;
        }

        public final ArticleAttachmentCarouselCellState getState() {
            return this.state;
        }

        public final void setState$zendesk_ui_ui_android(ArticleAttachmentCarouselCellState articleAttachmentCarouselCellState) {
            Intrinsics.checkNotNullParameter(articleAttachmentCarouselCellState, "<set-?>");
            this.state = articleAttachmentCarouselCellState;
        }

        public Builder(ArticleAttachmentCarouselRendering articleAttachmentCarouselRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new ArticleAttachmentCarouselRendering() : articleAttachmentCarouselRendering);
        }

        public Builder(ArticleAttachmentCarouselRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.onAttachmentItemClicked = rendering.getOnAttachmentItemClicked$zendesk_ui_ui_android();
            this.state = rendering.getState();
        }

        public final Builder onAttachmentItemClicked(Function1<? super ArticleAttachmentItem, Unit> onAttachmentItemClicked) {
            this.onAttachmentItemClicked = onAttachmentItemClicked;
            return this;
        }

        public final Builder state(Function1<? super ArticleAttachmentCarouselCellState, ArticleAttachmentCarouselCellState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final ArticleAttachmentCarouselRendering build() {
            return new ArticleAttachmentCarouselRendering(this);
        }
    }
}
