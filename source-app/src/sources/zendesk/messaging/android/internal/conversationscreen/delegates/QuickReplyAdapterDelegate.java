package zendesk.messaging.android.internal.conversationscreen.delegates;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.recyclerview.widget.RecyclerView;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.MessageAction;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.adapterdelegate.ListItemAdapterDelegate;
import zendesk.messaging.android.internal.conversationscreen.messagelog.MessageLogListenersKt;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.p026ui.android.conversation.quickreply.QuickReplyOption;
import zendesk.p026ui.android.conversation.quickreply.QuickReplyRendering;
import zendesk.p026ui.android.conversation.quickreply.QuickReplyState;
import zendesk.p026ui.android.conversation.quickreply.QuickReplyView;

@Metadata(m17d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u0014\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0001:\u0001#B'\u0012\u0018\b\u0002\u0010\u0005\u001a\u0012\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006j\u0002`\t\u0012\u0006\u0010\n\u001a\u00020\u000b¢\u0006\u0002\u0010\fJ&\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00032\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u00030\u00192\u0006\u0010\u001a\u001a\u00020\u001bH\u0014J(\u0010\u001c\u001a\u00020\b2\u0006\u0010\u0017\u001a\u00020\u00022\u0006\u0010\u001d\u001a\u00020\u00042\u000e\u0010\u001e\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u001f0\u0019H\u0014J\u0010\u0010 \u001a\u00020\u00042\u0006\u0010!\u001a\u00020\"H\u0016R\u001a\u0010\n\u001a\u00020\u000bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R*\u0010\u0005\u001a\u0012\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006j\u0002`\tX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\u0012\"\u0004\b\u0013\u0010\u0014¨\u0006$"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/QuickReplyAdapterDelegate;", "Lzendesk/messaging/android/internal/adapterdelegate/ListItemAdapterDelegate;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$QuickReply;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "Lzendesk/messaging/android/internal/conversationscreen/delegates/QuickReplyAdapterDelegate$ViewHolder;", "onOptionSelected", "Lkotlin/Function1;", "Lzendesk/conversationkit/android/model/MessageAction$Reply;", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnReplyActionSelected;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Lkotlin/jvm/functions/Function1;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "setMessagingTheme", "(Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getOnOptionSelected", "()Lkotlin/jvm/functions/Function1;", "setOnOptionSelected", "(Lkotlin/jvm/functions/Function1;)V", "isForViewType", "", "item", "items", "", "position", "", "onBindViewHolder", "holder", "payloads", "", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "ViewHolder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class QuickReplyAdapterDelegate extends ListItemAdapterDelegate<MessageLogEntry.QuickReply, MessageLogEntry, ViewHolder> {
    private MessagingTheme messagingTheme;
    private Function1<? super MessageAction.Reply, Unit> onOptionSelected;

    @Override
    public void onBindViewHolder(Object obj, RecyclerView.ViewHolder viewHolder, List list) {
        onBindViewHolder((MessageLogEntry.QuickReply) obj, (ViewHolder) viewHolder, (List<? extends Object>) list);
    }

    public QuickReplyAdapterDelegate(Function1 function1, MessagingTheme messagingTheme, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? MessageLogListenersKt.getNOOP_ON_QUICK_REPLY_OPTION_SELECTED_LISTENER() : function1, messagingTheme);
    }

    public final Function1<MessageAction.Reply, Unit> getOnOptionSelected() {
        return this.onOptionSelected;
    }

    public final void setOnOptionSelected(Function1<? super MessageAction.Reply, Unit> function1) {
        Intrinsics.checkNotNullParameter(function1, "<set-?>");
        this.onOptionSelected = function1;
    }

    public final MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public final void setMessagingTheme(MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(messagingTheme, "<set-?>");
        this.messagingTheme = messagingTheme;
    }

    public QuickReplyAdapterDelegate(Function1<? super MessageAction.Reply, Unit> onOptionSelected, MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(onOptionSelected, "onOptionSelected");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        this.onOptionSelected = onOptionSelected;
        this.messagingTheme = messagingTheme;
    }

    @Override
    public boolean isForViewType(MessageLogEntry item, List<? extends MessageLogEntry> items, int position) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(items, "items");
        return item instanceof MessageLogEntry.QuickReply;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        View viewInflate = LayoutInflater.from(parent.getContext()).inflate(C1256R.layout.zma_view_message_log_entry_quick_reply, parent, false);
        Intrinsics.checkNotNullExpressionValue(viewInflate, "inflate(...)");
        return new ViewHolder(viewInflate, this.messagingTheme.getOnActionBackgroundColor(), this.messagingTheme.getActionBackgroundColor());
    }

    protected void onBindViewHolder(MessageLogEntry.QuickReply item, ViewHolder holder, List<? extends Object> payloads) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(holder, "holder");
        Intrinsics.checkNotNullParameter(payloads, "payloads");
        holder.bind(item, this.onOptionSelected);
    }

    @Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B!\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0001\u0010\u0006\u001a\u00020\u0005¢\u0006\u0002\u0010\u0007J&\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\u0016\u0010\u000e\u001a\u0012\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u000b0\u000fj\u0002`\u0011R\u000e\u0010\u0006\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0012"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/QuickReplyAdapterDelegate$ViewHolder;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "itemView", "Landroid/view/View;", "quickReplyColor", "", "quickReplyBackgroundColor", "(Landroid/view/View;II)V", "quickReplyView", "Lzendesk/ui/android/conversation/quickreply/QuickReplyView;", "bind", "", "item", "Lzendesk/messaging/android/internal/model/MessageLogEntry$QuickReply;", "onReplyActionSelected", "Lkotlin/Function1;", "Lzendesk/conversationkit/android/model/MessageAction$Reply;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnReplyActionSelected;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ViewHolder extends RecyclerView.ViewHolder {
        private final int quickReplyBackgroundColor;
        private final int quickReplyColor;
        private final QuickReplyView quickReplyView;

        public ViewHolder(View itemView, int i, int i2) {
            super(itemView);
            Intrinsics.checkNotNullParameter(itemView, "itemView");
            this.quickReplyColor = i;
            this.quickReplyBackgroundColor = i2;
            View viewFindViewById = itemView.findViewById(C1256R.id.zma_quick_reply);
            Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
            this.quickReplyView = (QuickReplyView) viewFindViewById;
        }

        public final void bind(final MessageLogEntry.QuickReply item, final Function1<? super MessageAction.Reply, Unit> onReplyActionSelected) {
            Intrinsics.checkNotNullParameter(item, "item");
            Intrinsics.checkNotNullParameter(onReplyActionSelected, "onReplyActionSelected");
            this.quickReplyView.render(new Function1<QuickReplyRendering, QuickReplyRendering>() {
                {
                    super(1);
                }

                @Override
                public final QuickReplyRendering invoke(QuickReplyRendering quickReplyRendering) {
                    Intrinsics.checkNotNullParameter(quickReplyRendering, "quickReplyRendering");
                    QuickReplyRendering.Builder builder = quickReplyRendering.toBuilder();
                    final MessageLogEntry.QuickReply quickReply = item;
                    final QuickReplyAdapterDelegate.ViewHolder viewHolder = this;
                    QuickReplyRendering.Builder builderState = builder.state(new Function1<QuickReplyState, QuickReplyState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final QuickReplyState invoke(QuickReplyState state) {
                            Intrinsics.checkNotNullParameter(state, "state");
                            List<MessageAction.Reply> replies = quickReply.getReplies();
                            ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(replies, 10));
                            for (MessageAction.Reply reply : replies) {
                                arrayList.add(new QuickReplyOption(reply.getId(), reply.getText()));
                            }
                            return state.copy(arrayList, viewHolder.quickReplyColor, viewHolder.quickReplyBackgroundColor);
                        }
                    });
                    final Function1<MessageAction.Reply, Unit> function1 = onReplyActionSelected;
                    final MessageLogEntry.QuickReply quickReply2 = item;
                    return builderState.onOptionClicked(new Function1<QuickReplyOption, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(QuickReplyOption quickReplyOption) {
                            invoke2(quickReplyOption);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(QuickReplyOption clickedOption) {
                            Intrinsics.checkNotNullParameter(clickedOption, "clickedOption");
                            Function1<MessageAction.Reply, Unit> function2 = function1;
                            for (Object obj : quickReply2.getReplies()) {
                                if (Intrinsics.areEqual(((MessageAction.Reply) obj).getId(), clickedOption.getId())) {
                                    function2.invoke((MessageAction.Reply) obj);
                                    return;
                                }
                            }
                            throw new NoSuchElementException("Collection contains no element matching the predicate.");
                        }
                    }).build();
                }
            });
        }
    }
}
