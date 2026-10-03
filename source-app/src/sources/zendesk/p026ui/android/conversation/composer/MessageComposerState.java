package zendesk.p026ui.android.conversation.composer;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b*\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001<Bu\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b\u0012\b\b\u0002\u0010\t\u001a\u00020\b\u0012\b\b\u0003\u0010\n\u001a\u00020\b\u0012\b\b\u0003\u0010\u000b\u001a\u00020\b\u0012\b\b\u0003\u0010\f\u001a\u00020\b\u0012\b\b\u0003\u0010\r\u001a\u00020\b\u0012\b\b\u0002\u0010\u000e\u001a\u00020\u000f¢\u0006\u0002\u0010\u0010J\u000e\u0010\u001f\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b J\u000e\u0010!\u001a\u00020\bHÀ\u0003¢\u0006\u0002\b\"J\u000e\u0010#\u001a\u00020\u000fHÀ\u0003¢\u0006\u0002\b$J\u000e\u0010%\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b&J\u000e\u0010'\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b(J\u000e\u0010)\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b*J\u000e\u0010+\u001a\u00020\bHÀ\u0003¢\u0006\u0002\b,J\u000e\u0010-\u001a\u00020\bHÀ\u0003¢\u0006\u0002\b.J\u000e\u0010/\u001a\u00020\bHÀ\u0003¢\u0006\u0002\b0J\u000e\u00101\u001a\u00020\bHÀ\u0003¢\u0006\u0002\b2J\u000e\u00103\u001a\u00020\bHÀ\u0003¢\u0006\u0002\b4Jw\u00105\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\b2\b\b\u0003\u0010\n\u001a\u00020\b2\b\b\u0003\u0010\u000b\u001a\u00020\b2\b\b\u0003\u0010\f\u001a\u00020\b2\b\b\u0003\u0010\r\u001a\u00020\b2\b\b\u0002\u0010\u000e\u001a\u00020\u000fHÆ\u0001J\u0013\u00106\u001a\u00020\u00032\b\u00107\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u00108\u001a\u00020\bHÖ\u0001J\u0006\u00109\u001a\u00020:J\t\u0010;\u001a\u00020\u000fHÖ\u0001R\u0014\u0010\u000b\u001a\u00020\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0014\u0010\f\u001a\u00020\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0012R\u0014\u0010\u0004\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0014\u0010\u000e\u001a\u00020\u000fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0015R\u0014\u0010\u0005\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0015R\u0014\u0010\t\u001a\u00020\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0012R\u0014\u0010\n\u001a\u00020\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0012R\u0014\u0010\u0006\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u0015R\u0014\u0010\r\u001a\u00020\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u0012R\u0014\u0010\u0007\u001a\u00020\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u0012¨\u0006="}, m18d2 = {"Lzendesk/ui/android/conversation/composer/MessageComposerState;", "", "enabled", "", "cameraSupported", "gallerySupported", "showAttachment", "visibility", "", "inputMaxLength", "sendButtonColor", "attachButtonColor", "borderColor", "textColor", "composerText", "", "(ZZZZIIIIIILjava/lang/String;)V", "getAttachButtonColor$zendesk_ui_ui_android", "()I", "getBorderColor$zendesk_ui_ui_android", "getCameraSupported$zendesk_ui_ui_android", "()Z", "getComposerText$zendesk_ui_ui_android", "()Ljava/lang/String;", "getEnabled$zendesk_ui_ui_android", "getGallerySupported$zendesk_ui_ui_android", "getInputMaxLength$zendesk_ui_ui_android", "getSendButtonColor$zendesk_ui_ui_android", "getShowAttachment$zendesk_ui_ui_android", "getTextColor$zendesk_ui_ui_android", "getVisibility$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component10", "component10$zendesk_ui_ui_android", "component11", "component11$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "component7$zendesk_ui_ui_android", "component8", "component8$zendesk_ui_ui_android", "component9", "component9$zendesk_ui_ui_android", "copy", "equals", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/composer/MessageComposerState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageComposerState {
    public static final int $stable = 0;
    private final int attachButtonColor;
    private final int borderColor;
    private final boolean cameraSupported;
    private final String composerText;
    private final boolean enabled;
    private final boolean gallerySupported;
    private final int inputMaxLength;
    private final int sendButtonColor;
    private final boolean showAttachment;
    private final int textColor;
    private final int visibility;

    public MessageComposerState() {
        this(false, false, false, false, 0, 0, 0, 0, 0, 0, null, 2047, null);
    }

    public static MessageComposerState copy$default(MessageComposerState messageComposerState, boolean z, boolean z2, boolean z3, boolean z4, int i, int i2, int i3, int i4, int i5, int i6, String str, int i7, Object obj) {
        return messageComposerState.copy((i7 & 1) != 0 ? messageComposerState.enabled : z, (i7 & 2) != 0 ? messageComposerState.cameraSupported : z2, (i7 & 4) != 0 ? messageComposerState.gallerySupported : z3, (i7 & 8) != 0 ? messageComposerState.showAttachment : z4, (i7 & 16) != 0 ? messageComposerState.visibility : i, (i7 & 32) != 0 ? messageComposerState.inputMaxLength : i2, (i7 & 64) != 0 ? messageComposerState.sendButtonColor : i3, (i7 & 128) != 0 ? messageComposerState.attachButtonColor : i4, (i7 & 256) != 0 ? messageComposerState.borderColor : i5, (i7 & 512) != 0 ? messageComposerState.textColor : i6, (i7 & 1024) != 0 ? messageComposerState.composerText : str);
    }

    public final boolean getEnabled() {
        return this.enabled;
    }

    public final int getTextColor() {
        return this.textColor;
    }

    public final String getComposerText() {
        return this.composerText;
    }

    public final boolean getCameraSupported() {
        return this.cameraSupported;
    }

    public final boolean getGallerySupported() {
        return this.gallerySupported;
    }

    public final boolean getShowAttachment() {
        return this.showAttachment;
    }

    public final int getVisibility() {
        return this.visibility;
    }

    public final int getInputMaxLength() {
        return this.inputMaxLength;
    }

    public final int getSendButtonColor() {
        return this.sendButtonColor;
    }

    public final int getAttachButtonColor() {
        return this.attachButtonColor;
    }

    public final int getBorderColor() {
        return this.borderColor;
    }

    public final MessageComposerState copy(boolean enabled, boolean cameraSupported, boolean gallerySupported, boolean showAttachment, int visibility, int inputMaxLength, int sendButtonColor, int attachButtonColor, int borderColor, int textColor, String composerText) {
        Intrinsics.checkNotNullParameter(composerText, "composerText");
        return new MessageComposerState(enabled, cameraSupported, gallerySupported, showAttachment, visibility, inputMaxLength, sendButtonColor, attachButtonColor, borderColor, textColor, composerText);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof MessageComposerState)) {
            return false;
        }
        MessageComposerState messageComposerState = (MessageComposerState) other;
        return this.enabled == messageComposerState.enabled && this.cameraSupported == messageComposerState.cameraSupported && this.gallerySupported == messageComposerState.gallerySupported && this.showAttachment == messageComposerState.showAttachment && this.visibility == messageComposerState.visibility && this.inputMaxLength == messageComposerState.inputMaxLength && this.sendButtonColor == messageComposerState.sendButtonColor && this.attachButtonColor == messageComposerState.attachButtonColor && this.borderColor == messageComposerState.borderColor && this.textColor == messageComposerState.textColor && Intrinsics.areEqual(this.composerText, messageComposerState.composerText);
    }

    public int hashCode() {
        return (((((((((((((((((((UByte$$ExternalSyntheticBackport0.m30m(this.enabled) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.cameraSupported)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.gallerySupported)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.showAttachment)) * 31) + this.visibility) * 31) + this.inputMaxLength) * 31) + this.sendButtonColor) * 31) + this.attachButtonColor) * 31) + this.borderColor) * 31) + this.textColor) * 31) + this.composerText.hashCode();
    }

    public String toString() {
        return "MessageComposerState(enabled=" + this.enabled + ", cameraSupported=" + this.cameraSupported + ", gallerySupported=" + this.gallerySupported + ", showAttachment=" + this.showAttachment + ", visibility=" + this.visibility + ", inputMaxLength=" + this.inputMaxLength + ", sendButtonColor=" + this.sendButtonColor + ", attachButtonColor=" + this.attachButtonColor + ", borderColor=" + this.borderColor + ", textColor=" + this.textColor + ", composerText=" + this.composerText + ')';
    }

    public MessageComposerState(boolean z, boolean z2, boolean z3, boolean z4, int i, int i2, int i3, int i4, int i5, int i6, String composerText) {
        Intrinsics.checkNotNullParameter(composerText, "composerText");
        this.enabled = z;
        this.cameraSupported = z2;
        this.gallerySupported = z3;
        this.showAttachment = z4;
        this.visibility = i;
        this.inputMaxLength = i2;
        this.sendButtonColor = i3;
        this.attachButtonColor = i4;
        this.borderColor = i5;
        this.textColor = i6;
        this.composerText = composerText;
    }

    public final boolean getEnabled$zendesk_ui_ui_android() {
        return this.enabled;
    }

    public final boolean getCameraSupported$zendesk_ui_ui_android() {
        return this.cameraSupported;
    }

    public final boolean getGallerySupported$zendesk_ui_ui_android() {
        return this.gallerySupported;
    }

    public final boolean getShowAttachment$zendesk_ui_ui_android() {
        return this.showAttachment;
    }

    public final int getVisibility$zendesk_ui_ui_android() {
        return this.visibility;
    }

    public final int getInputMaxLength$zendesk_ui_ui_android() {
        return this.inputMaxLength;
    }

    public final int getSendButtonColor$zendesk_ui_ui_android() {
        return this.sendButtonColor;
    }

    public final int getAttachButtonColor$zendesk_ui_ui_android() {
        return this.attachButtonColor;
    }

    public final int getBorderColor$zendesk_ui_ui_android() {
        return this.borderColor;
    }

    public final int getTextColor$zendesk_ui_ui_android() {
        return this.textColor;
    }

    public MessageComposerState(boolean z, boolean z2, boolean z3, boolean z4, int i, int i2, int i3, int i4, int i5, int i6, String str, int i7, DefaultConstructorMarker defaultConstructorMarker) {
        this((i7 & 1) != 0 ? true : z, (i7 & 2) != 0 ? true : z2, (i7 & 4) == 0 ? z3 : true, (i7 & 8) != 0 ? false : z4, (i7 & 16) != 0 ? 0 : i, (i7 & 32) != 0 ? Integer.MAX_VALUE : i2, (i7 & 64) != 0 ? 0 : i3, (i7 & 128) != 0 ? 0 : i4, (i7 & 256) != 0 ? 0 : i5, (i7 & 512) == 0 ? i6 : 0, (i7 & 1024) != 0 ? "" : str);
    }

    public final String getComposerText$zendesk_ui_ui_android() {
        return this.composerText;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0010\u0010\u0006\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0006\u0010\t\u001a\u00020\u0003J\u000e\u0010\n\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u000bJ\u000e\u0010\f\u001a\u00020\u00002\u0006\u0010\f\u001a\u00020\rJ\u000e\u0010\u000e\u001a\u00020\u00002\u0006\u0010\u000e\u001a\u00020\u000bJ\u000e\u0010\u000f\u001a\u00020\u00002\u0006\u0010\u000f\u001a\u00020\u000bJ\u000e\u0010\u0010\u001a\u00020\u00002\u0006\u0010\u0011\u001a\u00020\bJ\u0010\u0010\u0012\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u000e\u0010\u0013\u001a\u00020\u00002\u0006\u0010\u0013\u001a\u00020\u000bJ\u0010\u0010\u0014\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u000e\u0010\u0015\u001a\u00020\u00002\u0006\u0010\u0015\u001a\u00020\bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0016"}, m18d2 = {"Lzendesk/ui/android/conversation/composer/MessageComposerState$Builder;", "", "state", "Lzendesk/ui/android/conversation/composer/MessageComposerState;", "(Lzendesk/ui/android/conversation/composer/MessageComposerState;)V", "()V", "attachButtonColor", "color", "", "build", "cameraSupported", "", "composerText", "", "enabled", "gallerySupported", "inputMaxLength", "value", "sendButtonColor", "showAttachment", "textColor", "visibility", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private MessageComposerState state;

        public Builder() {
            this.state = new MessageComposerState(false, false, false, false, 0, 0, 0, 0, 0, 0, null, 2047, null);
        }

        public Builder(MessageComposerState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder enabled(boolean enabled) {
            this.state = MessageComposerState.copy$default(this.state, enabled, false, false, false, 0, 0, 0, 0, 0, 0, null, 2046, null);
            return this;
        }

        public final Builder cameraSupported(boolean cameraSupported) {
            this.state = MessageComposerState.copy$default(this.state, false, cameraSupported, false, false, 0, 0, 0, 0, 0, 0, null, 2045, null);
            return this;
        }

        public final Builder gallerySupported(boolean gallerySupported) {
            this.state = MessageComposerState.copy$default(this.state, false, false, gallerySupported, false, 0, 0, 0, 0, 0, 0, null, 2043, null);
            return this;
        }

        public final Builder visibility(int visibility) {
            this.state = MessageComposerState.copy$default(this.state, false, false, false, false, visibility, 0, 0, 0, 0, 0, null, 2031, null);
            return this;
        }

        public final Builder inputMaxLength(int value) {
            this.state = MessageComposerState.copy$default(this.state, false, false, false, false, 0, value, 0, 0, 0, 0, null, 2015, null);
            return this;
        }

        public final Builder showAttachment(boolean showAttachment) {
            this.state = MessageComposerState.copy$default(this.state, false, false, false, showAttachment, 0, 0, 0, 0, 0, 0, null, 2039, null);
            return this;
        }

        public final Builder sendButtonColor(int color) {
            this.state = MessageComposerState.copy$default(this.state, false, false, false, false, 0, 0, color, 0, 0, 0, null, 1983, null);
            return this;
        }

        public final Builder attachButtonColor(int color) {
            this.state = MessageComposerState.copy$default(this.state, false, false, false, false, 0, 0, 0, color, 0, 0, null, 1919, null);
            return this;
        }

        public final Builder textColor(int color) {
            this.state = MessageComposerState.copy$default(this.state, false, false, false, false, 0, 0, 0, 0, 0, color, null, 1535, null);
            return this;
        }

        public final Builder composerText(String composerText) {
            Intrinsics.checkNotNullParameter(composerText, "composerText");
            this.state = MessageComposerState.copy$default(this.state, false, false, false, false, 0, 0, 0, 0, 0, 0, composerText, 1023, null);
            return this;
        }

        public final MessageComposerState getState() {
            return this.state;
        }
    }
}
