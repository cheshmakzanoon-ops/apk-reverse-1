package zendesk.messaging.android.internal.conversationscreen.delegates;

import android.content.Context;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.adapterdelegate.ListItemAdapterDelegate;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.p026ui.android.conversation.avatar.AvatarImageRendering;
import zendesk.p026ui.android.conversation.avatar.AvatarImageState;
import zendesk.p026ui.android.conversation.avatar.AvatarImageView;
import zendesk.p026ui.android.conversation.avatar.AvatarMask;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptView;
import zendesk.p026ui.android.conversation.typingindicatorcell.TypingIndicatorCellRendering;
import zendesk.p026ui.android.conversation.typingindicatorcell.TypingIndicatorCellState;
import zendesk.p026ui.android.conversation.typingindicatorcell.TypingIndicatorCellView;

@Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u0014\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0001:\u0001\u001aB\r\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J&\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u00032\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00030\u000f2\u0006\u0010\u0010\u001a\u00020\u0011H\u0014J(\u0010\u0012\u001a\u00020\u00132\u0006\u0010\r\u001a\u00020\u00022\u0006\u0010\u0014\u001a\u00020\u00042\u000e\u0010\u0015\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00160\u000fH\u0014J\u0010\u0010\u0017\u001a\u00020\u00042\u0006\u0010\u0018\u001a\u00020\u0019H\u0016R\u001a\u0010\u0005\u001a\u00020\u0006X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u0007¨\u0006\u001b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/TypingIndicatorContainerAdapterDelegate;", "Lzendesk/messaging/android/internal/adapterdelegate/ListItemAdapterDelegate;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$TypingIndicatorContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "Lzendesk/messaging/android/internal/conversationscreen/delegates/TypingIndicatorContainerAdapterDelegate$ViewHolder;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "setMessagingTheme", "isForViewType", "", "item", "items", "", "position", "", "onBindViewHolder", "", "holder", "payloads", "", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "ViewHolder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class TypingIndicatorContainerAdapterDelegate extends ListItemAdapterDelegate<MessageLogEntry.TypingIndicatorContainer, MessageLogEntry, ViewHolder> {
    private MessagingTheme messagingTheme;

    @Override
    public void onBindViewHolder(Object obj, RecyclerView.ViewHolder viewHolder, List list) {
        onBindViewHolder((MessageLogEntry.TypingIndicatorContainer) obj, (ViewHolder) viewHolder, (List<? extends Object>) list);
    }

    public final MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public final void setMessagingTheme(MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(messagingTheme, "<set-?>");
        this.messagingTheme = messagingTheme;
    }

    public TypingIndicatorContainerAdapterDelegate(MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        this.messagingTheme = messagingTheme;
    }

    @Override
    public boolean isForViewType(MessageLogEntry item, List<? extends MessageLogEntry> items, int position) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(items, "items");
        return item instanceof MessageLogEntry.TypingIndicatorContainer;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        View viewInflate = LayoutInflater.from(parent.getContext()).inflate(C1256R.layout.zma_view_message_log_entry_message_container, parent, false);
        Intrinsics.checkNotNullExpressionValue(viewInflate, "inflate(...)");
        return new ViewHolder(viewInflate, this.messagingTheme);
    }

    protected void onBindViewHolder(MessageLogEntry.TypingIndicatorContainer item, ViewHolder holder, List<? extends Object> payloads) {
        Intrinsics.checkNotNullParameter(item, "item");
        Intrinsics.checkNotNullParameter(holder, "holder");
        Intrinsics.checkNotNullParameter(payloads, "payloads");
        holder.bind(item);
    }

    @Metadata(m17d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u000e\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u0012J\u0018\u0010\u0013\u001a\u00020\u00032\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0004\u001a\u00020\u0005H\u0002J\u0010\u0010\u0016\u001a\u00020\u00102\u0006\u0010\u0017\u001a\u00020\u0018H\u0002J\b\u0010\u0019\u001a\u00020\u0010H\u0002R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001a"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/TypingIndicatorContainerAdapterDelegate$ViewHolder;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "itemView", "Landroid/view/View;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Landroid/view/View;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "avatarView", "Lzendesk/ui/android/conversation/avatar/AvatarImageView;", "contentView", "Landroid/widget/LinearLayout;", "labelView", "Landroid/widget/TextView;", "receiptView", "Lzendesk/ui/android/conversation/receipt/MessageReceiptView;", "bind", "", "item", "Lzendesk/messaging/android/internal/model/MessageLogEntry$TypingIndicatorContainer;", "createTypingIndicatorCell", "parentView", "Landroid/view/ViewGroup;", "renderAvatar", "avatarUrl", "", "renderContent", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ViewHolder extends RecyclerView.ViewHolder {
        private final AvatarImageView avatarView;
        private final LinearLayout contentView;
        private final TextView labelView;
        private final MessagingTheme messagingTheme;
        private final MessageReceiptView receiptView;

        public ViewHolder(View itemView, MessagingTheme messagingTheme) {
            super(itemView);
            Intrinsics.checkNotNullParameter(itemView, "itemView");
            Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
            this.messagingTheme = messagingTheme;
            View viewFindViewById = itemView.findViewById(C1256R.id.zma_message_label);
            Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
            this.labelView = (TextView) viewFindViewById;
            View viewFindViewById2 = itemView.findViewById(C1256R.id.zma_avatar_view);
            Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
            this.avatarView = (AvatarImageView) viewFindViewById2;
            View viewFindViewById3 = itemView.findViewById(C1256R.id.zma_message_content);
            Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
            this.contentView = (LinearLayout) viewFindViewById3;
            View viewFindViewById4 = itemView.findViewById(C1256R.id.zma_message_receipt);
            Intrinsics.checkNotNullExpressionValue(viewFindViewById4, "findViewById(...)");
            this.receiptView = (MessageReceiptView) viewFindViewById4;
        }

        public final void bind(MessageLogEntry.TypingIndicatorContainer item) {
            Intrinsics.checkNotNullParameter(item, "item");
            this.receiptView.setVisibility(8);
            this.labelView.setVisibility(8);
            renderContent();
            renderAvatar(item.getAvatarUrl());
        }

        private final void renderContent() {
            LinearLayout linearLayout = this.contentView;
            linearLayout.removeAllViews();
            linearLayout.addView(createTypingIndicatorCell(this.contentView, this.messagingTheme));
            linearLayout.getLayoutParams().width = -2;
            linearLayout.requestLayout();
        }

        private final View createTypingIndicatorCell(ViewGroup parentView, final MessagingTheme messagingTheme) {
            Context context = parentView.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            TypingIndicatorCellView typingIndicatorCellView = new TypingIndicatorCellView(context, null, 0, 0, 14, null);
            typingIndicatorCellView.render(new Function1<TypingIndicatorCellRendering, TypingIndicatorCellRendering>() {
                {
                    super(1);
                }

                @Override
                public final TypingIndicatorCellRendering invoke(TypingIndicatorCellRendering typingIndicatorCellRendering) {
                    Intrinsics.checkNotNullParameter(typingIndicatorCellRendering, "typingIndicatorCellRendering");
                    TypingIndicatorCellRendering.Builder builder = typingIndicatorCellRendering.toBuilder();
                    final MessagingTheme messagingTheme2 = messagingTheme;
                    return builder.state(new Function1<TypingIndicatorCellState, TypingIndicatorCellState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final TypingIndicatorCellState invoke(TypingIndicatorCellState state) {
                            Intrinsics.checkNotNullParameter(state, "state");
                            return state.copy(Integer.valueOf(messagingTheme2.getInboundMessageColor()), Integer.valueOf(messagingTheme2.getOnBackgroundColor()));
                        }
                    }).build();
                }
            });
            return typingIndicatorCellView;
        }

        private final void renderAvatar(final String avatarUrl) {
            this.avatarView.render(new Function1<AvatarImageRendering, AvatarImageRendering>() {
                {
                    super(1);
                }

                @Override
                public final AvatarImageRendering invoke(AvatarImageRendering rendering) {
                    Intrinsics.checkNotNullParameter(rendering, "rendering");
                    AvatarImageRendering.Builder builder = rendering.toBuilder();
                    final String str = avatarUrl;
                    final TypingIndicatorContainerAdapterDelegate.ViewHolder viewHolder = this;
                    return builder.state(new Function1<AvatarImageState, AvatarImageState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final AvatarImageState invoke(AvatarImageState state) {
                            Intrinsics.checkNotNullParameter(state, "state");
                            return AvatarImageState.copy$default(state, Uri.parse(str), false, 0, Integer.valueOf(viewHolder.messagingTheme.getInboundMessageColor()), AvatarMask.CIRCLE, 6, null);
                        }
                    }).build();
                }
            });
            this.avatarView.setVisibility(0);
        }
    }
}
