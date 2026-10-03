package zendesk.p026ui.android.conversation.quickreply;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0012\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001\u001fB/\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0005\u001a\u00020\u0006\u0012\b\b\u0003\u0010\u0007\u001a\u00020\u0006¢\u0006\u0002\u0010\bJ\u000e\u0010\u000f\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0010J\u000e\u0010\u0011\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0012J\u000e\u0010\u0013\u001a\u00020\u0006HÀ\u0003¢\u0006\u0002\b\u0014J\u000e\u0010\u0015\u001a\u00020\u0006HÀ\u0003¢\u0006\u0002\b\u0016J1\u0010\u0017\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0003\u0010\u0005\u001a\u00020\u00062\b\b\u0003\u0010\u0007\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u0018\u001a\u00020\u00192\b\u0010\u001a\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001b\u001a\u00020\u0006HÖ\u0001J\u0006\u0010\u001c\u001a\u00020\u001dJ\t\u0010\u001e\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\u0007\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0014\u0010\u0005\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\nR\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0014\u0010\u0004\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\r¨\u0006 "}, m18d2 = {"Lzendesk/ui/android/conversation/quickreply/QuickReplyOptionState;", "", "id", "", "text", "color", "", "backgroundColor", "(Ljava/lang/String;Ljava/lang/String;II)V", "getBackgroundColor$zendesk_ui_ui_android", "()I", "getColor$zendesk_ui_ui_android", "getId$zendesk_ui_ui_android", "()Ljava/lang/String;", "getText$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "copy", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/quickreply/QuickReplyOptionState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class QuickReplyOptionState {
    public static final int $stable = 0;
    private final int backgroundColor;
    private final int color;
    private final String id;
    private final String text;

    public QuickReplyOptionState() {
        this(null, null, 0, 0, 15, null);
    }

    public static QuickReplyOptionState copy$default(QuickReplyOptionState quickReplyOptionState, String str, String str2, int i, int i2, int i3, Object obj) {
        if ((i3 & 1) != 0) {
            str = quickReplyOptionState.id;
        }
        if ((i3 & 2) != 0) {
            str2 = quickReplyOptionState.text;
        }
        if ((i3 & 4) != 0) {
            i = quickReplyOptionState.color;
        }
        if ((i3 & 8) != 0) {
            i2 = quickReplyOptionState.backgroundColor;
        }
        return quickReplyOptionState.copy(str, str2, i, i2);
    }

    public final String getId() {
        return this.id;
    }

    public final String getText() {
        return this.text;
    }

    public final int getColor() {
        return this.color;
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final QuickReplyOptionState copy(String id, String text, int color, int backgroundColor) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(text, "text");
        return new QuickReplyOptionState(id, text, color, backgroundColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof QuickReplyOptionState)) {
            return false;
        }
        QuickReplyOptionState quickReplyOptionState = (QuickReplyOptionState) other;
        return Intrinsics.areEqual(this.id, quickReplyOptionState.id) && Intrinsics.areEqual(this.text, quickReplyOptionState.text) && this.color == quickReplyOptionState.color && this.backgroundColor == quickReplyOptionState.backgroundColor;
    }

    public int hashCode() {
        return (((((this.id.hashCode() * 31) + this.text.hashCode()) * 31) + this.color) * 31) + this.backgroundColor;
    }

    public String toString() {
        return "QuickReplyOptionState(id=" + this.id + ", text=" + this.text + ", color=" + this.color + ", backgroundColor=" + this.backgroundColor + ')';
    }

    public QuickReplyOptionState(String id, String text, int i, int i2) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(text, "text");
        this.id = id;
        this.text = text;
        this.color = i;
        this.backgroundColor = i2;
    }

    public QuickReplyOptionState(String str, String str2, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this((i3 & 1) != 0 ? "" : str, (i3 & 2) != 0 ? "" : str2, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public final String getId$zendesk_ui_ui_android() {
        return this.id;
    }

    public final String getText$zendesk_ui_ui_android() {
        return this.text;
    }

    public final int getColor$zendesk_ui_ui_android() {
        return this.color;
    }

    public final int getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0010\u0010\u0006\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0006\u0010\t\u001a\u00020\u0003J\u0010\u0010\u0007\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u000e\u0010\n\u001a\u00020\u00002\u0006\u0010\u000b\u001a\u00020\fJ\u000e\u0010\r\u001a\u00020\u00002\u0006\u0010\r\u001a\u00020\fR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u000e"}, m18d2 = {"Lzendesk/ui/android/conversation/quickreply/QuickReplyOptionState$Builder;", "", "state", "Lzendesk/ui/android/conversation/quickreply/QuickReplyOptionState;", "(Lzendesk/ui/android/conversation/quickreply/QuickReplyOptionState;)V", "()V", "backgroundColor", "color", "", "build", "setId", "id", "", "text", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private QuickReplyOptionState state;

        public Builder() {
            this.state = new QuickReplyOptionState(null, null, 0, 0, 15, null);
        }

        public Builder(QuickReplyOptionState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder setId(String id) {
            Intrinsics.checkNotNullParameter(id, "id");
            this.state = QuickReplyOptionState.copy$default(this.state, id, null, 0, 0, 14, null);
            return this;
        }

        public final Builder text(String text) {
            Intrinsics.checkNotNullParameter(text, "text");
            this.state = QuickReplyOptionState.copy$default(this.state, null, text, 0, 0, 13, null);
            return this;
        }

        public final Builder color(int color) {
            this.state = QuickReplyOptionState.copy$default(this.state, null, null, color, 0, 11, null);
            return this;
        }

        public final Builder backgroundColor(int color) {
            this.state = QuickReplyOptionState.copy$default(this.state, null, null, 0, color, 7, null);
            return this;
        }

        public final QuickReplyOptionState getState() {
            return this.state;
        }
    }
}
