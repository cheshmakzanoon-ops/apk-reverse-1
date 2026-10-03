package zendesk.messaging.android.internal.conversationslistscreen.list;

import android.view.View;
import android.view.ViewGroup;
import androidx.recyclerview.widget.ListAdapter;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationCellFactory;

@Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u00002\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001B\u0005¢\u0006\u0002\u0010\u0004J\u0010\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\fH\u0016J\u0018\u0010\u000e\u001a\u00020\b2\u0006\u0010\u000f\u001a\u00020\u00032\u0006\u0010\r\u001a\u00020\fH\u0016J\u0018\u0010\u0010\u001a\u00020\u00032\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\fH\u0016J\u001a\u0010\u0014\u001a\u00020\b2\u0012\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006J\u001a\u0010\u0015\u001a\u00020\b2\u0012\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\b0\u0006R\u001a\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\b0\u0006X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0016"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListAdapter;", "Landroidx/recyclerview/widget/ListAdapter;", "Lzendesk/core/ui/android/internal/model/ConversationEntry;", "Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListViewHolder;", "()V", "listItemClickListener", "Lkotlin/Function1;", "Lzendesk/core/ui/android/internal/model/ConversationEntry$ConversationItem;", "", "retryClickListener", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMore;", "getItemViewType", "", "position", "onBindViewHolder", "holder", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "viewType", "setOnListItemClickListener", "setOnRetryClickListener", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListAdapter extends ListAdapter<ConversationEntry, ConversationsListViewHolder> {
    private Function1<? super ConversationEntry.ConversationItem, Unit> listItemClickListener;
    private Function1<? super ConversationEntry.LoadMore, Unit> retryClickListener;

    public ConversationsListAdapter() {
        super(ConversationDiffCallback.INSTANCE);
        this.listItemClickListener = new Function1<ConversationEntry.ConversationItem, Unit>() {
            public final void invoke2(ConversationEntry.ConversationItem it) {
                Intrinsics.checkNotNullParameter(it, "it");
            }

            @Override
            public Unit invoke(ConversationEntry.ConversationItem conversationItem) {
                invoke2(conversationItem);
                return Unit.INSTANCE;
            }
        };
        this.retryClickListener = new Function1<ConversationEntry.LoadMore, Unit>() {
            public final void invoke2(ConversationEntry.LoadMore it) {
                Intrinsics.checkNotNullParameter(it, "it");
            }

            @Override
            public Unit invoke(ConversationEntry.LoadMore loadMore) {
                invoke2(loadMore);
                return Unit.INSTANCE;
            }
        };
    }

    public ConversationsListViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        if (ConversationsListCellViewType.values()[viewType] == ConversationsListCellViewType.CONVERSATION) {
            return new ConversationListItemViewHolder(ConversationCellFactory.createConversationCellView$default(ConversationCellFactory.INSTANCE, null, parent, new Function1<ConversationEntry.ConversationItem, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(ConversationEntry.ConversationItem conversationItem) {
                    invoke2(conversationItem);
                    return Unit.INSTANCE;
                }

                public final void invoke2(ConversationEntry.ConversationItem it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    ConversationsListAdapter.this.listItemClickListener.invoke(it);
                }
            }, 1, null));
        }
        return new ConversationsListLoadMoreViewHolder(ConversationCellFactory.INSTANCE.createLoadMoreCellView(parent), new Function1<ConversationEntry.LoadMore, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(ConversationEntry.LoadMore loadMore) {
                invoke2(loadMore);
                return Unit.INSTANCE;
            }

            public final void invoke2(ConversationEntry.LoadMore it) {
                Intrinsics.checkNotNullParameter(it, "it");
                ConversationsListAdapter.this.retryClickListener.invoke(it);
            }
        });
    }

    public void onBindViewHolder(ConversationsListViewHolder holder, int position) {
        Intrinsics.checkNotNullParameter(holder, "holder");
        if (holder instanceof ConversationListItemViewHolder) {
            ConversationCellFactory conversationCellFactory = ConversationCellFactory.INSTANCE;
            Object item = getItem(position);
            Intrinsics.checkNotNull(item, "null cannot be cast to non-null type zendesk.core.ui.android.internal.model.ConversationEntry.ConversationItem");
            View itemView = holder.itemView;
            Intrinsics.checkNotNullExpressionValue(itemView, "itemView");
            ((ConversationListItemViewHolder) holder).onBind(conversationCellFactory.mapToConversationCellState$zendesk_messaging_messaging_android((ConversationEntry.ConversationItem) item, itemView, new Function1<ConversationEntry.ConversationItem, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(ConversationEntry.ConversationItem conversationItem) {
                    invoke2(conversationItem);
                    return Unit.INSTANCE;
                }

                public final void invoke2(ConversationEntry.ConversationItem it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    ConversationsListAdapter.this.listItemClickListener.invoke(it);
                }
            }));
        }
        if (holder instanceof ConversationsListLoadMoreViewHolder) {
            Object item2 = getItem(position);
            Intrinsics.checkNotNull(item2, "null cannot be cast to non-null type zendesk.core.ui.android.internal.model.ConversationEntry.LoadMore");
            ((ConversationsListLoadMoreViewHolder) holder).onBind((ConversationEntry.LoadMore) item2);
        }
    }

    public int getItemViewType(int position) {
        if (position == -1) {
            return -1;
        }
        ConversationEntry conversationEntry = (ConversationEntry) getItem(position);
        if (conversationEntry instanceof ConversationEntry.ConversationItem) {
            return ConversationsListCellViewType.CONVERSATION.ordinal();
        }
        if (conversationEntry instanceof ConversationEntry.LoadMore) {
            return ConversationsListCellViewType.LOAD_MORE.ordinal();
        }
        throw new NoWhenBranchMatchedException();
    }

    public final void setOnListItemClickListener(Function1<? super ConversationEntry.ConversationItem, Unit> listItemClickListener) {
        Intrinsics.checkNotNullParameter(listItemClickListener, "listItemClickListener");
        this.listItemClickListener = listItemClickListener;
    }

    public final void setOnRetryClickListener(Function1<? super ConversationEntry.LoadMore, Unit> retryClickListener) {
        Intrinsics.checkNotNullParameter(retryClickListener, "retryClickListener");
        this.retryClickListener = retryClickListener;
    }
}
