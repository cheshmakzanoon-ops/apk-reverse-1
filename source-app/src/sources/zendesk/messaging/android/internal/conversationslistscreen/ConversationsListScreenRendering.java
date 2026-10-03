package zendesk.messaging.android.internal.conversationslistscreen;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;

@Metadata(m17d1 = {"\u0000X\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u0001:\u0001'B\u0007\b\u0016¢\u0006\u0002\u0010\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0006\u0010&\u001a\u00020\u0004R\u001e\u0010\u0006\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u001e\u0010\f\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000bR\u001e\u0010\u000e\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000bR$\u0010\u0010\u001a\u0012\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020\b0\u0011j\u0002`\u0013X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u001e\u0010\u0016\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\u0017X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u000bR\u001e\u0010\u0019\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u000bR$\u0010\u001b\u001a\u0012\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\b0\u0011j\u0002`\u001dX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u0015R\u001e\u0010\u001f\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002` X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\u000bR\u0014\u0010\"\u001a\u00020#X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b$\u0010%¨\u0006("}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenRendering;", "", "()V", "builder", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenRendering$Builder;", "(Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenRendering$Builder;)V", "onBackButtonClicked", "Lkotlin/Function0;", "", "Lzendesk/messaging/android/internal/conversationslistscreen/OnClickLambda;", "getOnBackButtonClicked$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function0;", "onCreateConvoButtonClicked", "getOnCreateConvoButtonClicked$zendesk_messaging_messaging_android", "onDismissCreateConversationError", "getOnDismissCreateConversationError$zendesk_messaging_messaging_android", "onListItemClickLambda", "Lkotlin/Function1;", "Lzendesk/core/ui/android/internal/model/ConversationEntry$ConversationItem;", "Lzendesk/messaging/android/internal/conversationslistscreen/OnListItemClickLambda;", "getOnListItemClickLambda$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function1;", "onMessageReceivedAuthorAnnounced", "Lzendesk/messaging/android/internal/conversationslistscreen/OnEventLambda;", "getOnMessageReceivedAuthorAnnounced$zendesk_messaging_messaging_android", "onRetryButtonClicked", "getOnRetryButtonClicked$zendesk_messaging_messaging_android", "onRetryPaginationClick", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMore;", "Lzendesk/messaging/android/internal/conversationslistscreen/OnRetryPaginationClickLambda;", "getOnRetryPaginationClick$zendesk_messaging_messaging_android", "onStartPagingLambda", "Lzendesk/messaging/android/internal/conversationslistscreen/OnStartPagingLambda;", "getOnStartPagingLambda$zendesk_messaging_messaging_android", "state", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;", "getState$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;", "toBuilder", "Builder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListScreenRendering {
    private final Function0<Unit> onBackButtonClicked;
    private final Function0<Unit> onCreateConvoButtonClicked;
    private final Function0<Unit> onDismissCreateConversationError;
    private final Function1<ConversationEntry.ConversationItem, Unit> onListItemClickLambda;
    private final Function0<Unit> onMessageReceivedAuthorAnnounced;
    private final Function0<Unit> onRetryButtonClicked;
    private final Function1<ConversationEntry.LoadMore, Unit> onRetryPaginationClick;
    private final Function0<Unit> onStartPagingLambda;
    private final ConversationsListScreenState state;

    public ConversationsListScreenRendering(Builder builder) {
        Intrinsics.checkNotNullParameter(builder, "builder");
        this.onBackButtonClicked = builder.getOnBackButtonClicked$zendesk_messaging_messaging_android();
        this.onCreateConvoButtonClicked = builder.m272xaab7ad3d();
        this.onListItemClickLambda = builder.getOnListItemClickLambda$zendesk_messaging_messaging_android();
        this.onRetryButtonClicked = builder.getOnRetryButtonClicked$zendesk_messaging_messaging_android();
        this.onRetryPaginationClick = builder.getOnRetryPaginationClicked$zendesk_messaging_messaging_android();
        this.onMessageReceivedAuthorAnnounced = builder.m274x6ade096f();
        this.onStartPagingLambda = builder.getOnStartPagingLambda$zendesk_messaging_messaging_android();
        this.onDismissCreateConversationError = builder.m273xbb9b9606();
        this.state = builder.getState();
    }

    public final Function0<Unit> getOnBackButtonClicked$zendesk_messaging_messaging_android() {
        return this.onBackButtonClicked;
    }

    public final Function0<Unit> m269xaab7ad3d() {
        return this.onCreateConvoButtonClicked;
    }

    public final Function1<ConversationEntry.ConversationItem, Unit> getOnListItemClickLambda$zendesk_messaging_messaging_android() {
        return this.onListItemClickLambda;
    }

    public final Function0<Unit> getOnRetryButtonClicked$zendesk_messaging_messaging_android() {
        return this.onRetryButtonClicked;
    }

    public final Function1<ConversationEntry.LoadMore, Unit> getOnRetryPaginationClick$zendesk_messaging_messaging_android() {
        return this.onRetryPaginationClick;
    }

    public final Function0<Unit> m271x6ade096f() {
        return this.onMessageReceivedAuthorAnnounced;
    }

    public final Function0<Unit> getOnStartPagingLambda$zendesk_messaging_messaging_android() {
        return this.onStartPagingLambda;
    }

    public final Function0<Unit> m270xbb9b9606() {
        return this.onDismissCreateConversationError;
    }

    public final ConversationsListScreenState getState() {
        return this.state;
    }

    public ConversationsListScreenRendering() {
        this(new Builder());
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\f\u0018\u00002\u00020\u0001B\u0011\b\u0016\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u00102\u001a\u00020\u0003J\u0018\u0010\u0006\u001a\u00020\u00002\u0010\u0010\u0006\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tJ\u0018\u00103\u001a\u00020\u00002\u0010\u00104\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tJ\u0018\u0010\u0011\u001a\u00020\u00002\u0010\u0010\u0011\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tJ\u001e\u00105\u001a\u00020\u00002\u0016\u0010\u0014\u001a\u0012\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\b0\u0015j\u0002`\u0017J\u0018\u0010\u001c\u001a\u00020\u00002\u0010\u00106\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\u001dJ\u0018\u0010 \u001a\u00020\u00002\u0010\u00104\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tJ\u001e\u0010#\u001a\u00020\u00002\u0016\u00104\u001a\u0012\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020\b0\u0015j\u0002`%J\u0018\u00107\u001a\u00020\u00002\u0010\u0010(\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`)J\u001a\u0010,\u001a\u00020\u00002\u0012\u00108\u001a\u000e\u0012\u0004\u0012\u00020-\u0012\u0004\u0012\u00020-0\u0015R$\u0010\u0006\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\rR$\u0010\u000e\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000f\u0010\u000b\"\u0004\b\u0010\u0010\rR$\u0010\u0011\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0012\u0010\u000b\"\u0004\b\u0013\u0010\rR*\u0010\u0014\u001a\u0012\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\b0\u0015j\u0002`\u0017X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u0019\"\u0004\b\u001a\u0010\u001bR$\u0010\u001c\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\u001dX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001e\u0010\u000b\"\u0004\b\u001f\u0010\rR$\u0010 \u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`\tX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b!\u0010\u000b\"\u0004\b\"\u0010\rR*\u0010#\u001a\u0012\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020\b0\u0015j\u0002`%X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b&\u0010\u0019\"\u0004\b'\u0010\u001bR$\u0010(\u001a\f\u0012\u0004\u0012\u00020\b0\u0007j\u0002`)X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b*\u0010\u000b\"\u0004\b+\u0010\rR\u001a\u0010,\u001a\u00020-X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b.\u0010/\"\u0004\b0\u00101¨\u00069"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenRendering$Builder;", "", "rendering", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenRendering;", "(Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenRendering;)V", "()V", "onBackButtonClicked", "Lkotlin/Function0;", "", "Lzendesk/messaging/android/internal/conversationslistscreen/OnClickLambda;", "getOnBackButtonClicked$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function0;", "setOnBackButtonClicked$zendesk_messaging_messaging_android", "(Lkotlin/jvm/functions/Function0;)V", "onCreateConvoButtonClicked", "getOnCreateConvoButtonClicked$zendesk_messaging_messaging_android", "setOnCreateConvoButtonClicked$zendesk_messaging_messaging_android", "onDismissCreateConversationError", "getOnDismissCreateConversationError$zendesk_messaging_messaging_android", "setOnDismissCreateConversationError$zendesk_messaging_messaging_android", "onListItemClickLambda", "Lkotlin/Function1;", "Lzendesk/core/ui/android/internal/model/ConversationEntry$ConversationItem;", "Lzendesk/messaging/android/internal/conversationslistscreen/OnListItemClickLambda;", "getOnListItemClickLambda$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function1;", "setOnListItemClickLambda$zendesk_messaging_messaging_android", "(Lkotlin/jvm/functions/Function1;)V", "onMessageReceivedAuthorAnnounced", "Lzendesk/messaging/android/internal/conversationslistscreen/OnEventLambda;", "getOnMessageReceivedAuthorAnnounced$zendesk_messaging_messaging_android", "setOnMessageReceivedAuthorAnnounced$zendesk_messaging_messaging_android", "onRetryButtonClicked", "getOnRetryButtonClicked$zendesk_messaging_messaging_android", "setOnRetryButtonClicked$zendesk_messaging_messaging_android", "onRetryPaginationClicked", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMore;", "Lzendesk/messaging/android/internal/conversationslistscreen/OnRetryPaginationClickLambda;", "getOnRetryPaginationClicked$zendesk_messaging_messaging_android", "setOnRetryPaginationClicked$zendesk_messaging_messaging_android", "onStartPagingLambda", "Lzendesk/messaging/android/internal/conversationslistscreen/OnStartPagingLambda;", "getOnStartPagingLambda$zendesk_messaging_messaging_android", "setOnStartPagingLambda$zendesk_messaging_messaging_android", "state", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;", "getState$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;", "setState$zendesk_messaging_messaging_android", "(Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;)V", "build", "onCreateConversationClicked", "onClickLambda", "onListConversationClicked", "onEventLambda", "onStartPaging", "stateUpdate", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        private Function0<Unit> onBackButtonClicked;
        private Function0<Unit> onCreateConvoButtonClicked;
        private Function0<Unit> onDismissCreateConversationError;
        private Function1<? super ConversationEntry.ConversationItem, Unit> onListItemClickLambda;
        private Function0<Unit> onMessageReceivedAuthorAnnounced;
        private Function0<Unit> onRetryButtonClicked;
        private Function1<? super ConversationEntry.LoadMore, Unit> onRetryPaginationClicked;
        private Function0<Unit> onStartPagingLambda;
        private ConversationsListScreenState state;

        public Builder() {
            this.onBackButtonClicked = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.onCreateConvoButtonClicked = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
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
            this.onRetryButtonClicked = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.onRetryPaginationClicked = new Function1<ConversationEntry.LoadMore, Unit>() {
                public final void invoke2(ConversationEntry.LoadMore it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                }

                @Override
                public Unit invoke(ConversationEntry.LoadMore loadMore) {
                    invoke2(loadMore);
                    return Unit.INSTANCE;
                }
            };
            this.onMessageReceivedAuthorAnnounced = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.onStartPagingLambda = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.onDismissCreateConversationError = new Function0<Unit>() {
                public final void invoke2() {
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }
            };
            this.state = new ConversationsListScreenState(null, null, null, null, false, false, null, null, false, null, null, false, 0, null, null, 32767, null);
        }

        public final Function0<Unit> getOnBackButtonClicked$zendesk_messaging_messaging_android() {
            return this.onBackButtonClicked;
        }

        public final void setOnBackButtonClicked$zendesk_messaging_messaging_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onBackButtonClicked = function0;
        }

        public final Function0<Unit> m272xaab7ad3d() {
            return this.onCreateConvoButtonClicked;
        }

        public final void m275x4fb14d49(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onCreateConvoButtonClicked = function0;
        }

        public final Function1<ConversationEntry.ConversationItem, Unit> getOnListItemClickLambda$zendesk_messaging_messaging_android() {
            return this.onListItemClickLambda;
        }

        public final void setOnListItemClickLambda$zendesk_messaging_messaging_android(Function1<? super ConversationEntry.ConversationItem, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onListItemClickLambda = function1;
        }

        public final Function0<Unit> getOnRetryButtonClicked$zendesk_messaging_messaging_android() {
            return this.onRetryButtonClicked;
        }

        public final void setOnRetryButtonClicked$zendesk_messaging_messaging_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onRetryButtonClicked = function0;
        }

        public final Function1<ConversationEntry.LoadMore, Unit> getOnRetryPaginationClicked$zendesk_messaging_messaging_android() {
            return this.onRetryPaginationClicked;
        }

        public final void setOnRetryPaginationClicked$zendesk_messaging_messaging_android(Function1<? super ConversationEntry.LoadMore, Unit> function1) {
            Intrinsics.checkNotNullParameter(function1, "<set-?>");
            this.onRetryPaginationClicked = function1;
        }

        public final Function0<Unit> m274x6ade096f() {
            return this.onMessageReceivedAuthorAnnounced;
        }

        public final void m277x10ea707b(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onMessageReceivedAuthorAnnounced = function0;
        }

        public final Function0<Unit> getOnStartPagingLambda$zendesk_messaging_messaging_android() {
            return this.onStartPagingLambda;
        }

        public final void setOnStartPagingLambda$zendesk_messaging_messaging_android(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onStartPagingLambda = function0;
        }

        public final Function0<Unit> m273xbb9b9606() {
            return this.onDismissCreateConversationError;
        }

        public final void m276x61a7fd12(Function0<Unit> function0) {
            Intrinsics.checkNotNullParameter(function0, "<set-?>");
            this.onDismissCreateConversationError = function0;
        }

        public final ConversationsListScreenState getState() {
            return this.state;
        }

        public final void setState$zendesk_messaging_messaging_android(ConversationsListScreenState conversationsListScreenState) {
            Intrinsics.checkNotNullParameter(conversationsListScreenState, "<set-?>");
            this.state = conversationsListScreenState;
        }

        public Builder(ConversationsListScreenRendering rendering) {
            this();
            Intrinsics.checkNotNullParameter(rendering, "rendering");
            this.onBackButtonClicked = rendering.getOnBackButtonClicked$zendesk_messaging_messaging_android();
            this.onCreateConvoButtonClicked = rendering.m269xaab7ad3d();
            this.onListItemClickLambda = rendering.getOnListItemClickLambda$zendesk_messaging_messaging_android();
            this.onRetryButtonClicked = rendering.getOnRetryButtonClicked$zendesk_messaging_messaging_android();
            this.onRetryPaginationClicked = rendering.getOnRetryPaginationClick$zendesk_messaging_messaging_android();
            this.onStartPagingLambda = rendering.getOnStartPagingLambda$zendesk_messaging_messaging_android();
            this.onDismissCreateConversationError = rendering.m270xbb9b9606();
            this.state = rendering.getState();
        }

        public Builder(ConversationsListScreenRendering conversationsListScreenRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? new ConversationsListScreenRendering() : conversationsListScreenRendering);
        }

        public final Builder onBackButtonClicked(Function0<Unit> onBackButtonClicked) {
            Intrinsics.checkNotNullParameter(onBackButtonClicked, "onBackButtonClicked");
            this.onBackButtonClicked = onBackButtonClicked;
            return this;
        }

        public final Builder onCreateConversationClicked(Function0<Unit> onClickLambda) {
            Intrinsics.checkNotNullParameter(onClickLambda, "onClickLambda");
            this.onCreateConvoButtonClicked = onClickLambda;
            return this;
        }

        public final Builder onListConversationClicked(Function1<? super ConversationEntry.ConversationItem, Unit> onListItemClickLambda) {
            Intrinsics.checkNotNullParameter(onListItemClickLambda, "onListItemClickLambda");
            this.onListItemClickLambda = onListItemClickLambda;
            return this;
        }

        public final Builder onDismissCreateConversationError(Function0<Unit> onDismissCreateConversationError) {
            Intrinsics.checkNotNullParameter(onDismissCreateConversationError, "onDismissCreateConversationError");
            this.onDismissCreateConversationError = onDismissCreateConversationError;
            return this;
        }

        public final Builder onRetryButtonClicked(Function0<Unit> onClickLambda) {
            Intrinsics.checkNotNullParameter(onClickLambda, "onClickLambda");
            this.onRetryButtonClicked = onClickLambda;
            return this;
        }

        public final Builder onRetryPaginationClicked(Function1<? super ConversationEntry.LoadMore, Unit> onClickLambda) {
            Intrinsics.checkNotNullParameter(onClickLambda, "onClickLambda");
            this.onRetryPaginationClicked = onClickLambda;
            return this;
        }

        public final Builder onStartPaging(Function0<Unit> onStartPagingLambda) {
            Intrinsics.checkNotNullParameter(onStartPagingLambda, "onStartPagingLambda");
            this.onStartPagingLambda = onStartPagingLambda;
            return this;
        }

        public final Builder onMessageReceivedAuthorAnnounced(Function0<Unit> onEventLambda) {
            Intrinsics.checkNotNullParameter(onEventLambda, "onEventLambda");
            this.onMessageReceivedAuthorAnnounced = onEventLambda;
            return this;
        }

        public final Builder state(Function1<? super ConversationsListScreenState, ConversationsListScreenState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            this.state = stateUpdate.invoke(this.state);
            return this;
        }

        public final ConversationsListScreenRendering build() {
            return new ConversationsListScreenRendering(this);
        }
    }
}
