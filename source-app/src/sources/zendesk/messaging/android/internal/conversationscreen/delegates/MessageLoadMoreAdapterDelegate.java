package zendesk.messaging.android.internal.conversationscreen.delegates;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.adapterdelegate.ListItemAdapterDelegate;
import zendesk.messaging.android.internal.model.LoadMoreStatus;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.ui.android.common.loadmore.LoadMoreRendering;
import zendesk.ui.android.common.loadmore.LoadMoreState;
import zendesk.ui.android.common.loadmore.LoadMoreView;

@Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u0014\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0001:\u0001\u001bB\u0005¢\u0006\u0002\u0010\u0005J&\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u00032\f\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00030\u00112\u0006\u0010\u0012\u001a\u00020\u0013H\u0014J(\u0010\u0014\u001a\u00020\b2\u0006\u0010\u000f\u001a\u00020\u00022\u0006\u0010\u0015\u001a\u00020\u00042\u000e\u0010\u0016\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00170\u0011H\u0014J\u0010\u0010\u0018\u001a\u00020\u00042\u0006\u0010\u0019\u001a\u00020\u001aH\u0016R\"\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\f¨\u0006\u001c"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/MessageLoadMoreAdapterDelegate;", "Lzendesk/messaging/android/internal/adapterdelegate/ListItemAdapterDelegate;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$LoadMore;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "Lzendesk/messaging/android/internal/conversationscreen/delegates/MessageLoadMoreAdapterDelegate$ViewHolder;", "()V", "onRetryClicked", "Lkotlin/Function0;", "", "getOnRetryClicked$zendesk_messaging_messaging_android", "()Lkotlin/jvm/functions/Function0;", "setOnRetryClicked$zendesk_messaging_messaging_android", "(Lkotlin/jvm/functions/Function0;)V", "isForViewType", "", "item", "items", "", "position", "", "onBindViewHolder", "holder", "payloads", "", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "ViewHolder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageLoadMoreAdapterDelegate extends ListItemAdapterDelegate<MessageLogEntry.LoadMore, MessageLogEntry, ViewHolder> {
    private Function0<Unit> onRetryClicked;

    @Override
    public void onBindViewHolder(Object obj, RecyclerView.ViewHolder viewHolder, List list) {
        onBindViewHolder((MessageLogEntry.LoadMore) obj, (ViewHolder) viewHolder, (List<? extends Object>) list);
    }

    public final Function0<Unit> getOnRetryClicked$zendesk_messaging_messaging_android() {
        return this.onRetryClicked;
    }

    public final void setOnRetryClicked$zendesk_messaging_messaging_android(Function0<Unit> function0) {
        this.onRetryClicked = function0;
    }

    @Override
    public boolean isForViewType(MessageLogEntry item, List<? extends MessageLogEntry> items, int position) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(items, "items");
        return item instanceof MessageLogEntry.LoadMore;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        View viewInflate = LayoutInflater.from(parent.getContext()).inflate(C1256R.layout.zma_view_message_log_entry_message_load_more, parent, false);
        Intrinsics.checkNotNullExpressionValue(viewInflate, "inflate(...)");
        Function0<Unit> function0 = this.onRetryClicked;
        Context context = parent.getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        return new ViewHolder(viewInflate, function0, context);
    }

    protected void onBindViewHolder(MessageLogEntry.LoadMore item, ViewHolder holder, List<? extends Object> payloads) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(holder, "holder");
        Intrinsics.checkNotNullParameter(payloads, "payloads");
        holder.bind(item);
    }

    @Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u000e\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ\u000e\u0010\u0010\u001a\u00020\u00062\u0006\u0010\u0011\u001a\u00020\u0012R\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u0019\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/MessageLoadMoreAdapterDelegate$ViewHolder;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "itemView", "Landroid/view/View;", "onRetryClicked", "Lkotlin/Function0;", "", "context", "Landroid/content/Context;", "(Landroid/view/View;Lkotlin/jvm/functions/Function0;Landroid/content/Context;)V", "getContext", "()Landroid/content/Context;", "loadMoreView", "Lzendesk/ui/android/common/loadmore/LoadMoreView;", "getOnRetryClicked", "()Lkotlin/jvm/functions/Function0;", "bind", "item", "Lzendesk/messaging/android/internal/model/MessageLogEntry$LoadMore;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ViewHolder extends RecyclerView.ViewHolder {
        private final Context context;
        private final LoadMoreView loadMoreView;
        private final Function0<Unit> onRetryClicked;

        public final Function0<Unit> getOnRetryClicked() {
            return this.onRetryClicked;
        }

        public final Context getContext() {
            return this.context;
        }

        public ViewHolder(View itemView, Function0<Unit> function0, Context context) {
            super(itemView);
            Intrinsics.checkNotNullParameter(itemView, "itemView");
            Intrinsics.checkNotNullParameter(context, "context");
            this.onRetryClicked = function0;
            this.context = context;
            LoadMoreView loadMoreViewFindViewById = itemView.findViewById(C1256R.id.zma_messages_load_more);
            Intrinsics.checkNotNullExpressionValue(loadMoreViewFindViewById, "findViewById(...)");
            this.loadMoreView = loadMoreViewFindViewById;
        }

        public final void bind(final MessageLogEntry.LoadMore item) {
            Intrinsics.checkNotNullParameter(item, "item");
            this.loadMoreView.render(new Function1<LoadMoreRendering, LoadMoreRendering>() {
                {
                    super(1);
                }

                @Override
                public final LoadMoreRendering invoke(LoadMoreRendering messageLoadMoreRendering) {
                    Intrinsics.checkNotNullParameter(messageLoadMoreRendering, "messageLoadMoreRendering");
                    LoadMoreRendering.Builder builder = messageLoadMoreRendering.toBuilder();
                    final MessageLoadMoreAdapterDelegate.ViewHolder viewHolder = this.this$0;
                    LoadMoreRendering.Builder builderOnRetryClicked = builder.onRetryClicked(new Function0<Unit>() {
                        {
                            super(0);
                        }

                        @Override
                        public Unit invoke() {
                            invoke2();
                            return Unit.INSTANCE;
                        }

                        public final void invoke2() {
                            Function0<Unit> onRetryClicked = viewHolder.getOnRetryClicked();
                            if (onRetryClicked != null) {
                                onRetryClicked.invoke();
                            }
                        }
                    });
                    final MessageLogEntry.LoadMore loadMore = item;
                    return builderOnRetryClicked.state(new Function1<LoadMoreState, LoadMoreState>() {

                        @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                        public class WhenMappings {
                            public static final int[] $EnumSwitchMapping$0;

                            static {
                                int[] iArr = new int[LoadMoreStatus.values().length];
                                try {
                                    iArr[LoadMoreStatus.LOADING.ordinal()] = 1;
                                } catch (NoSuchFieldError unused) {
                                }
                                try {
                                    iArr[LoadMoreStatus.FAILED.ordinal()] = 2;
                                } catch (NoSuchFieldError unused2) {
                                }
                                try {
                                    iArr[LoadMoreStatus.NONE.ordinal()] = 3;
                                } catch (NoSuchFieldError unused3) {
                                }
                                $EnumSwitchMapping$0 = iArr;
                            }
                        }

                        {
                            super(1);
                        }

                        @Override
                        public final LoadMoreState invoke(LoadMoreState state) {
                            LoadMoreState.LoadMoreStatus loadMoreStatus;
                            Intrinsics.checkNotNullParameter(state, "state");
                            String failedRetryText = loadMore.getFailedRetryText();
                            int i = WhenMappings.$EnumSwitchMapping$0[loadMore.getStatus().ordinal()];
                            if (i == 1) {
                                loadMoreStatus = LoadMoreState.LoadMoreStatus.LOADING;
                            } else if (i == 2) {
                                loadMoreStatus = LoadMoreState.LoadMoreStatus.FAILED;
                            } else {
                                if (i != 3) {
                                    throw new NoWhenBranchMatchedException();
                                }
                                loadMoreStatus = LoadMoreState.LoadMoreStatus.NONE;
                            }
                            return LoadMoreState.copy$default(state, failedRetryText, 0, 0, loadMoreStatus, 6, (Object) null);
                        }
                    }).build();
                }
            });
        }
    }
}
