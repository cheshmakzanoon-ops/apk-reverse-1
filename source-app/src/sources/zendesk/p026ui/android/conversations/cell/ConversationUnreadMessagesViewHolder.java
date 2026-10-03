package zendesk.p026ui.android.conversations.cell;

import android.content.Context;
import android.view.View;
import android.widget.TextView;
import androidx.core.graphics.drawable.DrawableCompat;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0018\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\b\b\u0001\u0010\r\u001a\u00020\fR\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\b¨\u0006\u000e"}, m18d2 = {"Lzendesk/ui/android/conversations/cell/ConversationUnreadMessagesViewHolder;", "", "view", "Landroid/view/View;", "(Landroid/view/View;)V", "unReadMessagesTextView", "Landroid/widget/TextView;", "getView", "()Landroid/view/View;", "onBind", "", "unreadConversationsCount", "", "unreadMessagesCountColor", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationUnreadMessagesViewHolder {
    public static final int $stable = 8;
    private final TextView unReadMessagesTextView;
    private final View view;

    public ConversationUnreadMessagesViewHolder(View view) {
        Intrinsics.checkNotNullParameter(view, "view");
        this.view = view;
        View viewFindViewById = view.findViewById(R.id.zuia_conversation_unread_count);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.unReadMessagesTextView = (TextView) viewFindViewById;
    }

    public final View getView() {
        return this.view;
    }

    public final void onBind(int unreadConversationsCount, int unreadMessagesCountColor) {
        boolean z = unreadConversationsCount > 0;
        if (z) {
            UnreadMessagesTextHelperConversationCell unreadMessagesTextHelperConversationCell = UnreadMessagesTextHelperConversationCell.INSTANCE;
            Context context = this.unReadMessagesTextView.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            this.unReadMessagesTextView.setText(unreadMessagesTextHelperConversationCell.getUnreadMessagesText$zendesk_ui_ui_android(unreadConversationsCount, context));
            DrawableCompat.setTint(DrawableCompat.wrap(this.unReadMessagesTextView.getBackground()), unreadMessagesCountColor);
        }
        this.unReadMessagesTextView.setVisibility(z ? 0 : 8);
    }
}
