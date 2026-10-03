package zendesk.p026ui.android.conversation.messagesdivider;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.widget.TextViewCompat;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u001c\u0010\u0013\u001a\u00020\u00142\u0012\u0010\u0015\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0016H\u0016R\u000e\u0010\f\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0017"}, m18d2 = {"Lzendesk/ui/android/conversation/messagesdivider/MessagesDividerView;", "Landroidx/constraintlayout/widget/ConstraintLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/messagesdivider/MessagesDividerRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "dividerView", "messageDividerEnd", "Landroid/view/View;", "messageDividerStart", "messageDividerText", "Landroid/widget/TextView;", "rendering", "render", "", "renderingUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagesDividerView extends ConstraintLayout implements Renderer<MessagesDividerRendering> {
    public static final int $stable = 8;
    private final ConstraintLayout dividerView;
    private final View messageDividerEnd;
    private final View messageDividerStart;
    private final TextView messageDividerText;
    private MessagesDividerRendering rendering;

    public MessagesDividerView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public MessagesDividerView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public MessagesDividerView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public MessagesDividerView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public MessagesDividerView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new MessagesDividerRendering();
        ConstraintLayout.inflate(context, R.layout.zuia_view_messages_divider, (ViewGroup) this);
        View viewFindViewById = findViewById(R.id.zui_message_divider_text);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.messageDividerText = (TextView) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zui_divider_view_start);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.messageDividerStart = viewFindViewById2;
        View viewFindViewById3 = findViewById(R.id.zui_divider_view_end);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        this.messageDividerEnd = viewFindViewById3;
        ConstraintLayout constraintLayoutFindViewById = findViewById(R.id.zui_message_divider);
        Intrinsics.checkNotNullExpressionValue(constraintLayoutFindViewById, "findViewById(...)");
        this.dividerView = constraintLayoutFindViewById;
        render(new Function1<MessagesDividerRendering, MessagesDividerRendering>() {
            @Override
            public final MessagesDividerRendering invoke(MessagesDividerRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super MessagesDividerRendering, MessagesDividerRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        MessagesDividerRendering messagesDividerRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = messagesDividerRenderingInvoke;
        Integer dividerColor = messagesDividerRenderingInvoke.getState().getDividerColor();
        if (dividerColor != null) {
            this.messageDividerStart.setBackgroundColor(dividerColor.intValue());
        }
        Integer dividerColor2 = this.rendering.getState().getDividerColor();
        if (dividerColor2 != null) {
            this.messageDividerEnd.setBackgroundColor(dividerColor2.intValue());
        }
        this.messageDividerText.setText(this.rendering.getState().getText());
        Integer textStyle = this.rendering.getState().getTextStyle();
        if (textStyle != null) {
            TextViewCompat.setTextAppearance(this.messageDividerText, textStyle.intValue());
        }
        Integer textColor = this.rendering.getState().getTextColor();
        if (textColor != null) {
            this.messageDividerText.setTextColor(textColor.intValue());
        }
    }
}
