package zendesk.p026ui.android.conversation.bottomsheet;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import net.aihelp.data.model.p005cs.ConversationMsg;
import okhttp3.internal.p011ws.WebSocketProtocol;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b \n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001-BS\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0006\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b\u0012\n\b\u0003\u0010\t\u001a\u0004\u0018\u00010\n\u0012\n\b\u0003\u0010\u000b\u001a\u0004\u0018\u00010\n\u0012\n\b\u0003\u0010\f\u001a\u0004\u0018\u00010\n¢\u0006\u0002\u0010\rJ\u000e\u0010\u001a\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u001bJ\u000e\u0010\u001c\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u001dJ\u000e\u0010\u001e\u001a\u00020\u0006HÀ\u0003¢\u0006\u0002\b\u001fJ\u000e\u0010 \u001a\u00020\bHÀ\u0003¢\u0006\u0002\b!J\u0010\u0010\"\u001a\u0004\u0018\u00010\nHÆ\u0003¢\u0006\u0002\u0010\u0011J\u0010\u0010#\u001a\u0004\u0018\u00010\nHÆ\u0003¢\u0006\u0002\u0010\u0011J\u0010\u0010$\u001a\u0004\u0018\u00010\nHÆ\u0003¢\u0006\u0002\u0010\u0011JZ\u0010%\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\b2\n\b\u0003\u0010\t\u001a\u0004\u0018\u00010\n2\n\b\u0003\u0010\u000b\u001a\u0004\u0018\u00010\n2\n\b\u0003\u0010\f\u001a\u0004\u0018\u00010\nHÆ\u0001¢\u0006\u0002\u0010&J\u0013\u0010'\u001a\u00020\b2\b\u0010(\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010)\u001a\u00020\nHÖ\u0001J\u0006\u0010*\u001a\u00020+J\t\u0010,\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0015\u0010\f\u001a\u0004\u0018\u00010\n¢\u0006\n\n\u0002\u0010\u0012\u001a\u0004\b\u0010\u0010\u0011R\u0015\u0010\t\u001a\u0004\u0018\u00010\n¢\u0006\n\n\u0002\u0010\u0012\u001a\u0004\b\u0013\u0010\u0011R\u0014\u0010\u0005\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u000fR\u0015\u0010\u000b\u001a\u0004\u0018\u00010\n¢\u0006\n\n\u0002\u0010\u0012\u001a\u0004\b\u0017\u0010\u0011R\u0014\u0010\u0007\u001a\u00020\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019¨\u0006."}, m18d2 = {"Lzendesk/ui/android/conversation/bottomsheet/BottomSheetState;", "", "messageText", "", "actionText", "duration", "", "showBottomSheet", "", "backgroundColor", "", "messageTextColor", "actionTextColor", "(Ljava/lang/String;Ljava/lang/String;JZLjava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;)V", "getActionText$zendesk_ui_ui_android", "()Ljava/lang/String;", "getActionTextColor", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getBackgroundColor", "getDuration$zendesk_ui_ui_android", "()J", "getMessageText$zendesk_ui_ui_android", "getMessageTextColor", "getShowBottomSheet$zendesk_ui_ui_android", "()Z", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component6", "component7", "copy", "(Ljava/lang/String;Ljava/lang/String;JZLjava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;)Lzendesk/ui/android/conversation/bottomsheet/BottomSheetState;", "equals", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/bottomsheet/BottomSheetState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class BottomSheetState {
    public static final int $stable = 0;
    private final String actionText;
    private final Integer actionTextColor;
    private final Integer backgroundColor;
    private final long duration;
    private final String messageText;
    private final Integer messageTextColor;
    private final boolean showBottomSheet;

    public BottomSheetState() {
        this(null, null, 0L, false, null, null, null, 127, null);
    }

    public static BottomSheetState copy$default(BottomSheetState bottomSheetState, String str, String str2, long j, boolean z, Integer num, Integer num2, Integer num3, int i, Object obj) {
        return bottomSheetState.copy((i & 1) != 0 ? bottomSheetState.messageText : str, (i & 2) != 0 ? bottomSheetState.actionText : str2, (i & 4) != 0 ? bottomSheetState.duration : j, (i & 8) != 0 ? bottomSheetState.showBottomSheet : z, (i & 16) != 0 ? bottomSheetState.backgroundColor : num, (i & 32) != 0 ? bottomSheetState.messageTextColor : num2, (i & 64) != 0 ? bottomSheetState.actionTextColor : num3);
    }

    public final String getMessageText() {
        return this.messageText;
    }

    public final String getActionText() {
        return this.actionText;
    }

    public final long getDuration() {
        return this.duration;
    }

    public final boolean getShowBottomSheet() {
        return this.showBottomSheet;
    }

    public final Integer getBackgroundColor() {
        return this.backgroundColor;
    }

    public final Integer getMessageTextColor() {
        return this.messageTextColor;
    }

    public final Integer getActionTextColor() {
        return this.actionTextColor;
    }

    public final BottomSheetState copy(String messageText, String actionText, long duration, boolean showBottomSheet, Integer backgroundColor, Integer messageTextColor, Integer actionTextColor) {
        Intrinsics.checkNotNullParameter(messageText, "messageText");
        Intrinsics.checkNotNullParameter(actionText, "actionText");
        return new BottomSheetState(messageText, actionText, duration, showBottomSheet, backgroundColor, messageTextColor, actionTextColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof BottomSheetState)) {
            return false;
        }
        BottomSheetState bottomSheetState = (BottomSheetState) other;
        return Intrinsics.areEqual(this.messageText, bottomSheetState.messageText) && Intrinsics.areEqual(this.actionText, bottomSheetState.actionText) && this.duration == bottomSheetState.duration && this.showBottomSheet == bottomSheetState.showBottomSheet && Intrinsics.areEqual(this.backgroundColor, bottomSheetState.backgroundColor) && Intrinsics.areEqual(this.messageTextColor, bottomSheetState.messageTextColor) && Intrinsics.areEqual(this.actionTextColor, bottomSheetState.actionTextColor);
    }

    public int hashCode() {
        int iHashCode = ((((((this.messageText.hashCode() * 31) + this.actionText.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.duration)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.showBottomSheet)) * 31;
        Integer num = this.backgroundColor;
        int iHashCode2 = (iHashCode + (num == null ? 0 : num.hashCode())) * 31;
        Integer num2 = this.messageTextColor;
        int iHashCode3 = (iHashCode2 + (num2 == null ? 0 : num2.hashCode())) * 31;
        Integer num3 = this.actionTextColor;
        return iHashCode3 + (num3 != null ? num3.hashCode() : 0);
    }

    public String toString() {
        return "BottomSheetState(messageText=" + this.messageText + ", actionText=" + this.actionText + ", duration=" + this.duration + ", showBottomSheet=" + this.showBottomSheet + ", backgroundColor=" + this.backgroundColor + ", messageTextColor=" + this.messageTextColor + ", actionTextColor=" + this.actionTextColor + ')';
    }

    public BottomSheetState(String messageText, String actionText, long j, boolean z, Integer num, Integer num2, Integer num3) {
        Intrinsics.checkNotNullParameter(messageText, "messageText");
        Intrinsics.checkNotNullParameter(actionText, "actionText");
        this.messageText = messageText;
        this.actionText = actionText;
        this.duration = j;
        this.showBottomSheet = z;
        this.backgroundColor = num;
        this.messageTextColor = num2;
        this.actionTextColor = num3;
    }

    public BottomSheetState(String str, String str2, long j, boolean z, Integer num, Integer num2, Integer num3, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? "" : str, (i & 2) == 0 ? str2 : "", (i & 4) != 0 ? 5000L : j, (i & 8) != 0 ? false : z, (i & 16) != 0 ? null : num, (i & 32) != 0 ? null : num2, (i & 64) == 0 ? num3 : null);
    }

    public final String getMessageText$zendesk_ui_ui_android() {
        return this.messageText;
    }

    public final String getActionText$zendesk_ui_ui_android() {
        return this.actionText;
    }

    public final long getDuration$zendesk_ui_ui_android() {
        return this.duration;
    }

    public final boolean getShowBottomSheet$zendesk_ui_ui_android() {
        return this.showBottomSheet;
    }

    public final Integer getBackgroundColor() {
        return this.backgroundColor;
    }

    public final Integer getMessageTextColor() {
        return this.messageTextColor;
    }

    public final Integer getActionTextColor() {
        return this.actionTextColor;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u000e\u0010\u0006\u001a\u00020\u00002\u0006\u0010\u0007\u001a\u00020\bJ\u0010\u0010\t\u001a\u00020\u00002\b\b\u0001\u0010\n\u001a\u00020\u000bJ\u0010\u0010\f\u001a\u00020\u00002\b\b\u0001\u0010\n\u001a\u00020\u000bJ\u0006\u0010\r\u001a\u00020\u0003J\u000e\u0010\u000e\u001a\u00020\u00002\u0006\u0010\u000e\u001a\u00020\u000fJ\u000e\u0010\u0010\u001a\u00020\u00002\u0006\u0010\u0007\u001a\u00020\bJ\u0010\u0010\u0011\u001a\u00020\u00002\b\b\u0001\u0010\n\u001a\u00020\u000bJ\u000e\u0010\u0012\u001a\u00020\u00002\u0006\u0010\u0012\u001a\u00020\u0013R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0014"}, m18d2 = {"Lzendesk/ui/android/conversation/bottomsheet/BottomSheetState$Builder;", "", "state", "Lzendesk/ui/android/conversation/bottomsheet/BottomSheetState;", "(Lzendesk/ui/android/conversation/bottomsheet/BottomSheetState;)V", "()V", "actionText", "text", "", "actionTextColor", "color", "", "backgroundColor", "build", "duration", "", "messageText", "messageTextColor", "showBottomSheet", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private BottomSheetState state;

        public Builder() {
            this.state = new BottomSheetState(null, null, 0L, false, null, null, null, 127, null);
        }

        public Builder(BottomSheetState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder messageText(String text) {
            Intrinsics.checkNotNullParameter(text, "text");
            this.state = BottomSheetState.copy$default(this.state, text, null, 0L, false, null, null, null, WebSocketProtocol.PAYLOAD_SHORT, null);
            return this;
        }

        public final Builder actionText(String text) {
            Intrinsics.checkNotNullParameter(text, "text");
            this.state = BottomSheetState.copy$default(this.state, null, text, 0L, false, null, null, null, 125, null);
            return this;
        }

        public final Builder duration(long duration) {
            this.state = BottomSheetState.copy$default(this.state, null, null, duration, false, null, null, null, 123, null);
            return this;
        }

        public final Builder showBottomSheet(boolean showBottomSheet) {
            this.state = BottomSheetState.copy$default(this.state, null, null, 0L, showBottomSheet, null, null, null, 119, null);
            return this;
        }

        public final Builder backgroundColor(int color) {
            this.state = BottomSheetState.copy$default(this.state, null, null, 0L, false, Integer.valueOf(color), null, null, ConversationMsg.TYPE_ADMIN_TYPING, null);
            return this;
        }

        public final Builder messageTextColor(int color) {
            this.state = BottomSheetState.copy$default(this.state, null, null, 0L, false, null, Integer.valueOf(color), null, 95, null);
            return this;
        }

        public final Builder actionTextColor(int color) {
            this.state = BottomSheetState.copy$default(this.state, null, null, 0L, false, null, null, Integer.valueOf(color), 63, null);
            return this;
        }

        public final BottomSheetState getState() {
            return this.state;
        }
    }
}
