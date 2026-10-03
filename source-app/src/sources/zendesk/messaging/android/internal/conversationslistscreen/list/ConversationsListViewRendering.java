package zendesk.messaging.android.internal.conversationslistscreen.list;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;

@Metadata(m17d1 = {"\u0000P\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u0001:\u0001\u001fB\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\u000f\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010\u001e\u001a\u00020\u0004R\u0014\u0010\u0006\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR$\u0010\n\u001a\u0012\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\r0\u000bj\u0002`\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u001e\u0010\u0011\u001a\f\u0012\u0004\u0012\u00020\r0\u0012j\u0002`\u0013X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R$\u0010\u0016\u001a\u0012\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\r0\u000bj\u0002`\u0018X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0010R\u0014\u0010\u001a\u001a\u00020\u001bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001d¨\u0006 "}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListViewRendering;", "", "()V", "builder", "Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListViewRendering$Builder;", "(Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListViewRendering$Builder;)V", "loadMoreStatus", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "getLoadMoreStatus$zendesk_messaging_messaging_android", "()Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "onListItemClickLambda", "Lkotlin/Function1;", "Lzendesk/core/ui/android/internal/model/ConversationEntry$ConversationItem;", "", "Lzendesk/messaging/android/internal/conversationslistscreen/list/OnListItemClickLambda;", "getOnListItemClickLambda$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function1;", "onLoadMoreListener", "Lkotlin/Function0;", "Lzendesk/messaging/android/internal/conversationslistscreen/list/OnLastItemScrolled;", "getOnLoadMoreListener$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function0;", "onRetryClickLambda", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMore;", "Lzendesk/messaging/android/internal/conversationslistscreen/list/OnRetryItemClickLambda;", "getOnRetryClickLambda$zendesk_messaging_messaging_android", "state", "Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListState;", "getState$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListState;", "toBuilder", "Builder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListViewRendering {
    private final ConversationEntry.LoadMoreStatus loadMoreStatus;
    private final Function1<ConversationEntry.ConversationItem, Unit> onListItemClickLambda;
    private final Function0<Unit> onLoadMoreListener;
    private final Function1<ConversationEntry.LoadMore, Unit> onRetryClickLambda;
    private final ConversationsListState state;

    public ConversationsListViewRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onListItemClickLambda = builder.getOnListItemClickLambda$zendesk_messaging_messaging_android();
        this.onRetryClickLambda = builder.getOnRetryItemClickLambda$zendesk_messaging_messaging_android();
        this.loadMoreStatus = builder.getLoadMoreStatus();
        this.onLoadMoreListener = builder.getOnLastItemScrolled$zendesk_messaging_messaging_android();
        this.state = builder.getState();
    }

    public final Function1<ConversationEntry.ConversationItem, Unit> getOnListItemClickLambda$zendesk_messaging_messaging_android() {
        return this.onListItemClickLambda;
    }

    public final Function1<ConversationEntry.LoadMore, Unit> getOnRetryClickLambda$zendesk_messaging_messaging_android() {
        return this.onRetryClickLambda;
    }

    public final ConversationEntry.LoadMoreStatus getLoadMoreStatus() {
        return this.loadMoreStatus;
    }

    public final Function0<Unit> getOnLoadMoreListener$zendesk_messaging_messaging_android() {
        return this.onLoadMoreListener;
    }

    public final ConversationsListState getState() {
        return this.state;
    }

    public ConversationsListViewRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\b\u0018\u00002\u00020\u0001B\u0011\b\u0010\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010'\u001a\u00020\u0003J\u0018\u0010(\u001a\u00020\u00002\u0010\u0010\f\u001a\f\u0012\u0004\u0012\u00020\u000e0\rj\u0002`\u000fJ\u001e\u0010\u0014\u001a\u00020\u00002\u0016\u0010\u0014\u001a\u0012\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u000e0\u0015j\u0002`\u0017J\u001e\u0010\u001c\u001a\u00020\u00002\u0016\u0010\u001c\u001a\u0012\u0012\u0004\u0012\u00020\u001d\u0012\u0004\u0012\u00020\u000e0\u0015j\u0002`\u001eJ\u001a\u0010!\u001a\u00020\u00002\u0012\u0010)\u001a\u000e\u0012\u0004\u0012\u00020\"\u0012\u0004\u0012\u00020\"0\u0015R\u001a\u0010\u0006\u001a\u00020\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000bR$\u0010\f\u001a\f\u0012\u0004\u0012\u00020\u000e0\rj\u0002`\u000fX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0010\u0010\u0011\"\u0004\b\u0012\u0010\u0013R*\u0010\u0014\u001a\u0012\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u000e0\u0015j\u0002`\u0017X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u0019\"\u0004\b\u001a\u0010\u001bR*\u0010\u001c\u001a\u0012\u0012\u0004\u0012\u00020\u001d\u0012\u0004\u0012\u00020\u000e0\u0015j\u0002`\u001eX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001f\u0010\u0019\"\u0004\b \u0010\u001bR\u001a\u0010!\u001a\u00020\"X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b#\u0010$\"\u0004\b%\u0010&¨\u0006*"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListViewRendering$Builder;", "", "rendering", "Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListViewRendering;", "(Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListViewRendering;)V", "()V", "loadMoreStatus", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "getLoadMoreStatus$zendesk_messaging_messaging_android", "()Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "setLoadMoreStatus$zendesk_messaging_messaging_android", "(Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;)V", "onLastItemScrolled", "Lkotlin/Function0;", "", "Lzendesk/messaging/android/internal/conversationslistscreen/list/OnLastItemScrolled;", "getOnLastItemScrolled$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function0;", "setOnLastItemScrolled$zendesk_messaging_messaging_android", "(Lkotlin/jvm/functions/Function0;)V", "onListItemClickLambda", "Lkotlin/Function1;", "Lzendesk/core/ui/android/internal/model/ConversationEntry$ConversationItem;", "Lzendesk/messaging/android/internal/conversationslistscreen/list/OnListItemClickLambda;", "getOnListItemClickLambda$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function1;", "setOnListItemClickLambda$zendesk_messaging_messaging_android", "(Lkotlin/jvm/functions/Function1;)V", "onRetryItemClickLambda", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMore;", "Lzendesk/messaging/android/internal/conversationslistscreen/list/OnRetryItemClickLambda;", "getOnRetryItemClickLambda$zendesk_messaging_messaging_android", "setOnRetryItemClickLambda$zendesk_messaging_messaging_android", "state", "Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListState;", "getState$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListState;", "setState$zendesk_messaging_messaging_android", "(Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListState;)V", "build", "loadMoreListener", "stateUpdate", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        private ConversationEntry.LoadMoreStatus loadMoreStatus;
        private Function0<Unit> onLastItemScrolled;
        private Function1<? super ConversationEntry.ConversationItem, Unit> onListItemClickLambda;
        private Function1<? super ConversationEntry.LoadMore, Unit> onRetryItemClickLambda;
        private ConversationsListState state;

        public Builder() {
            this.onListItemClickLambda = new Function1<ConversationEntry.ConversationItem, Unit>() {
                public final void invoke2(ConversationEntry.ConversationItem it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(ConversationEntry.ConversationItem conversationItem) {
                    invoke2(conversationItem);
                    return Unit.INSTANCE;
                }
            };
            this.onRetryItemClickLambda = new Function1<ConversationEntry.LoadMore, Unit>() {
                public final void invoke2(ConversationEntry.LoadMore it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(ConversationEntry.LoadMore loadMore) {
                    invoke2(loadMore);
                    return Unit.INSTANCE;
                }
            };
            this.loadMoreStatus = ConversationEntry.LoadMoreStatus.NONE;
            this.onLastItemScrolled = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.state = new ConversationsListState(null, null, null, 7, null);
        }

        public final Function1<ConversationEntry.ConversationItem, Unit> getOnListItemClickLambda$zendesk_messaging_messaging_android() {
            return this.onListItemClickLambda;
        }

        public final void setOnListItemClickLambda$zendesk_messaging_messaging_android(Function1<? super ConversationEntry.ConversationItem, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onListItemClickLambda = function1;
        }

        public final Function1<ConversationEntry.LoadMore, Unit> getOnRetryItemClickLambda$zendesk_messaging_messaging_android() {
            return this.onRetryItemClickLambda;
        }

        public final void setOnRetryItemClickLambda$zendesk_messaging_messaging_android(Function1<? super ConversationEntry.LoadMore, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onRetryItemClickLambda = function1;
        }

        public final ConversationEntry.LoadMoreStatus getLoadMoreStatus() {
            return this.loadMoreStatus;
        }

        public final void setLoadMoreStatus$zendesk_messaging_messaging_android(ConversationEntry.LoadMoreStatus loadMoreStatus) {
            Intrinsics.checkNotNullParameter(loadMoreStatus, "<set-?>");
            this.loadMoreStatus = loadMoreStatus;
        }

        public final Function0<Unit> getOnLastItemScrolled$zendesk_messaging_messaging_android() {
            return this.onLastItemScrolled;
        }

        public final void setOnLastItemScrolled$zendesk_messaging_messaging_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onLastItemScrolled = function0;
        }

        public final ConversationsListState getState() {
            return this.state;
        }

        public final void setState$zendesk_messaging_messaging_android(ConversationsListState conversationsListState) {
            Intrinsics.checkNotNullParameter(conversationsListState, "<set-?>");
            this.state = conversationsListState;
        }

        public Builder(ConversationsListViewRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.onListItemClickLambda = rendering.getOnListItemClickLambda$zendesk_messaging_messaging_android();
            this.onRetryItemClickLambda = rendering.getOnRetryClickLambda$zendesk_messaging_messaging_android();
            this.loadMoreStatus = rendering.getLoadMoreStatus();
            this.state = rendering.getState();
        }

        public Builder(ConversationsListViewRendering conversationsListViewRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new ConversationsListViewRendering() : conversationsListViewRendering);
        }

        public final Builder state(Function1<? super ConversationsListState, ConversationsListState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final Builder onListItemClickLambda(Function1<? super ConversationEntry.ConversationItem, Unit> onListItemClickLambda) {
            Intrinsics.checkNotNullParameter(onListItemClickLambda, "onListItemClickLambda");
            this.onListItemClickLambda = onListItemClickLambda;
            return this;
        }

        public final Builder onRetryItemClickLambda(Function1<? super ConversationEntry.LoadMore, Unit> onRetryItemClickLambda) {
            Intrinsics.checkNotNullParameter(onRetryItemClickLambda, "onRetryItemClickLambda");
            this.onRetryItemClickLambda = onRetryItemClickLambda;
            return this;
        }

        public final Builder loadMoreListener(Function0<Unit> onLastItemScrolled) {
            Intrinsics.checkNotNullParameter(onLastItemScrolled, "onLastItemScrolled");
            this.onLastItemScrolled = onLastItemScrolled;
            return this;
        }

        public final ConversationsListViewRendering build() {
            return new ConversationsListViewRendering(this);
        }
    }
}
