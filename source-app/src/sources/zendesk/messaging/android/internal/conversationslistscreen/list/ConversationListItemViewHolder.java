package zendesk.messaging.android.internal.conversationslistscreen.list;

import android.view.View;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.conversations.cell.ConversationCellState;
import zendesk.p026ui.android.conversations.cell.ConversationCellView;

@Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u000f\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u000e\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\t"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationListItemViewHolder;", "Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListViewHolder;", "conversationCellView", "Lzendesk/ui/android/conversations/cell/ConversationCellView;", "(Lzendesk/ui/android/conversations/cell/ConversationCellView;)V", "onBind", "", "conversationCellState", "Lzendesk/ui/android/conversations/cell/ConversationCellState;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationListItemViewHolder extends ConversationsListViewHolder {
    private final ConversationCellView conversationCellView;

    public ConversationListItemViewHolder(ConversationCellView conversationCellView) {
        super((View) conversationCellView);
        Intrinsics.checkNotNullParameter(conversationCellView, "conversationCellView");
        this.conversationCellView = conversationCellView;
    }

    public final void onBind(ConversationCellState conversationCellState) {
        Intrinsics.checkNotNullParameter(conversationCellState, "conversationCellState");
        this.conversationCellView.onBind(conversationCellState);
    }
}
