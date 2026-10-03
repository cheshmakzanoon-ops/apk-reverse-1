package zendesk.p026ui.android.conversation.form;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001J\t\u0010\u0011\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/ui/android/conversation/form/SelectOption;", "", "id", "", "label", "(Ljava/lang/String;Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "getLabel", "component1", "component2", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class SelectOption {
    public static final int $stable = 0;
    private final String id;
    private final String label;

    public static SelectOption copy$default(SelectOption selectOption, String str, String str2, int i, Object obj) {
        if ((i & 1) != 0) {
            str = selectOption.id;
        }
        if ((i & 2) != 0) {
            str2 = selectOption.label;
        }
        return selectOption.copy(str, str2);
    }

    public final String getId() {
        return this.id;
    }

    public final String getLabel() {
        return this.label;
    }

    public final SelectOption copy(String id, String label) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(label, "label");
        return new SelectOption(id, label);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof SelectOption)) {
            return false;
        }
        SelectOption selectOption = (SelectOption) other;
        return Intrinsics.areEqual(this.id, selectOption.id) && Intrinsics.areEqual(this.label, selectOption.label);
    }

    public int hashCode() {
        return (this.id.hashCode() * 31) + this.label.hashCode();
    }

    public String toString() {
        return "SelectOption(id=" + this.id + ", label=" + this.label + ')';
    }

    public SelectOption(String id, String label) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(label, "label");
        this.id = id;
        this.label = label;
    }

    public final String getId() {
        return this.id;
    }

    public final String getLabel() {
        return this.label;
    }
}
