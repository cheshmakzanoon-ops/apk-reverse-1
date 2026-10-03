package zendesk.p026ui.android.conversation.form;

import cz.msebera.android.httpclient.HttpStatus;
import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0002\b$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001:\u00013B_\u0012\b\b\u0003\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0005\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0006\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0007\u001a\u00020\u0003\u0012\b\b\u0003\u0010\b\u001a\u00020\u0003\u0012\b\b\u0003\u0010\t\u001a\u00020\u0003\u0012\b\b\u0002\u0010\n\u001a\u00020\u000b\u0012\b\b\u0002\u0010\f\u001a\u00020\u000b¢\u0006\u0002\u0010\rJ\u000e\u0010\u0019\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u001aJ\u000e\u0010\u001b\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u001cJ\u000e\u0010\u001d\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u001eJ\u000e\u0010\u001f\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b J\u000e\u0010!\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\"J\u000e\u0010#\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b$J\u000e\u0010%\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b&J\u000e\u0010'\u001a\u00020\u000bHÀ\u0003¢\u0006\u0002\b(J\u000e\u0010)\u001a\u00020\u000bHÀ\u0003¢\u0006\u0002\b*Jc\u0010+\u001a\u00020\u00002\b\b\u0003\u0010\u0002\u001a\u00020\u00032\b\b\u0003\u0010\u0004\u001a\u00020\u00032\b\b\u0003\u0010\u0005\u001a\u00020\u00032\b\b\u0003\u0010\u0006\u001a\u00020\u00032\b\b\u0003\u0010\u0007\u001a\u00020\u00032\b\b\u0003\u0010\b\u001a\u00020\u00032\b\b\u0003\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\u000bHÆ\u0001J\u0013\u0010,\u001a\u00020\u000b2\b\u0010-\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010.\u001a\u00020\u0003HÖ\u0001J\u0006\u0010/\u001a\u000200J\t\u00101\u001a\u000202HÖ\u0001R\u0014\u0010\t\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000fR\u0014\u0010\u0006\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u000fR\u0014\u0010\u0005\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u000fR\u0014\u0010\f\u001a\u00020\u000bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0014\u0010\u0007\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u000fR\u0014\u0010\u0004\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u000fR\u0014\u0010\n\u001a\u00020\u000bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0014R\u0014\u0010\b\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u000f¨\u00064"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FormState;", "", "colorAccent", "", "onDangerColor", "focusedFieldBorderColor", "fieldBorderColor", "onActionColor", "textColor", "backgroundColor", "pending", "", "hasFailed", "(IIIIIIIZZ)V", "getBackgroundColor$zendesk_ui_ui_android", "()I", "getColorAccent$zendesk_ui_ui_android", "getFieldBorderColor$zendesk_ui_ui_android", "getFocusedFieldBorderColor$zendesk_ui_ui_android", "getHasFailed$zendesk_ui_ui_android", "()Z", "getOnActionColor$zendesk_ui_ui_android", "getOnDangerColor$zendesk_ui_ui_android", "getPending$zendesk_ui_ui_android", "getTextColor$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "component7$zendesk_ui_ui_android", "component8", "component8$zendesk_ui_ui_android", "component9", "component9$zendesk_ui_ui_android", "copy", "equals", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/form/FormState$Builder;", "toString", "", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FormState {
    public static final int $stable = 0;
    private final int backgroundColor;
    private final int colorAccent;
    private final int fieldBorderColor;
    private final int focusedFieldBorderColor;
    private final boolean hasFailed;
    private final int onActionColor;
    private final int onDangerColor;
    private final boolean pending;
    private final int textColor;

    public FormState() {
        this(0, 0, 0, 0, 0, 0, 0, false, false, 511, null);
    }

    public static FormState copy$default(FormState formState, int i, int i2, int i3, int i4, int i5, int i6, int i7, boolean z, boolean z2, int i8, Object obj) {
        return formState.copy((i8 & 1) != 0 ? formState.colorAccent : i, (i8 & 2) != 0 ? formState.onDangerColor : i2, (i8 & 4) != 0 ? formState.focusedFieldBorderColor : i3, (i8 & 8) != 0 ? formState.fieldBorderColor : i4, (i8 & 16) != 0 ? formState.onActionColor : i5, (i8 & 32) != 0 ? formState.textColor : i6, (i8 & 64) != 0 ? formState.backgroundColor : i7, (i8 & 128) != 0 ? formState.pending : z, (i8 & 256) != 0 ? formState.hasFailed : z2);
    }

    public final int getColorAccent() {
        return this.colorAccent;
    }

    public final int getOnDangerColor() {
        return this.onDangerColor;
    }

    public final int getFocusedFieldBorderColor() {
        return this.focusedFieldBorderColor;
    }

    public final int getFieldBorderColor() {
        return this.fieldBorderColor;
    }

    public final int getOnActionColor() {
        return this.onActionColor;
    }

    public final int getTextColor() {
        return this.textColor;
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final boolean getPending() {
        return this.pending;
    }

    public final boolean getHasFailed() {
        return this.hasFailed;
    }

    public final FormState copy(int colorAccent, int onDangerColor, int focusedFieldBorderColor, int fieldBorderColor, int onActionColor, int textColor, int backgroundColor, boolean pending, boolean hasFailed) {
        return new FormState(colorAccent, onDangerColor, focusedFieldBorderColor, fieldBorderColor, onActionColor, textColor, backgroundColor, pending, hasFailed);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof FormState)) {
            return false;
        }
        FormState formState = (FormState) other;
        return this.colorAccent == formState.colorAccent && this.onDangerColor == formState.onDangerColor && this.focusedFieldBorderColor == formState.focusedFieldBorderColor && this.fieldBorderColor == formState.fieldBorderColor && this.onActionColor == formState.onActionColor && this.textColor == formState.textColor && this.backgroundColor == formState.backgroundColor && this.pending == formState.pending && this.hasFailed == formState.hasFailed;
    }

    public int hashCode() {
        return (((((((((((((((this.colorAccent * 31) + this.onDangerColor) * 31) + this.focusedFieldBorderColor) * 31) + this.fieldBorderColor) * 31) + this.onActionColor) * 31) + this.textColor) * 31) + this.backgroundColor) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.pending)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.hasFailed);
    }

    public String toString() {
        return "FormState(colorAccent=" + this.colorAccent + ", onDangerColor=" + this.onDangerColor + ", focusedFieldBorderColor=" + this.focusedFieldBorderColor + ", fieldBorderColor=" + this.fieldBorderColor + ", onActionColor=" + this.onActionColor + ", textColor=" + this.textColor + ", backgroundColor=" + this.backgroundColor + ", pending=" + this.pending + ", hasFailed=" + this.hasFailed + ')';
    }

    public FormState(int i, int i2, int i3, int i4, int i5, int i6, int i7, boolean z, boolean z2) {
        this.colorAccent = i;
        this.onDangerColor = i2;
        this.focusedFieldBorderColor = i3;
        this.fieldBorderColor = i4;
        this.onActionColor = i5;
        this.textColor = i6;
        this.backgroundColor = i7;
        this.pending = z;
        this.hasFailed = z2;
    }

    public FormState(int i, int i2, int i3, int i4, int i5, int i6, int i7, boolean z, boolean z2, int i8, DefaultConstructorMarker defaultConstructorMarker) {
        this((i8 & 1) != 0 ? 0 : i, (i8 & 2) != 0 ? 0 : i2, (i8 & 4) != 0 ? 0 : i3, (i8 & 8) != 0 ? 0 : i4, (i8 & 16) != 0 ? 0 : i5, (i8 & 32) != 0 ? 0 : i6, (i8 & 64) != 0 ? 0 : i7, (i8 & 128) != 0 ? false : z, (i8 & 256) == 0 ? z2 : false);
    }

    public final int getColorAccent$zendesk_ui_ui_android() {
        return this.colorAccent;
    }

    public final int getOnDangerColor$zendesk_ui_ui_android() {
        return this.onDangerColor;
    }

    public final int getFocusedFieldBorderColor$zendesk_ui_ui_android() {
        return this.focusedFieldBorderColor;
    }

    public final int getFieldBorderColor$zendesk_ui_ui_android() {
        return this.fieldBorderColor;
    }

    public final int getOnActionColor$zendesk_ui_ui_android() {
        return this.onActionColor;
    }

    public final int getTextColor$zendesk_ui_ui_android() {
        return this.textColor;
    }

    public final int getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final boolean getPending$zendesk_ui_ui_android() {
        return this.pending;
    }

    public final boolean getHasFailed$zendesk_ui_ui_android() {
        return this.hasFailed;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0003J\u0010\u0010\u0007\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0010\u0010\t\u001a\u00020\u00002\b\b\u0001\u0010\t\u001a\u00020\bJ\u000e\u0010\n\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u000bJ\u0010\u0010\f\u001a\u00020\u00002\b\b\u0001\u0010\f\u001a\u00020\bJ\u000e\u0010\r\u001a\u00020\u00002\u0006\u0010\r\u001a\u00020\u000bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u000e"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FormState$Builder;", "", "state", "Lzendesk/ui/android/conversation/form/FormState;", "(Lzendesk/ui/android/conversation/form/FormState;)V", "()V", "build", "fieldBorderColor", "", "focusedFieldBorderColor", "hasFailed", "", "onActionColor", "pending", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private FormState state;

        public Builder() {
            this.state = new FormState(0, 0, 0, 0, 0, 0, 0, false, false, 511, null);
        }

        public Builder(FormState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder pending(boolean pending) {
            this.state = FormState.copy$default(this.state, 0, 0, 0, 0, 0, 0, 0, pending, false, 383, null);
            return this;
        }

        public final Builder onActionColor(int onActionColor) {
            this.state = FormState.copy$default(this.state, 0, 0, 0, 0, onActionColor, 0, 0, false, false, 495, null);
            return this;
        }

        public final Builder focusedFieldBorderColor(int focusedFieldBorderColor) {
            this.state = FormState.copy$default(this.state, 0, 0, focusedFieldBorderColor, 0, 0, 0, 0, false, false, HttpStatus.SC_INSUFFICIENT_STORAGE, null);
            return this;
        }

        public final Builder fieldBorderColor(int fieldBorderColor) {
            this.state = FormState.copy$default(this.state, 0, 0, 0, fieldBorderColor, 0, 0, 0, false, false, HttpStatus.SC_SERVICE_UNAVAILABLE, null);
            return this;
        }

        public final Builder hasFailed(boolean hasFailed) {
            this.state = FormState.copy$default(this.state, 0, 0, 0, 0, 0, 0, 0, false, hasFailed, 255, null);
            return this;
        }

        public final FormState getState() {
            return this.state;
        }
    }
}
