package zendesk.messaging.android.internal.validation.model;

import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u000e\b\u0080\u0081\u0002\u0018\u0000 \u00102\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001\u0010B\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006j\u0002\b\u0007j\u0002\b\bj\u0002\b\tj\u0002\b\nj\u0002\b\u000bj\u0002\b\fj\u0002\b\rj\u0002\b\u000ej\u0002\b\u000f¨\u0006\u0011"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/model/FieldType;", "", "value", "", "(Ljava/lang/String;ILjava/lang/String;)V", "getValue", "()Ljava/lang/String;", "TEXT", "DECIMAL", "NUMBER", "DATE", "CHECKBOX", "DROP_DOWN", "REGEXP", "MULTI_LINE", "MULTI_SELECT", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public enum FieldType {
    TEXT("text"),
    DECIMAL("decimal"),
    NUMBER("integer"),
    DATE("date"),
    CHECKBOX("checkbox"),
    DROP_DOWN("tagger"),
    REGEXP("regexp"),
    MULTI_LINE("textarea"),
    MULTI_SELECT("multiselect");

    private final String value;
    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static final Companion INSTANCE = new Companion(null);

    public static EnumEntries<FieldType> getEntries() {
        return $ENTRIES;
    }

    FieldType(String str) {
        this.value = str;
    }

    public final String getValue() {
        return this.value;
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u0004\u0018\u00010\u00042\u0006\u0010\u0005\u001a\u00020\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/model/FieldType$Companion;", "", "()V", "findByValue", "Lzendesk/messaging/android/internal/validation/model/FieldType;", "value", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final FieldType findByValue(String value) {
            Intrinsics.checkNotNullParameter(value, "value");
            for (FieldType fieldType : FieldType.values()) {
                if (Intrinsics.areEqual(fieldType.getValue(), value)) {
                    return fieldType;
                }
            }
            return null;
        }
    }
}
