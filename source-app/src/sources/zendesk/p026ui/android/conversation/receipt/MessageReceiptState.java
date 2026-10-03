package zendesk.p026ui.android.conversation.receipt;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b \n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001,BE\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007\u0012\n\b\u0003\u0010\b\u001a\u0004\u0018\u00010\t\u0012\n\b\u0003\u0010\n\u001a\u0004\u0018\u00010\t\u0012\b\b\u0002\u0010\u000b\u001a\u00020\u0007¢\u0006\u0002\u0010\fJ\u000e\u0010\u0018\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0019J\u000e\u0010\u001a\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b\u001bJ\u000e\u0010\u001c\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\b\u001dJ\u0012\u0010\u001e\u001a\u0004\u0018\u00010\tHÀ\u0003¢\u0006\u0004\b\u001f\u0010\u000eJ\u0012\u0010 \u001a\u0004\u0018\u00010\tHÀ\u0003¢\u0006\u0004\b!\u0010\u000eJ\u000e\u0010\"\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\b#JN\u0010$\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\n\b\u0003\u0010\b\u001a\u0004\u0018\u00010\t2\n\b\u0003\u0010\n\u001a\u0004\u0018\u00010\t2\b\b\u0002\u0010\u000b\u001a\u00020\u0007HÆ\u0001¢\u0006\u0002\u0010%J\u0013\u0010&\u001a\u00020\u00072\b\u0010'\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010(\u001a\u00020\tHÖ\u0001J\u0006\u0010)\u001a\u00020*J\t\u0010+\u001a\u00020\u0003HÖ\u0001R\u0018\u0010\n\u001a\u0004\u0018\u00010\tX\u0080\u0004¢\u0006\n\n\u0002\u0010\u000f\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0018\u0010\b\u001a\u0004\u0018\u00010\tX\u0080\u0004¢\u0006\n\n\u0002\u0010\u000f\u001a\u0004\b\u0012\u0010\u000eR\u0014\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0014\u0010\u000b\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0014\u0010\u0006\u001a\u00020\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0016¨\u0006-"}, m18d2 = {"Lzendesk/ui/android/conversation/receipt/MessageReceiptState;", "", "label", "", "messageReceiptPosition", "Lzendesk/ui/android/conversation/receipt/MessageReceiptPosition;", "showIcon", "", "labelColor", "", "iconColor", "shouldAnimateReceipt", "(Ljava/lang/String;Lzendesk/ui/android/conversation/receipt/MessageReceiptPosition;ZLjava/lang/Integer;Ljava/lang/Integer;Z)V", "getIconColor$zendesk_ui_ui_android", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getLabel$zendesk_ui_ui_android", "()Ljava/lang/String;", "getLabelColor$zendesk_ui_ui_android", "getMessageReceiptPosition$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/receipt/MessageReceiptPosition;", "getShouldAnimateReceipt$zendesk_ui_ui_android", "()Z", "getShowIcon$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "copy", "(Ljava/lang/String;Lzendesk/ui/android/conversation/receipt/MessageReceiptPosition;ZLjava/lang/Integer;Ljava/lang/Integer;Z)Lzendesk/ui/android/conversation/receipt/MessageReceiptState;", "equals", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/receipt/MessageReceiptState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageReceiptState {
    public static final int $stable = 0;
    private final Integer iconColor;
    private final String label;
    private final Integer labelColor;
    private final MessageReceiptPosition messageReceiptPosition;
    private final boolean shouldAnimateReceipt;
    private final boolean showIcon;

    public MessageReceiptState() {
        this(null, null, false, null, null, false, 63, null);
    }

    public static MessageReceiptState copy$default(MessageReceiptState messageReceiptState, String str, MessageReceiptPosition messageReceiptPosition, boolean z, Integer num, Integer num2, boolean z2, int i, Object obj) {
        if ((i & 1) != 0) {
            str = messageReceiptState.label;
        }
        if ((i & 2) != 0) {
            messageReceiptPosition = messageReceiptState.messageReceiptPosition;
        }
        MessageReceiptPosition messageReceiptPosition2 = messageReceiptPosition;
        if ((i & 4) != 0) {
            z = messageReceiptState.showIcon;
        }
        boolean z3 = z;
        if ((i & 8) != 0) {
            num = messageReceiptState.labelColor;
        }
        Integer num3 = num;
        if ((i & 16) != 0) {
            num2 = messageReceiptState.iconColor;
        }
        Integer num4 = num2;
        if ((i & 32) != 0) {
            z2 = messageReceiptState.shouldAnimateReceipt;
        }
        return messageReceiptState.copy(str, messageReceiptPosition2, z3, num3, num4, z2);
    }

    public final String getLabel() {
        return this.label;
    }

    public final MessageReceiptPosition getMessageReceiptPosition() {
        return this.messageReceiptPosition;
    }

    public final boolean getShowIcon() {
        return this.showIcon;
    }

    public final Integer getLabelColor() {
        return this.labelColor;
    }

    public final Integer getIconColor() {
        return this.iconColor;
    }

    public final boolean getShouldAnimateReceipt() {
        return this.shouldAnimateReceipt;
    }

    public final MessageReceiptState copy(String label, MessageReceiptPosition messageReceiptPosition, boolean showIcon, Integer labelColor, Integer iconColor, boolean shouldAnimateReceipt) {
        Intrinsics.checkNotNullParameter(label, "label");
        Intrinsics.checkNotNullParameter(messageReceiptPosition, "messageReceiptPosition");
        return new MessageReceiptState(label, messageReceiptPosition, showIcon, labelColor, iconColor, shouldAnimateReceipt);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof MessageReceiptState)) {
            return false;
        }
        MessageReceiptState messageReceiptState = (MessageReceiptState) other;
        return Intrinsics.areEqual(this.label, messageReceiptState.label) && this.messageReceiptPosition == messageReceiptState.messageReceiptPosition && this.showIcon == messageReceiptState.showIcon && Intrinsics.areEqual(this.labelColor, messageReceiptState.labelColor) && Intrinsics.areEqual(this.iconColor, messageReceiptState.iconColor) && this.shouldAnimateReceipt == messageReceiptState.shouldAnimateReceipt;
    }

    public int hashCode() {
        int iHashCode = ((((this.label.hashCode() * 31) + this.messageReceiptPosition.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.showIcon)) * 31;
        Integer num = this.labelColor;
        int iHashCode2 = (iHashCode + (num == null ? 0 : num.hashCode())) * 31;
        Integer num2 = this.iconColor;
        return ((iHashCode2 + (num2 != null ? num2.hashCode() : 0)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldAnimateReceipt);
    }

    public String toString() {
        return "MessageReceiptState(label=" + this.label + ", messageReceiptPosition=" + this.messageReceiptPosition + ", showIcon=" + this.showIcon + ", labelColor=" + this.labelColor + ", iconColor=" + this.iconColor + ", shouldAnimateReceipt=" + this.shouldAnimateReceipt + ')';
    }

    public MessageReceiptState(String label, MessageReceiptPosition messageReceiptPosition, boolean z, Integer num, Integer num2, boolean z2) {
        Intrinsics.checkNotNullParameter(label, "label");
        Intrinsics.checkNotNullParameter(messageReceiptPosition, "messageReceiptPosition");
        this.label = label;
        this.messageReceiptPosition = messageReceiptPosition;
        this.showIcon = z;
        this.labelColor = num;
        this.iconColor = num2;
        this.shouldAnimateReceipt = z2;
    }

    public MessageReceiptState(String str, MessageReceiptPosition messageReceiptPosition, boolean z, Integer num, Integer num2, boolean z2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? "" : str, (i & 2) != 0 ? MessageReceiptPosition.NONE : messageReceiptPosition, (i & 4) != 0 ? true : z, (i & 8) != 0 ? null : num, (i & 16) != 0 ? null : num2, (i & 32) != 0 ? false : z2);
    }

    public final String getLabel$zendesk_ui_ui_android() {
        return this.label;
    }

    public final MessageReceiptPosition getMessageReceiptPosition$zendesk_ui_ui_android() {
        return this.messageReceiptPosition;
    }

    public final boolean getShowIcon$zendesk_ui_ui_android() {
        return this.showIcon;
    }

    public final Integer getLabelColor$zendesk_ui_ui_android() {
        return this.labelColor;
    }

    public final Integer getIconColor$zendesk_ui_ui_android() {
        return this.iconColor;
    }

    public final boolean getShouldAnimateReceipt$zendesk_ui_ui_android() {
        return this.shouldAnimateReceipt;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0003J\u0010\u0010\u0007\u001a\u00020\u00002\b\b\u0001\u0010\b\u001a\u00020\tJ\u000e\u0010\n\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u000bJ\u0010\u0010\f\u001a\u00020\u00002\b\b\u0001\u0010\b\u001a\u00020\tJ\u000e\u0010\r\u001a\u00020\u00002\u0006\u0010\r\u001a\u00020\u000eJ\u000e\u0010\u000f\u001a\u00020\u00002\u0006\u0010\u0010\u001a\u00020\u0011J\u000e\u0010\u0012\u001a\u00020\u00002\u0006\u0010\u0010\u001a\u00020\u0011R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/conversation/receipt/MessageReceiptState$Builder;", "", "state", "Lzendesk/ui/android/conversation/receipt/MessageReceiptState;", "(Lzendesk/ui/android/conversation/receipt/MessageReceiptState;)V", "()V", "build", "iconColor", "color", "", "label", "", "labelColor", "messageReceiptPosition", "Lzendesk/ui/android/conversation/receipt/MessageReceiptPosition;", "shouldAnimateReceipt", "value", "", "showIcon", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private MessageReceiptState state;

        public Builder() {
            this.state = new MessageReceiptState(null, null, false, null, null, false, 63, null);
        }

        public Builder(MessageReceiptState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder label(String label) {
            Intrinsics.checkNotNullParameter(label, "label");
            this.state = MessageReceiptState.copy$default(this.state, label, null, false, null, null, false, 62, null);
            return this;
        }

        public final Builder messageReceiptPosition(MessageReceiptPosition messageReceiptPosition) {
            Intrinsics.checkNotNullParameter(messageReceiptPosition, "messageReceiptPosition");
            this.state = MessageReceiptState.copy$default(this.state, null, messageReceiptPosition, false, null, null, false, 61, null);
            return this;
        }

        public final Builder showIcon(boolean value) {
            this.state = MessageReceiptState.copy$default(this.state, null, null, value, null, null, false, 59, null);
            return this;
        }

        public final Builder labelColor(int color) {
            this.state = MessageReceiptState.copy$default(this.state, null, null, false, Integer.valueOf(color), null, false, 55, null);
            return this;
        }

        public final Builder iconColor(int color) {
            this.state = MessageReceiptState.copy$default(this.state, null, null, false, null, Integer.valueOf(color), false, 47, null);
            return this;
        }

        public final Builder shouldAnimateReceipt(boolean value) {
            this.state = MessageReceiptState.copy$default(this.state, null, null, false, null, null, value, 31, null);
            return this;
        }

        public final MessageReceiptState getState() {
            return this.state;
        }
    }
}
