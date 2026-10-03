package zendesk.p026ui.android.conversation.messagesdivider;

import android.content.Context;
import androidx.core.content.ContextCompat;
import com.google.android.material.R;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.internal.ColorExtKt;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 \u001e2\u00020\u0001:\u0002\u001d\u001eB5\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0003\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0003\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0003\u0010\u0007\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\bJ\t\u0010\u0010\u001a\u00020\u0003HÆ\u0003J\u0010\u0010\u0011\u001a\u0004\u0018\u00010\u0005HÆ\u0003¢\u0006\u0002\u0010\nJ\u0010\u0010\u0012\u001a\u0004\u0018\u00010\u0005HÆ\u0003¢\u0006\u0002\u0010\nJ\u0010\u0010\u0013\u001a\u0004\u0018\u00010\u0005HÆ\u0003¢\u0006\u0002\u0010\nJ<\u0010\u0014\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0003\u0010\u0004\u001a\u0004\u0018\u00010\u00052\n\b\u0003\u0010\u0006\u001a\u0004\u0018\u00010\u00052\n\b\u0003\u0010\u0007\u001a\u0004\u0018\u00010\u0005HÆ\u0001¢\u0006\u0002\u0010\u0015J\u0013\u0010\u0016\u001a\u00020\u00172\b\u0010\u0018\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0019\u001a\u00020\u0005HÖ\u0001J\u0006\u0010\u001a\u001a\u00020\u001bJ\t\u0010\u001c\u001a\u00020\u0003HÖ\u0001R\u0015\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\n\n\u0002\u0010\u000b\u001a\u0004\b\t\u0010\nR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0015\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\n\n\u0002\u0010\u000b\u001a\u0004\b\u000e\u0010\nR\u0015\u0010\u0007\u001a\u0004\u0018\u00010\u0005¢\u0006\n\n\u0002\u0010\u000b\u001a\u0004\b\u000f\u0010\n¨\u0006\u001f"}, m18d2 = {"Lzendesk/ui/android/conversation/messagesdivider/MessagesDividerState;", "", "text", "", "dividerColor", "", "textColor", "textStyle", "(Ljava/lang/String;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;)V", "getDividerColor", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getText", "()Ljava/lang/String;", "getTextColor", "getTextStyle", "component1", "component2", "component3", "component4", "copy", "(Ljava/lang/String;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;)Lzendesk/ui/android/conversation/messagesdivider/MessagesDividerState;", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/messagesdivider/MessagesDividerState$Builder;", "toString", "Builder", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagesDividerState {
    public static final int $stable = 0;

    public static final Companion INSTANCE = new Companion(null);
    private static final float LABEL_ALPHA = 0.65f;
    private final Integer dividerColor;
    private final String text;
    private final Integer textColor;
    private final Integer textStyle;

    public MessagesDividerState() {
        this(null, null, null, null, 15, null);
    }

    public static MessagesDividerState copy$default(MessagesDividerState messagesDividerState, String str, Integer num, Integer num2, Integer num3, int i, Object obj) {
        if ((i & 1) != 0) {
            str = messagesDividerState.text;
        }
        if ((i & 2) != 0) {
            num = messagesDividerState.dividerColor;
        }
        if ((i & 4) != 0) {
            num2 = messagesDividerState.textColor;
        }
        if ((i & 8) != 0) {
            num3 = messagesDividerState.textStyle;
        }
        return messagesDividerState.copy(str, num, num2, num3);
    }

    public final String getText() {
        return this.text;
    }

    public final Integer getDividerColor() {
        return this.dividerColor;
    }

    public final Integer getTextColor() {
        return this.textColor;
    }

    public final Integer getTextStyle() {
        return this.textStyle;
    }

    public final MessagesDividerState copy(String text, Integer dividerColor, Integer textColor, Integer textStyle) {
        Intrinsics.checkNotNullParameter(text, "text");
        return new MessagesDividerState(text, dividerColor, textColor, textStyle);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof MessagesDividerState)) {
            return false;
        }
        MessagesDividerState messagesDividerState = (MessagesDividerState) other;
        return Intrinsics.areEqual(this.text, messagesDividerState.text) && Intrinsics.areEqual(this.dividerColor, messagesDividerState.dividerColor) && Intrinsics.areEqual(this.textColor, messagesDividerState.textColor) && Intrinsics.areEqual(this.textStyle, messagesDividerState.textStyle);
    }

    public int hashCode() {
        int iHashCode = this.text.hashCode() * 31;
        Integer num = this.dividerColor;
        int iHashCode2 = (iHashCode + (num == null ? 0 : num.hashCode())) * 31;
        Integer num2 = this.textColor;
        int iHashCode3 = (iHashCode2 + (num2 == null ? 0 : num2.hashCode())) * 31;
        Integer num3 = this.textStyle;
        return iHashCode3 + (num3 != null ? num3.hashCode() : 0);
    }

    public String toString() {
        return "MessagesDividerState(text=" + this.text + ", dividerColor=" + this.dividerColor + ", textColor=" + this.textColor + ", textStyle=" + this.textStyle + ')';
    }

    public MessagesDividerState(String text, Integer num, Integer num2, Integer num3) {
        Intrinsics.checkNotNullParameter(text, "text");
        this.text = text;
        this.dividerColor = num;
        this.textColor = num2;
        this.textStyle = num3;
    }

    public MessagesDividerState(String str, Integer num, Integer num2, Integer num3, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? "" : str, (i & 2) != 0 ? null : num, (i & 4) != 0 ? null : num2, (i & 8) != 0 ? null : num3);
    }

    public final String getText() {
        return this.text;
    }

    public final Integer getDividerColor() {
        return this.dividerColor;
    }

    public final Integer getTextColor() {
        return this.textColor;
    }

    public final Integer getTextStyle() {
        return this.textStyle;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0003J\u000e\u0010\u0007\u001a\u00020\u00002\u0006\u0010\u0007\u001a\u00020\bJ\u000e\u0010\t\u001a\u00020\u00002\u0006\u0010\t\u001a\u00020\nJ\u000e\u0010\u000b\u001a\u00020\u00002\u0006\u0010\u000b\u001a\u00020\bJ\u000e\u0010\f\u001a\u00020\u00002\u0006\u0010\f\u001a\u00020\bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"Lzendesk/ui/android/conversation/messagesdivider/MessagesDividerState$Builder;", "", "state", "Lzendesk/ui/android/conversation/messagesdivider/MessagesDividerState;", "(Lzendesk/ui/android/conversation/messagesdivider/MessagesDividerState;)V", "()V", "build", "dividerColor", "", "text", "", "textColor", "textStyle", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private MessagesDividerState state;

        public Builder() {
            this.state = new MessagesDividerState(null, null, null, null, 15, null);
        }

        public Builder(MessagesDividerState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder text(String text) {
            Intrinsics.checkNotNullParameter(text, "text");
            this.state = MessagesDividerState.copy$default(this.state, text, null, null, null, 14, null);
            return this;
        }

        public final Builder dividerColor(int dividerColor) {
            this.state = MessagesDividerState.copy$default(this.state, null, Integer.valueOf(dividerColor), null, null, 13, null);
            return this;
        }

        public final Builder textColor(int textColor) {
            this.state = MessagesDividerState.copy$default(this.state, null, null, Integer.valueOf(textColor), null, 11, null);
            return this;
        }

        public final Builder textStyle(int textStyle) {
            this.state = MessagesDividerState.copy$default(this.state, null, null, null, Integer.valueOf(textStyle), 7, null);
            return this;
        }

        public final MessagesDividerState getState() {
            return this.state;
        }
    }

    @Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000e\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bJ\u0016\u0010\t\u001a\u00020\u00062\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\bR\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"Lzendesk/ui/android/conversation/messagesdivider/MessagesDividerState$Companion;", "", "()V", "LABEL_ALPHA", "", "newMessagesDividerState", "Lzendesk/ui/android/conversation/messagesdivider/MessagesDividerState;", "dividerColor", "", "timeDividerState", "context", "Landroid/content/Context;", "textColor", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final MessagesDividerState newMessagesDividerState(int dividerColor) {
            return new Builder().textStyle(R.style.TextAppearance_MaterialComponents_Body2).dividerColor(dividerColor).textColor(dividerColor).getState();
        }

        public final MessagesDividerState timeDividerState(Context context, int textColor) {
            Intrinsics.checkNotNullParameter(context, "context");
            return new Builder().textStyle(R.style.TextAppearance_MaterialComponents_Caption).dividerColor(ContextCompat.getColor(context, zendesk.ui.android.R.color.zuia_color_transparent)).textColor(ColorExtKt.adjustAlpha(textColor, 0.65f)).getState();
        }
    }
}
