package zendesk.messaging.android.internal.validation.model;

import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.android.internal.validation.ValidationRules;

@Metadata(m17d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001:\t\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017B\u000f\b\u0004\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u001a\u0010\u000b\u001a\u0004\u0018\u00010\u00062\u0006\u0010\f\u001a\u00020\u00012\u0006\u0010\r\u001a\u00020\u000eH&R\u0012\u0010\u0005\u001a\u00020\u0006X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n\u0082\u0001\t\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f ¨\u0006!"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/model/ConversationField;", "", "type", "Lzendesk/messaging/android/internal/validation/model/FieldType;", "(Lzendesk/messaging/android/internal/validation/model/FieldType;)V", "id", "", "getId", "()Ljava/lang/String;", "getType", "()Lzendesk/messaging/android/internal/validation/model/FieldType;", "validate", "value", "rules", "Lzendesk/messaging/android/internal/validation/ValidationRules;", "CheckBox", "Date", "Decimal", "MultiSelect", "Number", "Regex", "Tagger", "Text", "TextArea", "Lzendesk/messaging/android/internal/validation/model/ConversationField$CheckBox;", "Lzendesk/messaging/android/internal/validation/model/ConversationField$Date;", "Lzendesk/messaging/android/internal/validation/model/ConversationField$Decimal;", "Lzendesk/messaging/android/internal/validation/model/ConversationField$MultiSelect;", "Lzendesk/messaging/android/internal/validation/model/ConversationField$Number;", "Lzendesk/messaging/android/internal/validation/model/ConversationField$Regex;", "Lzendesk/messaging/android/internal/validation/model/ConversationField$Tagger;", "Lzendesk/messaging/android/internal/validation/model/ConversationField$Text;", "Lzendesk/messaging/android/internal/validation/model/ConversationField$TextArea;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class ConversationField {
    private final FieldType type;

    public ConversationField(FieldType fieldType, DefaultConstructorMarker defaultConstructorMarker) {
        this(fieldType);
    }

    public abstract String getId();

    public abstract String validate(Object value, ValidationRules rules);

    private ConversationField(FieldType fieldType) {
        this.type = fieldType;
    }

    public final FieldType getType() {
        return this.type;
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001J\u001a\u0010\u0010\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0011\u001a\u00020\f2\u0006\u0010\u0012\u001a\u00020\u0013H\u0016R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0014"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/model/ConversationField$Text;", "Lzendesk/messaging/android/internal/validation/model/ConversationField;", "id", "", "(Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "validate", "value", "rules", "Lzendesk/messaging/android/internal/validation/ValidationRules;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Text extends ConversationField {
        private final String id;

        public static Text copy$default(Text text, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = text.id;
            }
            return text.copy(str);
        }

        public final String getId() {
            return this.id;
        }

        public final Text copy(String id) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new Text(id);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof Text) && Intrinsics.areEqual(this.id, ((Text) other).id);
        }

        public int hashCode() {
            return this.id.hashCode();
        }

        public String toString() {
            return "Text(id=" + this.id + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public Text(String id) {
            super(FieldType.TEXT, null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
        }

        @Override
        public String validate(Object value, ValidationRules rules) {
            Intrinsics.checkNotNullParameter(value, "value");
            Intrinsics.checkNotNullParameter(rules, "rules");
            return rules.forText$zendesk_messaging_messaging_android(new FieldData(getId(), value, null, null, getType().name(), 12, null));
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\u000b\u0010\n\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u001f\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0003HÖ\u0001J\u001a\u0010\u0013\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0014\u001a\u00020\u000f2\u0006\u0010\u0015\u001a\u00020\u0016H\u0016R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0017"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/model/ConversationField$Decimal;", "Lzendesk/messaging/android/internal/validation/model/ConversationField;", "id", "", "regex", "(Ljava/lang/String;Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "getRegex", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "validate", "value", "rules", "Lzendesk/messaging/android/internal/validation/ValidationRules;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Decimal extends ConversationField {
        private final String id;
        private final String regex;

        public static Decimal copy$default(Decimal decimal, String str, String str2, int i, Object obj) {
            if ((i & 1) != 0) {
                str = decimal.id;
            }
            if ((i & 2) != 0) {
                str2 = decimal.regex;
            }
            return decimal.copy(str, str2);
        }

        public final String getId() {
            return this.id;
        }

        public final String getRegex() {
            return this.regex;
        }

        public final Decimal copy(String id, String regex) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new Decimal(id, regex);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Decimal)) {
                return false;
            }
            Decimal decimal = (Decimal) other;
            return Intrinsics.areEqual(this.id, decimal.id) && Intrinsics.areEqual(this.regex, decimal.regex);
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            String str = this.regex;
            return iHashCode + (str == null ? 0 : str.hashCode());
        }

        public String toString() {
            return "Decimal(id=" + this.id + ", regex=" + this.regex + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final String getRegex() {
            return this.regex;
        }

        public Decimal(String id, String str) {
            super(FieldType.DECIMAL, null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
            this.regex = str;
        }

        @Override
        public String validate(Object value, ValidationRules rules) {
            Intrinsics.checkNotNullParameter(value, "value");
            Intrinsics.checkNotNullParameter(rules, "rules");
            return rules.forRegex$zendesk_messaging_messaging_android(new FieldData(getId(), value, this.regex, null, getType().name(), 8, null));
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\u000b\u0010\n\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u001f\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0003HÖ\u0001J\u001a\u0010\u0013\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0014\u001a\u00020\u000f2\u0006\u0010\u0015\u001a\u00020\u0016H\u0016R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0017"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/model/ConversationField$Number;", "Lzendesk/messaging/android/internal/validation/model/ConversationField;", "id", "", "regex", "(Ljava/lang/String;Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "getRegex", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "validate", "value", "rules", "Lzendesk/messaging/android/internal/validation/ValidationRules;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Number extends ConversationField {
        private final String id;
        private final String regex;

        public static Number copy$default(Number number, String str, String str2, int i, Object obj) {
            if ((i & 1) != 0) {
                str = number.id;
            }
            if ((i & 2) != 0) {
                str2 = number.regex;
            }
            return number.copy(str, str2);
        }

        public final String getId() {
            return this.id;
        }

        public final String getRegex() {
            return this.regex;
        }

        public final Number copy(String id, String regex) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new Number(id, regex);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Number)) {
                return false;
            }
            Number number = (Number) other;
            return Intrinsics.areEqual(this.id, number.id) && Intrinsics.areEqual(this.regex, number.regex);
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            String str = this.regex;
            return iHashCode + (str == null ? 0 : str.hashCode());
        }

        public String toString() {
            return "Number(id=" + this.id + ", regex=" + this.regex + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final String getRegex() {
            return this.regex;
        }

        public Number(String id, String str) {
            super(FieldType.NUMBER, null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
            this.regex = str;
        }

        @Override
        public String validate(Object value, ValidationRules rules) {
            Intrinsics.checkNotNullParameter(value, "value");
            Intrinsics.checkNotNullParameter(rules, "rules");
            return rules.forRegex$zendesk_messaging_messaging_android(new FieldData(getId(), value, this.regex, null, getType().name(), 8, null));
        }
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010 \n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u000e\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\u0011\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0005HÆ\u0003J%\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\u0010\b\u0002\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001J\u001a\u0010\u0015\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0016\u001a\u00020\u00112\u0006\u0010\u0017\u001a\u00020\u0018H\u0016R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0019\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0019"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/model/ConversationField$Tagger;", "Lzendesk/messaging/android/internal/validation/model/ConversationField;", "id", "", "options", "", "(Ljava/lang/String;Ljava/util/List;)V", "getId", "()Ljava/lang/String;", "getOptions", "()Ljava/util/List;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "validate", "value", "rules", "Lzendesk/messaging/android/internal/validation/ValidationRules;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Tagger extends ConversationField {
        private final String id;
        private final List<String> options;

        public static Tagger copy$default(Tagger tagger, String str, List list, int i, Object obj) {
            if ((i & 1) != 0) {
                str = tagger.id;
            }
            if ((i & 2) != 0) {
                list = tagger.options;
            }
            return tagger.copy(str, list);
        }

        public final String getId() {
            return this.id;
        }

        public final List<String> component2() {
            return this.options;
        }

        public final Tagger copy(String id, List<String> options) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new Tagger(id, options);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Tagger)) {
                return false;
            }
            Tagger tagger = (Tagger) other;
            return Intrinsics.areEqual(this.id, tagger.id) && Intrinsics.areEqual(this.options, tagger.options);
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            List<String> list = this.options;
            return iHashCode + (list == null ? 0 : list.hashCode());
        }

        public String toString() {
            return "Tagger(id=" + this.id + ", options=" + this.options + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final List<String> getOptions() {
            return this.options;
        }

        public Tagger(String id, List<String> list) {
            super(FieldType.DROP_DOWN, null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
            this.options = list;
        }

        @Override
        public String validate(Object value, ValidationRules rules) {
            Intrinsics.checkNotNullParameter(value, "value");
            Intrinsics.checkNotNullParameter(rules, "rules");
            return rules.forTagger$zendesk_messaging_messaging_android(new FieldData(getId(), value, null, this.options, getType().name(), 4, null));
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\u000b\u0010\n\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u001f\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0003HÖ\u0001J\u001a\u0010\u0013\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0014\u001a\u00020\u000f2\u0006\u0010\u0015\u001a\u00020\u0016H\u0016R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0017"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/model/ConversationField$Date;", "Lzendesk/messaging/android/internal/validation/model/ConversationField;", "id", "", "regex", "(Ljava/lang/String;Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "getRegex", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "validate", "value", "rules", "Lzendesk/messaging/android/internal/validation/ValidationRules;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Date extends ConversationField {
        private final String id;
        private final String regex;

        public static Date copy$default(Date date, String str, String str2, int i, Object obj) {
            if ((i & 1) != 0) {
                str = date.id;
            }
            if ((i & 2) != 0) {
                str2 = date.regex;
            }
            return date.copy(str, str2);
        }

        public final String getId() {
            return this.id;
        }

        public final String getRegex() {
            return this.regex;
        }

        public final Date copy(String id, String regex) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new Date(id, regex);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Date)) {
                return false;
            }
            Date date = (Date) other;
            return Intrinsics.areEqual(this.id, date.id) && Intrinsics.areEqual(this.regex, date.regex);
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            String str = this.regex;
            return iHashCode + (str == null ? 0 : str.hashCode());
        }

        public String toString() {
            return "Date(id=" + this.id + ", regex=" + this.regex + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final String getRegex() {
            return this.regex;
        }

        public Date(String id, String str) {
            super(FieldType.DATE, null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
            this.regex = str;
        }

        @Override
        public String validate(Object value, ValidationRules rules) {
            Intrinsics.checkNotNullParameter(value, "value");
            Intrinsics.checkNotNullParameter(rules, "rules");
            return rules.forRegex$zendesk_messaging_messaging_android(new FieldData(getId(), value, this.regex, null, getType().name(), 8, null));
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\u000b\u0010\n\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u001f\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0003HÖ\u0001J\u001a\u0010\u0013\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0014\u001a\u00020\u000f2\u0006\u0010\u0015\u001a\u00020\u0016H\u0016R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0017"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/model/ConversationField$Regex;", "Lzendesk/messaging/android/internal/validation/model/ConversationField;", "id", "", "regex", "(Ljava/lang/String;Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "getRegex", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "validate", "value", "rules", "Lzendesk/messaging/android/internal/validation/ValidationRules;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Regex extends ConversationField {
        private final String id;
        private final String regex;

        public static Regex copy$default(Regex regex, String str, String str2, int i, Object obj) {
            if ((i & 1) != 0) {
                str = regex.id;
            }
            if ((i & 2) != 0) {
                str2 = regex.regex;
            }
            return regex.copy(str, str2);
        }

        public final String getId() {
            return this.id;
        }

        public final String getRegex() {
            return this.regex;
        }

        public final Regex copy(String id, String regex) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new Regex(id, regex);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Regex)) {
                return false;
            }
            Regex regex = (Regex) other;
            return Intrinsics.areEqual(this.id, regex.id) && Intrinsics.areEqual(this.regex, regex.regex);
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            String str = this.regex;
            return iHashCode + (str == null ? 0 : str.hashCode());
        }

        public String toString() {
            return "Regex(id=" + this.id + ", regex=" + this.regex + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final String getRegex() {
            return this.regex;
        }

        public Regex(String id, String str) {
            super(FieldType.REGEXP, null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
            this.regex = str;
        }

        @Override
        public String validate(Object value, ValidationRules rules) {
            Intrinsics.checkNotNullParameter(value, "value");
            Intrinsics.checkNotNullParameter(rules, "rules");
            return rules.forRegex$zendesk_messaging_messaging_android(new FieldData(getId(), value, this.regex, null, getType().name(), 8, null));
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001J\u001a\u0010\u0010\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0011\u001a\u00020\f2\u0006\u0010\u0012\u001a\u00020\u0013H\u0016R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0014"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/model/ConversationField$CheckBox;", "Lzendesk/messaging/android/internal/validation/model/ConversationField;", "id", "", "(Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "validate", "value", "rules", "Lzendesk/messaging/android/internal/validation/ValidationRules;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class CheckBox extends ConversationField {
        private final String id;

        public static CheckBox copy$default(CheckBox checkBox, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = checkBox.id;
            }
            return checkBox.copy(str);
        }

        public final String getId() {
            return this.id;
        }

        public final CheckBox copy(String id) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new CheckBox(id);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof CheckBox) && Intrinsics.areEqual(this.id, ((CheckBox) other).id);
        }

        public int hashCode() {
            return this.id.hashCode();
        }

        public String toString() {
            return "CheckBox(id=" + this.id + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public CheckBox(String id) {
            super(FieldType.CHECKBOX, null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
        }

        @Override
        public String validate(Object value, ValidationRules rules) {
            Intrinsics.checkNotNullParameter(value, "value");
            Intrinsics.checkNotNullParameter(rules, "rules");
            return rules.forCheckBox$zendesk_messaging_messaging_android(new FieldData(getId(), value, null, null, getType().name(), 12, null));
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001J\u001a\u0010\u0010\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0011\u001a\u00020\f2\u0006\u0010\u0012\u001a\u00020\u0013H\u0016R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0014"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/model/ConversationField$TextArea;", "Lzendesk/messaging/android/internal/validation/model/ConversationField;", "id", "", "(Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "validate", "value", "rules", "Lzendesk/messaging/android/internal/validation/ValidationRules;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class TextArea extends ConversationField {
        private final String id;

        public static TextArea copy$default(TextArea textArea, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = textArea.id;
            }
            return textArea.copy(str);
        }

        public final String getId() {
            return this.id;
        }

        public final TextArea copy(String id) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new TextArea(id);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof TextArea) && Intrinsics.areEqual(this.id, ((TextArea) other).id);
        }

        public int hashCode() {
            return this.id.hashCode();
        }

        public String toString() {
            return "TextArea(id=" + this.id + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public TextArea(String id) {
            super(FieldType.MULTI_LINE, null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
        }

        @Override
        public String validate(Object value, ValidationRules rules) {
            Intrinsics.checkNotNullParameter(value, "value");
            Intrinsics.checkNotNullParameter(rules, "rules");
            return rules.forText$zendesk_messaging_messaging_android(new FieldData(getId(), value, null, null, getType().name(), 12, null));
        }
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010 \n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u000e\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\u0011\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0005HÆ\u0003J%\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\u0010\b\u0002\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001J\u001a\u0010\u0015\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0016\u001a\u00020\u00112\u0006\u0010\u0017\u001a\u00020\u0018H\u0016R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0019\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0019"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/model/ConversationField$MultiSelect;", "Lzendesk/messaging/android/internal/validation/model/ConversationField;", "id", "", "options", "", "(Ljava/lang/String;Ljava/util/List;)V", "getId", "()Ljava/lang/String;", "getOptions", "()Ljava/util/List;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "validate", "value", "rules", "Lzendesk/messaging/android/internal/validation/ValidationRules;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class MultiSelect extends ConversationField {
        private final String id;
        private final List<String> options;

        public static MultiSelect copy$default(MultiSelect multiSelect, String str, List list, int i, Object obj) {
            if ((i & 1) != 0) {
                str = multiSelect.id;
            }
            if ((i & 2) != 0) {
                list = multiSelect.options;
            }
            return multiSelect.copy(str, list);
        }

        public final String getId() {
            return this.id;
        }

        public final List<String> component2() {
            return this.options;
        }

        public final MultiSelect copy(String id, List<String> options) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new MultiSelect(id, options);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof MultiSelect)) {
                return false;
            }
            MultiSelect multiSelect = (MultiSelect) other;
            return Intrinsics.areEqual(this.id, multiSelect.id) && Intrinsics.areEqual(this.options, multiSelect.options);
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            List<String> list = this.options;
            return iHashCode + (list == null ? 0 : list.hashCode());
        }

        public String toString() {
            return "MultiSelect(id=" + this.id + ", options=" + this.options + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final List<String> getOptions() {
            return this.options;
        }

        public MultiSelect(String id, List<String> list) {
            super(FieldType.MULTI_SELECT, null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
            this.options = list;
        }

        @Override
        public String validate(Object value, ValidationRules rules) {
            Intrinsics.checkNotNullParameter(value, "value");
            Intrinsics.checkNotNullParameter(rules, "rules");
            return rules.forMultiSelect$zendesk_messaging_messaging_android(new FieldData(getId(), value, null, this.options, getType().name(), 4, null));
        }
    }
}
