package zendesk.p026ui.android.conversations.cell;

import android.view.View;
import android.widget.TextView;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\b\u0000\u0018\u0000 \u000e2\u00020\u0001:\u0001\u000eB\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u001f\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\b\b\u0001\u0010\u000b\u001a\u00020\fH\u0000¢\u0006\u0002\b\rR\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000f"}, m18d2 = {"Lzendesk/ui/android/conversations/cell/ConversationDateTimeStampViewHolder;", "", "view", "Landroid/view/View;", "(Landroid/view/View;)V", "dateTimeStampTextView", "Landroid/widget/TextView;", "onBind", "", "formattedDate", "", "dateTimeStampColor", "", "onBind$zendesk_ui_ui_android", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationDateTimeStampViewHolder {
    public static final float DATE_TIMESTAMP_TEXT_ALPHA = 0.65f;
    private final TextView dateTimeStampTextView;
    public static final int $stable = 8;

    public ConversationDateTimeStampViewHolder(View view) {
        Intrinsics.checkNotNullParameter(view, "view");
        View viewFindViewById = view.findViewById(R.id.zuia_conversation_date_timestamp);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.dateTimeStampTextView = (TextView) viewFindViewById;
    }

    public final void onBind$zendesk_ui_ui_android(String formattedDate, int dateTimeStampColor) {
        Intrinsics.checkNotNullParameter(formattedDate, "formattedDate");
        this.dateTimeStampTextView.setText(formattedDate);
        this.dateTimeStampTextView.setAlpha(0.65f);
        this.dateTimeStampTextView.setTextColor(dateTimeStampColor);
    }
}
