package zendesk.p026ui.android.conversations.cell;

import android.view.View;
import android.widget.TextView;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u001f\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\b\b\u0001\u0010\u000b\u001a\u00020\fH\u0000¢\u0006\u0002\b\rR\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000e"}, m18d2 = {"Lzendesk/ui/android/conversations/cell/ConversationTitleViewHolder;", "", "view", "Landroid/view/View;", "(Landroid/view/View;)V", "conversationTitleTextView", "Landroid/widget/TextView;", "onBind", "", "conversationTitle", "", "conversationTitleTextColorInt", "", "onBind$zendesk_ui_ui_android", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationTitleViewHolder {
    public static final int $stable = 8;
    private final TextView conversationTitleTextView;

    public ConversationTitleViewHolder(View view) {
        Intrinsics.checkNotNullParameter(view, "view");
        View viewFindViewById = view.findViewById(R.id.zuia_conversation_title);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.conversationTitleTextView = (TextView) viewFindViewById;
    }

    public final void onBind$zendesk_ui_ui_android(String conversationTitle, int conversationTitleTextColorInt) {
        Intrinsics.checkNotNullParameter(conversationTitle, "conversationTitle");
        this.conversationTitleTextView.setText(conversationTitle);
        this.conversationTitleTextView.setTextColor(conversationTitleTextColorInt);
    }
}
