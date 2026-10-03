package zendesk.p026ui.android.conversation.form;

import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001:\u0001!B5\b\u0000\u0012\b\b\u0003\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0005\u001a\u00020\u0003\u0012\u000e\b\u0002\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007¢\u0006\u0002\u0010\tJ\u000e\u0010\u0010\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0011J\u000e\u0010\u0012\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0013J\u000e\u0010\u0014\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0015J\u0014\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\b0\u0007HÀ\u0003¢\u0006\u0002\b\u0017J7\u0010\u0018\u001a\u00020\u00002\b\b\u0003\u0010\u0002\u001a\u00020\u00032\b\b\u0003\u0010\u0004\u001a\u00020\u00032\b\b\u0003\u0010\u0005\u001a\u00020\u00032\u000e\b\u0002\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007HÆ\u0001J\u0013\u0010\u0019\u001a\u00020\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001c\u001a\u00020\u0003HÖ\u0001J\u0006\u0010\u001d\u001a\u00020\u001eJ\t\u0010\u001f\u001a\u00020 HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0014\u0010\u0005\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\u000bR\u001a\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000b¨\u0006\""}, m18d2 = {"Lzendesk/ui/android/conversation/form/FormResponseState;", "", "textColor", "", "backgroundColor", "borderColor", "fieldResponses", "", "Lzendesk/ui/android/conversation/form/FieldResponse;", "(IIILjava/util/List;)V", "getBackgroundColor$zendesk_ui_ui_android", "()I", "getBorderColor$zendesk_ui_ui_android", "getFieldResponses$zendesk_ui_ui_android", "()Ljava/util/List;", "getTextColor$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "copy", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/form/FormResponseState$Builder;", "toString", "", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FormResponseState {
    public static final int $stable = 8;
    private final int backgroundColor;
    private final int borderColor;
    private final List<FieldResponse> fieldResponses;
    private final int textColor;

    public FormResponseState() {
        this(0, 0, 0, null, 15, null);
    }

    public static FormResponseState copy$default(FormResponseState formResponseState, int i, int i2, int i3, List list, int i4, Object obj) {
        if ((i4 & 1) != 0) {
            i = formResponseState.textColor;
        }
        if ((i4 & 2) != 0) {
            i2 = formResponseState.backgroundColor;
        }
        if ((i4 & 4) != 0) {
            i3 = formResponseState.borderColor;
        }
        if ((i4 & 8) != 0) {
            list = formResponseState.fieldResponses;
        }
        return formResponseState.copy(i, i2, i3, list);
    }

    public final int getTextColor() {
        return this.textColor;
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final int getBorderColor() {
        return this.borderColor;
    }

    public final List<FieldResponse> component4$zendesk_ui_ui_android() {
        return this.fieldResponses;
    }

    public final FormResponseState copy(int textColor, int backgroundColor, int borderColor, List<FieldResponse> fieldResponses) {
        Intrinsics.checkNotNullParameter(fieldResponses, "fieldResponses");
        return new FormResponseState(textColor, backgroundColor, borderColor, fieldResponses);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof FormResponseState)) {
            return false;
        }
        FormResponseState formResponseState = (FormResponseState) other;
        return this.textColor == formResponseState.textColor && this.backgroundColor == formResponseState.backgroundColor && this.borderColor == formResponseState.borderColor && Intrinsics.areEqual(this.fieldResponses, formResponseState.fieldResponses);
    }

    public int hashCode() {
        return (((((this.textColor * 31) + this.backgroundColor) * 31) + this.borderColor) * 31) + this.fieldResponses.hashCode();
    }

    public String toString() {
        return "FormResponseState(textColor=" + this.textColor + ", backgroundColor=" + this.backgroundColor + ", borderColor=" + this.borderColor + ", fieldResponses=" + this.fieldResponses + ')';
    }

    public FormResponseState(int i, int i2, int i3, List<FieldResponse> fieldResponses) {
        Intrinsics.checkNotNullParameter(fieldResponses, "fieldResponses");
        this.textColor = i;
        this.backgroundColor = i2;
        this.borderColor = i3;
        this.fieldResponses = fieldResponses;
    }

    public final int getTextColor$zendesk_ui_ui_android() {
        return this.textColor;
    }

    public final int getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final int getBorderColor$zendesk_ui_ui_android() {
        return this.borderColor;
    }

    public FormResponseState(int i, int i2, int i3, List list, int i4, DefaultConstructorMarker defaultConstructorMarker) {
        this((i4 & 1) != 0 ? 0 : i, (i4 & 2) != 0 ? 0 : i2, (i4 & 4) != 0 ? 0 : i3, (i4 & 8) != 0 ? CollectionsKt.emptyList() : list);
    }

    public final List<FieldResponse> getFieldResponses$zendesk_ui_ui_android() {
        return this.fieldResponses;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0010\u0010\u0006\u001a\u00020\u00002\b\b\u0001\u0010\u0006\u001a\u00020\u0007J\u0010\u0010\b\u001a\u00020\u00002\b\b\u0001\u0010\b\u001a\u00020\u0007J\u0006\u0010\t\u001a\u00020\u0003J\u0014\u0010\n\u001a\u00020\u00002\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000bJ\u0010\u0010\r\u001a\u00020\u00002\b\b\u0001\u0010\r\u001a\u00020\u0007R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u000e"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FormResponseState$Builder;", "", "state", "Lzendesk/ui/android/conversation/form/FormResponseState;", "(Lzendesk/ui/android/conversation/form/FormResponseState;)V", "()V", "backgroundColor", "", "borderColor", "build", "fieldResponses", "", "Lzendesk/ui/android/conversation/form/FieldResponse;", "textColor", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private FormResponseState state;

        public Builder() {
            this.state = new FormResponseState(0, 0, 0, null, 15, null);
        }

        public Builder(FormResponseState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder fieldResponses(List<FieldResponse> fieldResponses) {
            Intrinsics.checkNotNullParameter(fieldResponses, "fieldResponses");
            this.state = FormResponseState.copy$default(this.state, 0, 0, 0, fieldResponses, 7, null);
            return this;
        }

        public final Builder borderColor(int borderColor) {
            this.state = FormResponseState.copy$default(this.state, 0, 0, borderColor, null, 11, null);
            return this;
        }

        public final Builder textColor(int textColor) {
            this.state = FormResponseState.copy$default(this.state, textColor, 0, 0, null, 14, null);
            return this;
        }

        public final Builder backgroundColor(int backgroundColor) {
            this.state = FormResponseState.copy$default(this.state, 0, backgroundColor, 0, null, 13, null);
            return this;
        }

        public final FormResponseState getState() {
            return this.state;
        }
    }
}
