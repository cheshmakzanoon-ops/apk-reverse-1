package zendesk.p026ui.android.conversation.form;

import java.util.LinkedHashMap;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010%\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0002\b\u0004\b\u0087\b\u0018\u00002\u00020\u0001B#\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0014\b\u0002\u0010\u0004\u001a\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00070\u0005¢\u0006\u0002\u0010\bJ\t\u0010\r\u001a\u00020\u0003HÆ\u0003J\u0015\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00070\u0005HÆ\u0003J)\u0010\u000f\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\u0014\b\u0002\u0010\u0004\u001a\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00070\u0005HÆ\u0001J\u0013\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0006HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001R\u001d\u0010\u0004\u001a\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00070\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\f¨\u0006\u0015"}, m18d2 = {"Lzendesk/ui/android/conversation/form/DisplayedForm;", "", "formId", "", "fields", "", "", "Lzendesk/ui/android/conversation/form/DisplayedField;", "(Ljava/lang/String;Ljava/util/Map;)V", "getFields", "()Ljava/util/Map;", "getFormId", "()Ljava/lang/String;", "component1", "component2", "copy", "equals", "", "other", "hashCode", "toString", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DisplayedForm {
    public static final int $stable = 8;
    private final Map<Integer, DisplayedField> fields;
    private final String formId;

    public static DisplayedForm copy$default(DisplayedForm displayedForm, String str, Map map, int i, Object obj) {
        if ((i & 1) != 0) {
            str = displayedForm.formId;
        }
        if ((i & 2) != 0) {
            map = displayedForm.fields;
        }
        return displayedForm.copy(str, map);
    }

    public final String getFormId() {
        return this.formId;
    }

    public final Map<Integer, DisplayedField> component2() {
        return this.fields;
    }

    public final DisplayedForm copy(String formId, Map<Integer, DisplayedField> fields) {
        Intrinsics.checkNotNullParameter(formId, "formId");
        Intrinsics.checkNotNullParameter(fields, "fields");
        return new DisplayedForm(formId, fields);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof DisplayedForm)) {
            return false;
        }
        DisplayedForm displayedForm = (DisplayedForm) other;
        return Intrinsics.areEqual(this.formId, displayedForm.formId) && Intrinsics.areEqual(this.fields, displayedForm.fields);
    }

    public int hashCode() {
        return (this.formId.hashCode() * 31) + this.fields.hashCode();
    }

    public String toString() {
        return "DisplayedForm(formId=" + this.formId + ", fields=" + this.fields + ')';
    }

    public DisplayedForm(String formId, Map<Integer, DisplayedField> fields) {
        Intrinsics.checkNotNullParameter(formId, "formId");
        Intrinsics.checkNotNullParameter(fields, "fields");
        this.formId = formId;
        this.fields = fields;
    }

    public final String getFormId() {
        return this.formId;
    }

    public DisplayedForm(String str, LinkedHashMap linkedHashMap, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, (i & 2) != 0 ? new LinkedHashMap() : linkedHashMap);
    }

    public final Map<Integer, DisplayedField> getFields() {
        return this.fields;
    }
}
