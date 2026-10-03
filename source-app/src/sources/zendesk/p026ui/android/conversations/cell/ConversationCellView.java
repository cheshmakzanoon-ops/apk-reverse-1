package zendesk.p026ui.android.conversations.cell;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.xml.AccessibilityExtKt;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0004\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u0010\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u0003H\u0016J\b\u0010\u0019\u001a\u00020\u0017H\u0014J\u0014\u0010\u001a\u001a\u00020\u0017*\u00020\u00002\u0006\u0010\u0018\u001a\u00020\u0003H\u0002R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0013X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0015X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001b"}, m18d2 = {"Lzendesk/ui/android/conversations/cell/ConversationCellView;", "Landroidx/constraintlayout/widget/ConstraintLayout;", "Lzendesk/ui/android/conversations/cell/ViewHolderBinder;", "Lzendesk/ui/android/conversations/cell/ConversationCellState;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "conversationAvatarViewHolder", "Lzendesk/ui/android/conversations/cell/ConversationAvatarViewHolder;", "conversationDateTimeStampViewHolder", "Lzendesk/ui/android/conversations/cell/ConversationDateTimeStampViewHolder;", "conversationLastMessageViewHolder", "Lzendesk/ui/android/conversations/cell/ConversationLastMessageViewHolder;", "conversationTitleViewHolder", "Lzendesk/ui/android/conversations/cell/ConversationTitleViewHolder;", "conversationUnreadMessagesViewHolder", "Lzendesk/ui/android/conversations/cell/ConversationUnreadMessagesViewHolder;", "onBind", "", "viewState", "onDetachedFromWindow", "updateAccessibility", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationCellView extends ConstraintLayout implements ViewHolderBinder<ConversationCellState> {
    public static final int $stable = 8;
    private final ConversationAvatarViewHolder conversationAvatarViewHolder;
    private final ConversationDateTimeStampViewHolder conversationDateTimeStampViewHolder;
    private final ConversationLastMessageViewHolder conversationLastMessageViewHolder;
    private final ConversationTitleViewHolder conversationTitleViewHolder;
    private final ConversationUnreadMessagesViewHolder conversationUnreadMessagesViewHolder;

    public ConversationCellView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationCellView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationCellView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ConversationCellView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public ConversationCellView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_ConversationCellStyle, false);
        View viewInflate = ConstraintLayout.inflate(context, R.layout.zuia_view_conversation_cell, (ViewGroup) this);
        Intrinsics.checkNotNull(viewInflate);
        this.conversationAvatarViewHolder = new ConversationAvatarViewHolder(viewInflate);
        this.conversationTitleViewHolder = new ConversationTitleViewHolder(viewInflate);
        this.conversationLastMessageViewHolder = new ConversationLastMessageViewHolder(viewInflate);
        this.conversationDateTimeStampViewHolder = new ConversationDateTimeStampViewHolder(viewInflate);
        this.conversationUnreadMessagesViewHolder = new ConversationUnreadMessagesViewHolder(viewInflate);
    }

    public static final void onBind$lambda$0(ConversationCellState viewState, View view) {
        Intrinsics.checkNotNullParameter(viewState, "$viewState");
        viewState.getClickListener().invoke();
    }

    @Override
    public void onBind(final ConversationCellState viewState) {
        Intrinsics.checkNotNullParameter(viewState, "viewState");
        setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                ConversationCellView.onBind$lambda$0(viewState, view);
            }
        });
        updateAccessibility(this, viewState);
        int unreadMessagesCount = viewState.getUnreadMessagesCount();
        this.conversationAvatarViewHolder.onBind$zendesk_ui_ui_android(viewState.getAvatarImageState());
        this.conversationTitleViewHolder.onBind$zendesk_ui_ui_android(viewState.getConversationTitle(), viewState.getConversationTitleTextColor());
        this.conversationLastMessageViewHolder.onBind$zendesk_ui_ui_android(viewState.getLastMessage(), unreadMessagesCount, viewState.getLastMessageTextColor());
        this.conversationDateTimeStampViewHolder.onBind$zendesk_ui_ui_android(viewState.getDateTimeStamp(), viewState.getDateTimestampTextColor());
        this.conversationUnreadMessagesViewHolder.onBind(unreadMessagesCount, viewState.getUnreadMessagesCountColor());
    }

    protected void onDetachedFromWindow() {
        this.conversationAvatarViewHolder.onUnbind$zendesk_ui_ui_android();
        super.onDetachedFromWindow();
    }

    private final void updateAccessibility(ConversationCellView conversationCellView, ConversationCellState conversationCellState) {
        String name = Button.class.getName();
        Intrinsics.checkNotNullExpressionValue(name, "getName(...)");
        AccessibilityExtKt.overrideAccessibilityNodeClassNameInfo((View) conversationCellView, name);
        conversationCellView.setContentDescription(conversationCellState.getAccessibilityTitle());
    }
}
