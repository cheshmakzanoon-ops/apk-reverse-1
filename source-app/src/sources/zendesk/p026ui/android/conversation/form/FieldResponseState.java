package zendesk.p026ui.android.conversation.form;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u000e\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001\u001bB%\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\u000e\u0010\r\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u000eJ\u000e\u0010\u000f\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0010J\u000e\u0010\u0011\u001a\u00020\u0006HÀ\u0003¢\u0006\u0002\b\u0012J'\u0010\u0013\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0003\u0010\u0005\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0006HÖ\u0001J\u0006\u0010\u0018\u001a\u00020\u0019J\t\u0010\u001a\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0014\u0010\u0005\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\t¨\u0006\u001c"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldResponseState;", "", "title", "", "response", "textColor", "", "(Ljava/lang/String;Ljava/lang/String;I)V", "getResponse$zendesk_ui_ui_android", "()Ljava/lang/String;", "getTextColor$zendesk_ui_ui_android", "()I", "getTitle$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "copy", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/form/FieldResponseState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FieldResponseState {
    public static final int $stable = 0;
    private final String response;
    private final int textColor;
    private final String title;

    public FieldResponseState() {
        this(null, null, 0, 7, null);
    }

    public static FieldResponseState copy$default(FieldResponseState fieldResponseState, String str, String str2, int i, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            str = fieldResponseState.title;
        }
        if ((i2 & 2) != 0) {
            str2 = fieldResponseState.response;
        }
        if ((i2 & 4) != 0) {
            i = fieldResponseState.textColor;
        }
        return fieldResponseState.copy(str, str2, i);
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getResponse() {
        return this.response;
    }

    public final int getTextColor() {
        return this.textColor;
    }

    public final FieldResponseState copy(String title, String response, int textColor) {
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(response, "response");
        return new FieldResponseState(title, response, textColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof FieldResponseState)) {
            return false;
        }
        FieldResponseState fieldResponseState = (FieldResponseState) other;
        return Intrinsics.areEqual(this.title, fieldResponseState.title) && Intrinsics.areEqual(this.response, fieldResponseState.response) && this.textColor == fieldResponseState.textColor;
    }

    public int hashCode() {
        return (((this.title.hashCode() * 31) + this.response.hashCode()) * 31) + this.textColor;
    }

    public String toString() {
        return "FieldResponseState(title=" + this.title + ", response=" + this.response + ", textColor=" + this.textColor + ')';
    }

    public FieldResponseState(String title, String response, int i) {
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(response, "response");
        this.title = title;
        this.response = response;
        this.textColor = i;
    }

    public FieldResponseState(String str, String str2, int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this((i2 & 1) != 0 ? "" : str, (i2 & 2) != 0 ? "" : str2, (i2 & 4) != 0 ? 0 : i);
    }

    public final String getTitle$zendesk_ui_ui_android() {
        return this.title;
    }

    public final String getResponse$zendesk_ui_ui_android() {
        return this.response;
    }

    public final int getTextColor$zendesk_ui_ui_android() {
        return this.textColor;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0003J\u000e\u0010\u0007\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\tJ\u000e\u0010\n\u001a\u00020\b2\u0006\u0010\n\u001a\u00020\tR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u000b"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldResponseState$Builder;", "", "state", "Lzendesk/ui/android/conversation/form/FieldResponseState;", "(Lzendesk/ui/android/conversation/form/FieldResponseState;)V", "()V", "build", "response", "", "", "title", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private FieldResponseState state;

        public Builder() {
            this.state = new FieldResponseState(null, null, 0, 7, null);
        }

        public Builder(FieldResponseState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final void title(String title) {
            Intrinsics.checkNotNullParameter(title, "title");
            this.state = FieldResponseState.copy$default(this.state, title, null, 0, 6, null);
        }

        public final void response(String response) {
            Intrinsics.checkNotNullParameter(response, "response");
            this.state = FieldResponseState.copy$default(this.state, null, response, 0, 5, null);
        }

        public final FieldResponseState getState() {
            return this.state;
        }
    }
}
