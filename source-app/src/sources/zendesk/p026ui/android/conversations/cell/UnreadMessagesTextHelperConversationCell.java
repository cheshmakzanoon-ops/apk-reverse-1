package zendesk.p026ui.android.conversations.cell;

import android.content.Context;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u001d\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\tH\u0000¢\u0006\u0002\b\nR\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u000b"}, m18d2 = {"Lzendesk/ui/android/conversations/cell/UnreadMessagesTextHelperConversationCell;", "", "()V", "MAX_CONVERSATIONS", "", "getUnreadMessagesText", "", "toRender", "context", "Landroid/content/Context;", "getUnreadMessagesText$zendesk_ui_ui_android", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class UnreadMessagesTextHelperConversationCell {
    public static final int $stable = 0;
    public static final UnreadMessagesTextHelperConversationCell INSTANCE = new UnreadMessagesTextHelperConversationCell();
    private static final int MAX_CONVERSATIONS = 99;

    private UnreadMessagesTextHelperConversationCell() {
    }

    public final String getUnreadMessagesText$zendesk_ui_ui_android(int toRender, Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        if (toRender > MAX_CONVERSATIONS) {
            String string = context.getString(R.string.zuia_conversation_list_item_unread_indicator_maximum);
            Intrinsics.checkNotNull(string);
            return string;
        }
        return String.valueOf(toRender);
    }
}
