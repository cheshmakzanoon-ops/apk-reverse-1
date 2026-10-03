package zendesk.messaging.android.internal.conversationscreen.delegates;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.adapterdelegate.ListItemAdapterDelegate;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessageLogType;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.p026ui.android.conversation.messagesdivider.MessagesDividerRendering;
import zendesk.p026ui.android.conversation.messagesdivider.MessagesDividerState;
import zendesk.p026ui.android.conversation.messagesdivider.MessagesDividerView;

@Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u0014\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0001:\u0001\u001aB\r\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J&\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u00032\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00030\u000f2\u0006\u0010\u0010\u001a\u00020\u0011H\u0014J(\u0010\u0012\u001a\u00020\u00132\u0006\u0010\r\u001a\u00020\u00022\u0006\u0010\u0014\u001a\u00020\u00042\u000e\u0010\u0015\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00160\u000fH\u0014J\u0010\u0010\u0017\u001a\u00020\u00042\u0006\u0010\u0018\u001a\u00020\u0019H\u0016R\u001a\u0010\u0005\u001a\u00020\u0006X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u0007¨\u0006\u001b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/MessagesDividerAdapterDelegate;", "Lzendesk/messaging/android/internal/adapterdelegate/ListItemAdapterDelegate;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$MessagesDivider;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "Lzendesk/messaging/android/internal/conversationscreen/delegates/MessagesDividerAdapterDelegate$ViewHolder;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "setMessagingTheme", "isForViewType", "", "item", "items", "", "position", "", "onBindViewHolder", "", "holder", "payloads", "", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "ViewHolder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagesDividerAdapterDelegate extends ListItemAdapterDelegate<MessageLogEntry.MessagesDivider, MessageLogEntry, ViewHolder> {
    private MessagingTheme messagingTheme;

    @Override
    public void onBindViewHolder(Object obj, RecyclerView.ViewHolder viewHolder, List list) {
        onBindViewHolder((MessageLogEntry.MessagesDivider) obj, (ViewHolder) viewHolder, (List<? extends Object>) list);
    }

    public final MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public final void setMessagingTheme(MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(messagingTheme, "<set-?>");
        this.messagingTheme = messagingTheme;
    }

    public MessagesDividerAdapterDelegate(MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        this.messagingTheme = messagingTheme;
    }

    @Override
    public boolean isForViewType(MessageLogEntry item, List<? extends MessageLogEntry> items, int position) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(items, "items");
        return item instanceof MessageLogEntry.MessagesDivider;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        View viewInflate = LayoutInflater.from(parent.getContext()).inflate(C1256R.layout.zma_view_message_log_entry_messages_divider, parent, false);
        Intrinsics.checkNotNullExpressionValue(viewInflate, "inflate(...)");
        Context context = parent.getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        return new ViewHolder(viewInflate, context, this.messagingTheme);
    }

    protected void onBindViewHolder(MessageLogEntry.MessagesDivider item, ViewHolder holder, List<? extends Object> payloads) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(holder, "holder");
        Intrinsics.checkNotNullParameter(payloads, "payloads");
        holder.bind(item);
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u000e\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0014R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u0006\u001a\u00020\u0007X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010¨\u0006\u0015"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/MessagesDividerAdapterDelegate$ViewHolder;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "itemView", "Landroid/view/View;", "context", "Landroid/content/Context;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Landroid/view/View;Landroid/content/Context;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getContext", "()Landroid/content/Context;", "messagesDividerView", "Lzendesk/ui/android/conversation/messagesdivider/MessagesDividerView;", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "setMessagingTheme", "(Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "bind", "", "item", "Lzendesk/messaging/android/internal/model/MessageLogEntry$MessagesDivider;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ViewHolder extends RecyclerView.ViewHolder {
        private final Context context;
        private final MessagesDividerView messagesDividerView;
        private MessagingTheme messagingTheme;

        @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        public class WhenMappings {
            public static final int[] $EnumSwitchMapping$0;

            static {
                int[] iArr = new int[MessageLogType.values().length];
                try {
                    iArr[MessageLogType.NewMessagesDivider.ordinal()] = 1;
                } catch (NoSuchFieldError unused) {
                }
                try {
                    iArr[MessageLogType.TimeStampDivider.ordinal()] = 2;
                } catch (NoSuchFieldError unused2) {
                }
                $EnumSwitchMapping$0 = iArr;
            }
        }

        public final Context getContext() {
            return this.context;
        }

        public final MessagingTheme getMessagingTheme() {
            return this.messagingTheme;
        }

        public final void setMessagingTheme(MessagingTheme messagingTheme) {
            Intrinsics.checkNotNullParameter(messagingTheme, "<set-?>");
            this.messagingTheme = messagingTheme;
        }

        public ViewHolder(View itemView, Context context, MessagingTheme messagingTheme) {
            super(itemView);
            Intrinsics.checkNotNullParameter(itemView, "itemView");
            Intrinsics.checkNotNullParameter(context, "context");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            this.context = context;
            this.messagingTheme = messagingTheme;
            Object objFindViewById = itemView.findViewById(C1256R.id.zma_messages_divider);
            Intrinsics.checkNotNullExpressionValue(objFindViewById, "findViewById(...)");
            this.messagesDividerView = (MessagesDividerView) objFindViewById;
        }

        public final void bind(final MessageLogEntry.MessagesDivider item) {
            final MessagesDividerState messagesDividerStateNewMessagesDividerState;
            Intrinsics.checkNotNullParameter(item, "item");
            int i = WhenMappings.$EnumSwitchMapping$0[item.getType().ordinal()];
            if (i == 1) {
                messagesDividerStateNewMessagesDividerState = MessagesDividerState.INSTANCE.newMessagesDividerState(this.messagingTheme.getNotifyColor());
            } else {
                if (i != 2) {
                    throw new NoWhenBranchMatchedException();
                }
                messagesDividerStateNewMessagesDividerState = MessagesDividerState.INSTANCE.timeDividerState(this.context, this.messagingTheme.getOnBackgroundColor());
            }
            this.messagesDividerView.render(new Function1<MessagesDividerRendering, MessagesDividerRendering>() {
                {
                    super(1);
                }

                @Override
                public final MessagesDividerRendering invoke(MessagesDividerRendering messagesDividerRendering) {
                    Intrinsics.checkNotNullParameter(messagesDividerRendering, "messagesDividerRendering");
                    MessagesDividerRendering.Builder builder = messagesDividerRendering.toBuilder();
                    final MessageLogEntry.MessagesDivider messagesDivider = item;
                    final MessagesDividerState messagesDividerState = messagesDividerStateNewMessagesDividerState;
                    return builder.state(new Function1<MessagesDividerState, MessagesDividerState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final MessagesDividerState invoke(MessagesDividerState state) {
                            Intrinsics.checkNotNullParameter(state, "state");
                            return state.copy(messagesDivider.getText(), messagesDividerState.getDividerColor(), messagesDividerState.getTextColor(), messagesDividerState.getTextStyle());
                        }
                    }).build();
                }
            });
        }
    }
}
