package zendesk.messaging.android.internal.validation.model;

import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0080\b\u0018\u00002\u00020\u0001B;\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0001\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0003\u0012\u0010\b\u0002\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0007\u0012\u0006\u0010\b\u001a\u00020\u0003¢\u0006\u0002\u0010\tJ\t\u0010\u0012\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0013\u001a\u00020\u0001HÆ\u0003J\u000b\u0010\u0014\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u0011\u0010\u0015\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0007HÆ\u0003J\t\u0010\u0016\u001a\u00020\u0003HÆ\u0003JE\u0010\u0017\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00032\u0010\b\u0002\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u00072\b\b\u0002\u0010\b\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u0018\u001a\u00020\u00192\b\u0010\u001a\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001b\u001a\u00020\u001cHÖ\u0001J\t\u0010\u001d\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0019\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0013\u0010\u0005\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000bR\u0011\u0010\b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000bR\u0011\u0010\u0004\u001a\u00020\u0001¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011¨\u0006\u001e"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/model/FieldData;", "", "id", "", "value", "regex", "options", "", "type", "(Ljava/lang/String;Ljava/lang/Object;Ljava/lang/String;Ljava/util/List;Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "getOptions", "()Ljava/util/List;", "getRegex", "getType", "getValue", "()Ljava/lang/Object;", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FieldData {
    private final String id;
    private final List<String> options;
    private final String regex;
    private final String type;
    private final Object value;

    public static FieldData copy$default(FieldData fieldData, String str, Object obj, String str2, List list, String str3, int i, Object obj2) {
        if ((i & 1) != 0) {
            str = fieldData.id;
        }
        if ((i & 2) != 0) {
            obj = fieldData.value;
        }
        Object obj3 = obj;
        if ((i & 4) != 0) {
            str2 = fieldData.regex;
        }
        String str4 = str2;
        if ((i & 8) != 0) {
            list = fieldData.options;
        }
        List list2 = list;
        if ((i & 16) != 0) {
            str3 = fieldData.type;
        }
        return fieldData.copy(str, obj3, str4, list2, str3);
    }

    public final String getId() {
        return this.id;
    }

    public final Object getValue() {
        return this.value;
    }

    public final String getRegex() {
        return this.regex;
    }

    public final List<String> component4() {
        return this.options;
    }

    public final String getType() {
        return this.type;
    }

    public final FieldData copy(String id, Object value, String regex, List<String> options, String type) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(value, "value");
        Intrinsics.checkNotNullParameter(type, "type");
        return new FieldData(id, value, regex, options, type);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof FieldData)) {
            return false;
        }
        FieldData fieldData = (FieldData) other;
        return Intrinsics.areEqual(this.id, fieldData.id) && Intrinsics.areEqual(this.value, fieldData.value) && Intrinsics.areEqual(this.regex, fieldData.regex) && Intrinsics.areEqual(this.options, fieldData.options) && Intrinsics.areEqual(this.type, fieldData.type);
    }

    public int hashCode() {
        int iHashCode = ((this.id.hashCode() * 31) + this.value.hashCode()) * 31;
        String str = this.regex;
        int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
        List<String> list = this.options;
        return ((iHashCode2 + (list != null ? list.hashCode() : 0)) * 31) + this.type.hashCode();
    }

    public String toString() {
        return "FieldData(id=" + this.id + ", value=" + this.value + ", regex=" + this.regex + ", options=" + this.options + ", type=" + this.type + ')';
    }

    public FieldData(String id, Object value, String str, List<String> list, String type) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(value, "value");
        Intrinsics.checkNotNullParameter(type, "type");
        this.id = id;
        this.value = value;
        this.regex = str;
        this.options = list;
        this.type = type;
    }

    public FieldData(String str, Object obj, String str2, List list, String str3, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, obj, (i & 4) != 0 ? null : str2, (i & 8) != 0 ? null : list, str3);
    }

    public final String getId() {
        return this.id;
    }

    public final Object getValue() {
        return this.value;
    }

    public final String getRegex() {
        return this.regex;
    }

    public final List<String> getOptions() {
        return this.options;
    }

    public final String getType() {
        return this.type;
    }
}
