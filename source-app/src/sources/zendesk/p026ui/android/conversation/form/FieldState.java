package zendesk.p026ui.android.conversation.form;

import cz.msebera.android.httpclient.HttpStatus;
import java.util.List;
import kotlin.Metadata;
import kotlin.collections.ArraysKt;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.RangesKt;
import net.aihelp.data.model.p005cs.ConversationMsg;
import net.aihelp.data.track.data.TrackType;
import okhttp3.internal.p011ws.WebSocketProtocol;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u000f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u00002\u00020\u0001:\u0003\u0013\u0014\u0015BC\b\u0004\u0012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\b\b\u0003\u0010\u0005\u001a\u00020\u0006\u0012\b\b\u0003\u0010\u0007\u001a\u00020\u0006\u0012\b\b\u0003\u0010\b\u001a\u00020\u0006\u0012\b\b\u0003\u0010\t\u001a\u00020\u0006¢\u0006\u0002\u0010\nR\u0014\u0010\u0007\u001a\u00020\u0006X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\b\u001a\u00020\u0006X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\fR\u0016\u0010\u0004\u001a\u0004\u0018\u00010\u0003X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0014\u0010\u0005\u001a\u00020\u0006X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\fR\u0016\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u000fR\u0014\u0010\t\u001a\u00020\u0006X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\f\u0082\u0001\u0003\u0016\u0017\u0018¨\u0006\u0019"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldState;", "", "placeholder", "", "label", "onDangerColor", "", "borderColor", "focusedBorderColor", "textColor", "(Ljava/lang/String;Ljava/lang/String;IIII)V", "getBorderColor$zendesk_ui_ui_android", "()I", "getFocusedBorderColor$zendesk_ui_ui_android", "getLabel$zendesk_ui_ui_android", "()Ljava/lang/String;", "getOnDangerColor$zendesk_ui_ui_android", "getPlaceholder$zendesk_ui_ui_android", "getTextColor$zendesk_ui_ui_android", "Email", "Select", "Text", "Lzendesk/ui/android/conversation/form/FieldState$Email;", "Lzendesk/ui/android/conversation/form/FieldState$Select;", "Lzendesk/ui/android/conversation/form/FieldState$Text;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class FieldState {
    public static final int $stable = 0;
    private final int borderColor;
    private final int focusedBorderColor;
    private final String label;
    private final int onDangerColor;
    private final String placeholder;
    private final int textColor;

    public FieldState(String str, String str2, int i, int i2, int i3, int i4, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, str2, i, i2, i3, i4);
    }

    private FieldState(String str, String str2, int i, int i2, int i3, int i4) {
        this.placeholder = str;
        this.label = str2;
        this.onDangerColor = i;
        this.borderColor = i2;
        this.focusedBorderColor = i3;
        this.textColor = i4;
    }

    public FieldState(String str, String str2, int i, int i2, int i3, int i4, int i5, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, str2, (i5 & 4) != 0 ? 0 : i, (i5 & 8) != 0 ? 0 : i2, (i5 & 16) != 0 ? 0 : i3, (i5 & 32) != 0 ? 0 : i4, null);
    }

    public String getPlaceholder() {
        return this.placeholder;
    }

    public String getLabel() {
        return this.label;
    }

    public int getOnDangerColor() {
        return this.onDangerColor;
    }

    public int getBorderColor() {
        return this.borderColor;
    }

    public int getFocusedBorderColor() {
        return this.focusedBorderColor;
    }

    public int getTextColor() {
        return this.textColor;
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b&\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0004\b\u0087\b\u0018\u00002\u00020\u0001:\u00011Bg\b\u0000\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u0003\u0012\b\b\u0003\u0010\t\u001a\u00020\u0005\u0012\b\b\u0003\u0010\n\u001a\u00020\u0005\u0012\b\b\u0003\u0010\u000b\u001a\u00020\u0005\u0012\b\b\u0003\u0010\f\u001a\u00020\u0005¢\u0006\u0002\u0010\rJ\u000b\u0010\u0019\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u000e\u0010\u001a\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b\u001bJ\u000e\u0010\u001c\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b\u001dJ\u0010\u0010\u001e\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b\u001fJ\u0010\u0010 \u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b!J\u000e\u0010\"\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b#J\u000e\u0010$\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b%J\u000e\u0010&\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b'J\u000e\u0010(\u001a\u00020\u0005HÀ\u0003¢\u0006\u0002\b)Ji\u0010*\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u00032\b\b\u0003\u0010\t\u001a\u00020\u00052\b\b\u0003\u0010\n\u001a\u00020\u00052\b\b\u0003\u0010\u000b\u001a\u00020\u00052\b\b\u0003\u0010\f\u001a\u00020\u0005HÆ\u0001J\u0013\u0010+\u001a\u00020,2\b\u0010-\u001a\u0004\u0018\u00010.HÖ\u0003J\t\u0010/\u001a\u00020\u0005HÖ\u0001J\t\u00100\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\n\u001a\u00020\u0005X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0014\u0010\u000b\u001a\u00020\u0005X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000fR\u0016\u0010\b\u001a\u0004\u0018\u00010\u0003X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0014\u0010\u0006\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u000fR\u0014\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u000fR\u0014\u0010\t\u001a\u00020\u0005X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u000fR\u0016\u0010\u0007\u001a\u0004\u0018\u00010\u0003X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0012R\u0013\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0012R\u0014\u0010\f\u001a\u00020\u0005X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u000f¨\u00062"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldState$Text;", "Lzendesk/ui/android/conversation/form/FieldState;", "text", "", "minLength", "", "maxLength", "placeholder", "label", "onDangerColor", "borderColor", "focusedBorderColor", "textColor", "(Ljava/lang/String;IILjava/lang/String;Ljava/lang/String;IIII)V", "getBorderColor$zendesk_ui_ui_android", "()I", "getFocusedBorderColor$zendesk_ui_ui_android", "getLabel$zendesk_ui_ui_android", "()Ljava/lang/String;", "getMaxLength$zendesk_ui_ui_android", "getMinLength$zendesk_ui_ui_android", "getOnDangerColor$zendesk_ui_ui_android", "getPlaceholder$zendesk_ui_ui_android", "getText", "getTextColor$zendesk_ui_ui_android", "component1", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "component7$zendesk_ui_ui_android", "component8", "component8$zendesk_ui_ui_android", "component9", "component9$zendesk_ui_ui_android", "copy", "equals", "", "other", "", "hashCode", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Text extends FieldState {
        public static final int $stable = 0;
        private final int borderColor;
        private final int focusedBorderColor;
        private final String label;
        private final int maxLength;
        private final int minLength;
        private final int onDangerColor;
        private final String placeholder;
        private final String text;
        private final int textColor;

        public Text() {
            this(null, 0, 0, null, null, 0, 0, 0, 0, 511, null);
        }

        public static Text copy$default(Text text, String str, int i, int i2, String str2, String str3, int i3, int i4, int i5, int i6, int i7, Object obj) {
            return text.copy((i7 & 1) != 0 ? text.text : str, (i7 & 2) != 0 ? text.minLength : i, (i7 & 4) != 0 ? text.maxLength : i2, (i7 & 8) != 0 ? text.placeholder : str2, (i7 & 16) != 0 ? text.label : str3, (i7 & 32) != 0 ? text.onDangerColor : i3, (i7 & 64) != 0 ? text.borderColor : i4, (i7 & 128) != 0 ? text.focusedBorderColor : i5, (i7 & 256) != 0 ? text.textColor : i6);
        }

        public final String getText() {
            return this.text;
        }

        public final int getMinLength() {
            return this.minLength;
        }

        public final int getMaxLength() {
            return this.maxLength;
        }

        public final String getPlaceholder() {
            return this.placeholder;
        }

        public final String getLabel() {
            return this.label;
        }

        public final int getOnDangerColor() {
            return this.onDangerColor;
        }

        public final int getBorderColor() {
            return this.borderColor;
        }

        public final int getFocusedBorderColor() {
            return this.focusedBorderColor;
        }

        public final int getTextColor() {
            return this.textColor;
        }

        public final Text copy(String text, int minLength, int maxLength, String placeholder, String label, int onDangerColor, int borderColor, int focusedBorderColor, int textColor) {
            return new Text(text, minLength, maxLength, placeholder, label, onDangerColor, borderColor, focusedBorderColor, textColor);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Text)) {
                return false;
            }
            Text text = (Text) other;
            return Intrinsics.areEqual(this.text, text.text) && this.minLength == text.minLength && this.maxLength == text.maxLength && Intrinsics.areEqual(this.placeholder, text.placeholder) && Intrinsics.areEqual(this.label, text.label) && this.onDangerColor == text.onDangerColor && this.borderColor == text.borderColor && this.focusedBorderColor == text.focusedBorderColor && this.textColor == text.textColor;
        }

        public int hashCode() {
            String str = this.text;
            int iHashCode = (((((str == null ? 0 : str.hashCode()) * 31) + this.minLength) * 31) + this.maxLength) * 31;
            String str2 = this.placeholder;
            int iHashCode2 = (iHashCode + (str2 == null ? 0 : str2.hashCode())) * 31;
            String str3 = this.label;
            return ((((((((iHashCode2 + (str3 != null ? str3.hashCode() : 0)) * 31) + this.onDangerColor) * 31) + this.borderColor) * 31) + this.focusedBorderColor) * 31) + this.textColor;
        }

        public String toString() {
            return "Text(text=" + this.text + ", minLength=" + this.minLength + ", maxLength=" + this.maxLength + ", placeholder=" + this.placeholder + ", label=" + this.label + ", onDangerColor=" + this.onDangerColor + ", borderColor=" + this.borderColor + ", focusedBorderColor=" + this.focusedBorderColor + ", textColor=" + this.textColor + ')';
        }

        public Text(String str, int i, int i2, String str2, String str3, int i3, int i4, int i5, int i6, int i7, DefaultConstructorMarker defaultConstructorMarker) {
            this((i7 & 1) != 0 ? null : str, (i7 & 2) != 0 ? 0 : i, (i7 & 4) != 0 ? Integer.MAX_VALUE : i2, (i7 & 8) != 0 ? null : str2, (i7 & 16) == 0 ? str3 : null, (i7 & 32) != 0 ? 0 : i3, (i7 & 64) != 0 ? 0 : i4, (i7 & 128) != 0 ? 0 : i5, (i7 & 256) == 0 ? i6 : 0);
        }

        public final String getText() {
            return this.text;
        }

        public final int getMinLength$zendesk_ui_ui_android() {
            return this.minLength;
        }

        public final int getMaxLength$zendesk_ui_ui_android() {
            return this.maxLength;
        }

        @Override
        public String getPlaceholder() {
            return this.placeholder;
        }

        @Override
        public String getLabel() {
            return this.label;
        }

        @Override
        public int getOnDangerColor() {
            return this.onDangerColor;
        }

        @Override
        public int getBorderColor() {
            return this.borderColor;
        }

        @Override
        public int getFocusedBorderColor() {
            return this.focusedBorderColor;
        }

        @Override
        public int getTextColor() {
            return this.textColor;
        }

        public Text(String str, int i, int i2, String str2, String str3, int i3, int i4, int i5, int i6) {
            super(str2, str3, i4, i5, 0, 0, 48, null);
            this.text = str;
            this.minLength = i;
            this.maxLength = i2;
            this.placeholder = str2;
            this.label = str3;
            this.onDangerColor = i3;
            this.borderColor = i4;
            this.focusedBorderColor = i5;
            this.textColor = i6;
        }

        @Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0006\b\u0007\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0005\u001a\u00020\u00002\b\b\u0001\u0010\u0005\u001a\u00020\u0006J\u0006\u0010\u0007\u001a\u00020\u0004J\u0010\u0010\b\u001a\u00020\u00002\b\u0010\b\u001a\u0004\u0018\u00010\tJ\u000e\u0010\n\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u0006J\u000e\u0010\u000b\u001a\u00020\u00002\u0006\u0010\u000b\u001a\u00020\u0006J\u0010\u0010\f\u001a\u00020\u00002\b\u0010\f\u001a\u0004\u0018\u00010\tJ\u0010\u0010\r\u001a\u00020\u00002\b\u0010\r\u001a\u0004\u0018\u00010\tJ\u0010\u0010\u000e\u001a\u00020\u00002\b\b\u0001\u0010\u000e\u001a\u00020\u0006R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u000f"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldState$Text$Builder;", "", "()V", "state", "Lzendesk/ui/android/conversation/form/FieldState$Text;", "borderColor", "", "build", "label", "", "maxLength", "minLength", "placeholder", "text", "textColor", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Builder {
            public static final int $stable = 8;
            private Text state = new Text(null, 0, 0, null, null, 0, 0, 0, 0, 511, null);

            public final Builder text(String text) {
                this.state = Text.copy$default(this.state, text, 0, 0, null, null, 0, 0, 0, 0, 510, null);
                return this;
            }

            public final Builder minLength(int minLength) {
                this.state = Text.copy$default(this.state, null, RangesKt.coerceAtLeast(minLength, 0), 0, null, null, 0, 0, 0, 0, 509, null);
                return this;
            }

            public final Builder maxLength(int maxLength) {
                this.state = Text.copy$default(this.state, null, 0, maxLength, null, null, 0, 0, 0, 0, HttpStatus.SC_INSUFFICIENT_STORAGE, null);
                return this;
            }

            public final Builder placeholder(String placeholder) {
                this.state = Text.copy$default(this.state, null, 0, 0, placeholder, null, 0, 0, 0, 0, HttpStatus.SC_SERVICE_UNAVAILABLE, null);
                return this;
            }

            public final Builder label(String label) {
                this.state = Text.copy$default(this.state, null, 0, 0, null, label, 0, 0, 0, 0, 495, null);
                return this;
            }

            public final Builder borderColor(int borderColor) {
                this.state = Text.copy$default(this.state, null, 0, 0, null, null, 0, borderColor, 0, 0, 447, null);
                return this;
            }

            public final Builder textColor(int textColor) {
                this.state = Text.copy$default(this.state, null, 0, 0, null, null, 0, 0, 0, textColor, 255, null);
                return this;
            }

            public final Text getState() {
                return this.state;
            }
        }
    }

    @Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u001c\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0004\b\u0087\b\u0018\u00002\u00020\u0001:\u0001)BS\b\u0000\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0003\u0012\b\b\u0003\u0010\u0006\u001a\u00020\u0007\u0012\b\b\u0003\u0010\b\u001a\u00020\u0007\u0012\b\b\u0003\u0010\t\u001a\u00020\u0007\u0012\b\b\u0003\u0010\n\u001a\u00020\u0007¢\u0006\u0002\u0010\u000bJ\u000b\u0010\u0015\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u0010\u0010\u0016\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b\u0017J\u0010\u0010\u0018\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b\u0019J\u000e\u0010\u001a\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\b\u001bJ\u000e\u0010\u001c\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\b\u001dJ\u000e\u0010\u001e\u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\b\u001fJ\u000e\u0010 \u001a\u00020\u0007HÀ\u0003¢\u0006\u0002\b!JU\u0010\"\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00032\b\b\u0003\u0010\u0006\u001a\u00020\u00072\b\b\u0003\u0010\b\u001a\u00020\u00072\b\b\u0003\u0010\t\u001a\u00020\u00072\b\b\u0003\u0010\n\u001a\u00020\u0007HÆ\u0001J\u0013\u0010#\u001a\u00020$2\b\u0010%\u001a\u0004\u0018\u00010&HÖ\u0003J\t\u0010'\u001a\u00020\u0007HÖ\u0001J\t\u0010(\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\b\u001a\u00020\u0007X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0013\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0014\u0010\t\u001a\u00020\u0007X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\rR\u0016\u0010\u0005\u001a\u0004\u0018\u00010\u0003X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u000fR\u0014\u0010\u0006\u001a\u00020\u0007X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\rR\u0016\u0010\u0004\u001a\u0004\u0018\u00010\u0003X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u000fR\u0014\u0010\n\u001a\u00020\u0007X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\r¨\u0006*"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldState$Email;", "Lzendesk/ui/android/conversation/form/FieldState;", "email", "", "placeholder", "label", "onDangerColor", "", "borderColor", "focusedBorderColor", "textColor", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IIII)V", "getBorderColor$zendesk_ui_ui_android", "()I", "getEmail", "()Ljava/lang/String;", "getFocusedBorderColor$zendesk_ui_ui_android", "getLabel$zendesk_ui_ui_android", "getOnDangerColor$zendesk_ui_ui_android", "getPlaceholder$zendesk_ui_ui_android", "getTextColor$zendesk_ui_ui_android", "component1", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "component7$zendesk_ui_ui_android", "copy", "equals", "", "other", "", "hashCode", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Email extends FieldState {
        public static final int $stable = 0;
        private final int borderColor;
        private final String email;
        private final int focusedBorderColor;
        private final String label;
        private final int onDangerColor;
        private final String placeholder;
        private final int textColor;

        public Email() {
            this(null, null, null, 0, 0, 0, 0, 127, null);
        }

        public static Email copy$default(Email email, String str, String str2, String str3, int i, int i2, int i3, int i4, int i5, Object obj) {
            if ((i5 & 1) != 0) {
                str = email.email;
            }
            if ((i5 & 2) != 0) {
                str2 = email.placeholder;
            }
            String str4 = str2;
            if ((i5 & 4) != 0) {
                str3 = email.label;
            }
            String str5 = str3;
            if ((i5 & 8) != 0) {
                i = email.onDangerColor;
            }
            int i6 = i;
            if ((i5 & 16) != 0) {
                i2 = email.borderColor;
            }
            int i7 = i2;
            if ((i5 & 32) != 0) {
                i3 = email.focusedBorderColor;
            }
            int i8 = i3;
            if ((i5 & 64) != 0) {
                i4 = email.textColor;
            }
            return email.copy(str, str4, str5, i6, i7, i8, i4);
        }

        public final String getEmail() {
            return this.email;
        }

        public final String getPlaceholder() {
            return this.placeholder;
        }

        public final String getLabel() {
            return this.label;
        }

        public final int getOnDangerColor() {
            return this.onDangerColor;
        }

        public final int getBorderColor() {
            return this.borderColor;
        }

        public final int getFocusedBorderColor() {
            return this.focusedBorderColor;
        }

        public final int getTextColor() {
            return this.textColor;
        }

        public final Email copy(String email, String placeholder, String label, int onDangerColor, int borderColor, int focusedBorderColor, int textColor) {
            return new Email(email, placeholder, label, onDangerColor, borderColor, focusedBorderColor, textColor);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Email)) {
                return false;
            }
            Email email = (Email) other;
            return Intrinsics.areEqual(this.email, email.email) && Intrinsics.areEqual(this.placeholder, email.placeholder) && Intrinsics.areEqual(this.label, email.label) && this.onDangerColor == email.onDangerColor && this.borderColor == email.borderColor && this.focusedBorderColor == email.focusedBorderColor && this.textColor == email.textColor;
        }

        public int hashCode() {
            String str = this.email;
            int iHashCode = (str == null ? 0 : str.hashCode()) * 31;
            String str2 = this.placeholder;
            int iHashCode2 = (iHashCode + (str2 == null ? 0 : str2.hashCode())) * 31;
            String str3 = this.label;
            return ((((((((iHashCode2 + (str3 != null ? str3.hashCode() : 0)) * 31) + this.onDangerColor) * 31) + this.borderColor) * 31) + this.focusedBorderColor) * 31) + this.textColor;
        }

        public String toString() {
            return "Email(email=" + this.email + ", placeholder=" + this.placeholder + ", label=" + this.label + ", onDangerColor=" + this.onDangerColor + ", borderColor=" + this.borderColor + ", focusedBorderColor=" + this.focusedBorderColor + ", textColor=" + this.textColor + ')';
        }

        public Email(String str, String str2, String str3, int i, int i2, int i3, int i4, int i5, DefaultConstructorMarker defaultConstructorMarker) {
            this((i5 & 1) != 0 ? null : str, (i5 & 2) != 0 ? null : str2, (i5 & 4) == 0 ? str3 : null, (i5 & 8) != 0 ? 0 : i, (i5 & 16) != 0 ? 0 : i2, (i5 & 32) != 0 ? 0 : i3, (i5 & 64) != 0 ? 0 : i4);
        }

        public final String getEmail() {
            return this.email;
        }

        @Override
        public String getPlaceholder() {
            return this.placeholder;
        }

        @Override
        public String getLabel() {
            return this.label;
        }

        @Override
        public int getOnDangerColor() {
            return this.onDangerColor;
        }

        @Override
        public int getBorderColor() {
            return this.borderColor;
        }

        @Override
        public int getFocusedBorderColor() {
            return this.focusedBorderColor;
        }

        @Override
        public int getTextColor() {
            return this.textColor;
        }

        public Email(String str, String str2, String str3, int i, int i2, int i3, int i4) {
            super(str2, str3, i2, i3, 0, 0, 48, null);
            this.email = str;
            this.placeholder = str2;
            this.label = str3;
            this.onDangerColor = i;
            this.borderColor = i2;
            this.focusedBorderColor = i3;
            this.textColor = i4;
        }

        @Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0007\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0005\u001a\u00020\u00002\b\b\u0001\u0010\u0005\u001a\u00020\u0006J\u0006\u0010\u0007\u001a\u00020\u0004J\u0010\u0010\b\u001a\u00020\u00002\b\u0010\b\u001a\u0004\u0018\u00010\tJ\u0010\u0010\n\u001a\u00020\u00002\b\u0010\n\u001a\u0004\u0018\u00010\tJ\u0010\u0010\u000b\u001a\u00020\u00002\b\u0010\u000b\u001a\u0004\u0018\u00010\tJ\u0010\u0010\f\u001a\u00020\u00002\b\b\u0001\u0010\f\u001a\u00020\u0006R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldState$Email$Builder;", "", "()V", "state", "Lzendesk/ui/android/conversation/form/FieldState$Email;", "borderColor", "", "build", "email", "", "label", "placeholder", "textColor", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Builder {
            public static final int $stable = 8;
            private Email state = new Email(null, null, null, 0, 0, 0, 0, 127, null);

            public final Builder email(String email) {
                this.state = Email.copy$default(this.state, email, null, null, 0, 0, 0, 0, WebSocketProtocol.PAYLOAD_SHORT, null);
                return this;
            }

            public final Builder placeholder(String placeholder) {
                this.state = Email.copy$default(this.state, null, placeholder, null, 0, 0, 0, 0, 125, null);
                return this;
            }

            public final Builder label(String label) {
                this.state = Email.copy$default(this.state, null, null, label, 0, 0, 0, 0, 123, null);
                return this;
            }

            public final Builder borderColor(int borderColor) {
                this.state = Email.copy$default(this.state, null, null, null, 0, borderColor, 0, 0, ConversationMsg.TYPE_ADMIN_TYPING, null);
                return this;
            }

            public final Builder textColor(int textColor) {
                this.state = Email.copy$default(this.state, null, null, null, 0, 0, 0, textColor, 63, null);
                return this;
            }

            public final Email getState() {
                return this.state;
            }
        }
    }

    @Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u001f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0004\b\u0087\b\u0018\u00002\u00020\u0001:\u0001/Bg\b\u0000\u0012\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u000e\b\u0002\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0003\u0010\t\u001a\u00020\n\u0012\b\b\u0003\u0010\u000b\u001a\u00020\n\u0012\b\b\u0003\u0010\f\u001a\u00020\n\u0012\b\b\u0003\u0010\r\u001a\u00020\n¢\u0006\u0002\u0010\u000eJ\u000f\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u000f\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0010\u0010\u001c\u001a\u0004\u0018\u00010\u0007HÀ\u0003¢\u0006\u0002\b\u001dJ\u0010\u0010\u001e\u001a\u0004\u0018\u00010\u0007HÀ\u0003¢\u0006\u0002\b\u001fJ\u000e\u0010 \u001a\u00020\nHÀ\u0003¢\u0006\u0002\b!J\u000e\u0010\"\u001a\u00020\nHÀ\u0003¢\u0006\u0002\b#J\u000e\u0010$\u001a\u00020\nHÀ\u0003¢\u0006\u0002\b%J\u000e\u0010&\u001a\u00020\nHÀ\u0003¢\u0006\u0002\b'Ji\u0010(\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\u000e\b\u0002\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00072\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u00072\b\b\u0003\u0010\t\u001a\u00020\n2\b\b\u0003\u0010\u000b\u001a\u00020\n2\b\b\u0003\u0010\f\u001a\u00020\n2\b\b\u0003\u0010\r\u001a\u00020\nHÆ\u0001J\u0013\u0010)\u001a\u00020*2\b\u0010+\u001a\u0004\u0018\u00010,HÖ\u0003J\t\u0010-\u001a\u00020\nHÖ\u0001J\t\u0010.\u001a\u00020\u0007HÖ\u0001R\u0014\u0010\u000b\u001a\u00020\nX\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0014\u0010\f\u001a\u00020\nX\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0010R\u0016\u0010\b\u001a\u0004\u0018\u00010\u0007X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0014\u0010\t\u001a\u00020\nX\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0010R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0016\u0010\u0006\u001a\u0004\u0018\u00010\u0007X\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0013R\u0017\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0016R\u0014\u0010\r\u001a\u00020\nX\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0010¨\u00060"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldState$Select;", "Lzendesk/ui/android/conversation/form/FieldState;", "options", "", "Lzendesk/ui/android/conversation/form/SelectOption;", "select", "placeholder", "", "label", "onDangerColor", "", "borderColor", "focusedBorderColor", "textColor", "(Ljava/util/List;Ljava/util/List;Ljava/lang/String;Ljava/lang/String;IIII)V", "getBorderColor$zendesk_ui_ui_android", "()I", "getFocusedBorderColor$zendesk_ui_ui_android", "getLabel$zendesk_ui_ui_android", "()Ljava/lang/String;", "getOnDangerColor$zendesk_ui_ui_android", "getOptions", "()Ljava/util/List;", "getPlaceholder$zendesk_ui_ui_android", "getSelect", "getTextColor$zendesk_ui_ui_android", "component1", "component2", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "component7$zendesk_ui_ui_android", "component8", "component8$zendesk_ui_ui_android", "copy", "equals", "", "other", "", "hashCode", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Select extends FieldState {
        public static final int $stable = 8;
        private final int borderColor;
        private final int focusedBorderColor;
        private final String label;
        private final int onDangerColor;
        private final List<SelectOption> options;
        private final String placeholder;
        private final List<SelectOption> select;
        private final int textColor;

        public Select() {
            this(null, null, null, null, 0, 0, 0, 0, 255, null);
        }

        public static Select copy$default(Select select, List list, List list2, String str, String str2, int i, int i2, int i3, int i4, int i5, Object obj) {
            return select.copy((i5 & 1) != 0 ? select.options : list, (i5 & 2) != 0 ? select.select : list2, (i5 & 4) != 0 ? select.placeholder : str, (i5 & 8) != 0 ? select.label : str2, (i5 & 16) != 0 ? select.onDangerColor : i, (i5 & 32) != 0 ? select.borderColor : i2, (i5 & 64) != 0 ? select.focusedBorderColor : i3, (i5 & 128) != 0 ? select.textColor : i4);
        }

        public final List<SelectOption> component1() {
            return this.options;
        }

        public final List<SelectOption> component2() {
            return this.select;
        }

        public final String getPlaceholder() {
            return this.placeholder;
        }

        public final String getLabel() {
            return this.label;
        }

        public final int getOnDangerColor() {
            return this.onDangerColor;
        }

        public final int getBorderColor() {
            return this.borderColor;
        }

        public final int getFocusedBorderColor() {
            return this.focusedBorderColor;
        }

        public final int getTextColor() {
            return this.textColor;
        }

        public final Select copy(List<SelectOption> options, List<SelectOption> select, String placeholder, String label, int onDangerColor, int borderColor, int focusedBorderColor, int textColor) {
            Intrinsics.checkNotNullParameter(options, "options");
            Intrinsics.checkNotNullParameter(select, "select");
            return new Select(options, select, placeholder, label, onDangerColor, borderColor, focusedBorderColor, textColor);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Select)) {
                return false;
            }
            Select select = (Select) other;
            return Intrinsics.areEqual(this.options, select.options) && Intrinsics.areEqual(this.select, select.select) && Intrinsics.areEqual(this.placeholder, select.placeholder) && Intrinsics.areEqual(this.label, select.label) && this.onDangerColor == select.onDangerColor && this.borderColor == select.borderColor && this.focusedBorderColor == select.focusedBorderColor && this.textColor == select.textColor;
        }

        public int hashCode() {
            int iHashCode = ((this.options.hashCode() * 31) + this.select.hashCode()) * 31;
            String str = this.placeholder;
            int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
            String str2 = this.label;
            return ((((((((iHashCode2 + (str2 != null ? str2.hashCode() : 0)) * 31) + this.onDangerColor) * 31) + this.borderColor) * 31) + this.focusedBorderColor) * 31) + this.textColor;
        }

        public String toString() {
            return "Select(options=" + this.options + ", select=" + this.select + ", placeholder=" + this.placeholder + ", label=" + this.label + ", onDangerColor=" + this.onDangerColor + ", borderColor=" + this.borderColor + ", focusedBorderColor=" + this.focusedBorderColor + ", textColor=" + this.textColor + ')';
        }

        public Select(List list, List list2, String str, String str2, int i, int i2, int i3, int i4, int i5, DefaultConstructorMarker defaultConstructorMarker) {
            this((i5 & 1) != 0 ? CollectionsKt.emptyList() : list, (i5 & 2) != 0 ? CollectionsKt.emptyList() : list2, (i5 & 4) != 0 ? null : str, (i5 & 8) == 0 ? str2 : null, (i5 & 16) != 0 ? 0 : i, (i5 & 32) != 0 ? 0 : i2, (i5 & 64) != 0 ? 0 : i3, (i5 & 128) == 0 ? i4 : 0);
        }

        public final List<SelectOption> getOptions() {
            return this.options;
        }

        public final List<SelectOption> getSelect() {
            return this.select;
        }

        @Override
        public String getPlaceholder() {
            return this.placeholder;
        }

        @Override
        public String getLabel() {
            return this.label;
        }

        @Override
        public int getOnDangerColor() {
            return this.onDangerColor;
        }

        @Override
        public int getBorderColor() {
            return this.borderColor;
        }

        @Override
        public int getFocusedBorderColor() {
            return this.focusedBorderColor;
        }

        @Override
        public int getTextColor() {
            return this.textColor;
        }

        public Select(List<SelectOption> options, List<SelectOption> select, String str, String str2, int i, int i2, int i3, int i4) {
            super(str, str2, i2, i3, 0, 0, 48, null);
            Intrinsics.checkNotNullParameter(options, "options");
            Intrinsics.checkNotNullParameter(select, "select");
            this.options = options;
            this.select = select;
            this.placeholder = str;
            this.label = str2;
            this.onDangerColor = i;
            this.borderColor = i2;
            this.focusedBorderColor = i3;
            this.textColor = i4;
        }

        @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\b\u0004\b\u0007\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0005\u001a\u00020\u00002\b\b\u0001\u0010\u0005\u001a\u00020\u0006J\u0006\u0010\u0007\u001a\u00020\u0004J\u0010\u0010\b\u001a\u00020\u00002\b\u0010\b\u001a\u0004\u0018\u00010\tJ\u001f\u0010\n\u001a\u00020\u00002\u0012\u0010\n\u001a\n\u0012\u0006\b\u0001\u0012\u00020\f0\u000b\"\u00020\f¢\u0006\u0002\u0010\rJ\u0014\u0010\n\u001a\u00020\u00002\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000eJ\u0010\u0010\u000f\u001a\u00020\u00002\b\u0010\u000f\u001a\u0004\u0018\u00010\tJ\u001f\u0010\u0010\u001a\u00020\u00002\u0012\u0010\u0010\u001a\n\u0012\u0006\b\u0001\u0012\u00020\f0\u000b\"\u00020\f¢\u0006\u0002\u0010\rJ\u0014\u0010\u0010\u001a\u00020\u00002\f\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\f0\u000eJ\u0010\u0010\u0011\u001a\u00020\u00002\b\b\u0001\u0010\u0011\u001a\u00020\u0006R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0012"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldState$Select$Builder;", "", "()V", "state", "Lzendesk/ui/android/conversation/form/FieldState$Select;", "borderColor", "", "build", "label", "", "options", "", "Lzendesk/ui/android/conversation/form/SelectOption;", "([Lzendesk/ui/android/conversation/form/SelectOption;)Lzendesk/ui/android/conversation/form/FieldState$Select$Builder;", "", "placeholder", "select", "textColor", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Builder {
            public static final int $stable = 8;
            private Select state = new Select(null, null, null, null, 0, 0, 0, 0, 255, null);

            public final Builder options(List<SelectOption> options) {
                Intrinsics.checkNotNullParameter(options, "options");
                this.state = Select.copy$default(this.state, options, null, null, null, 0, 0, 0, 0, 254, null);
                return this;
            }

            public final Builder options(SelectOption... options) {
                Intrinsics.checkNotNullParameter(options, "options");
                this.state = Select.copy$default(this.state, ArraysKt.toList(options), null, null, null, 0, 0, 0, 0, 254, null);
                return this;
            }

            public final Builder select(List<SelectOption> select) {
                Intrinsics.checkNotNullParameter(select, "select");
                this.state = Select.copy$default(this.state, null, select, null, null, 0, 0, 0, 0, TrackType.TRACK_FORM_ACTION_SUBMITTED, null);
                return this;
            }

            public final Builder select(SelectOption... select) {
                Intrinsics.checkNotNullParameter(select, "select");
                this.state = Select.copy$default(this.state, null, ArraysKt.toList(select), null, null, 0, 0, 0, 0, TrackType.TRACK_FORM_ACTION_SUBMITTED, null);
                return this;
            }

            public final Builder placeholder(String placeholder) {
                this.state = Select.copy$default(this.state, null, null, placeholder, null, 0, 0, 0, 0, 251, null);
                return this;
            }

            public final Builder label(String label) {
                this.state = Select.copy$default(this.state, null, null, null, label, 0, 0, 0, 0, 247, null);
                return this;
            }

            public final Builder borderColor(int borderColor) {
                this.state = Select.copy$default(this.state, null, null, null, null, 0, borderColor, 0, 0, 223, null);
                return this;
            }

            public final Builder textColor(int textColor) {
                this.state = Select.copy$default(this.state, null, null, null, null, 0, 0, 0, textColor, 127, null);
                return this;
            }

            public final Select getState() {
                return this.state;
            }
        }
    }
}
