package zendesk.conversationkit.android.internal.metadata;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.StringCompanionObject;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010%\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010$\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\b\u0002\b\u0000\u0018\u0000 \u000b2\u00020\u0001:\u0001\u000bB\u0005¢\u0006\u0002\u0010\u0002J&\u0010\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00010\u00042\u0012\u0010\u0006\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00010\u0007J \u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00050\u00042\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u00050\n¨\u0006\f"}, m18d2 = {"Lzendesk/conversationkit/android/internal/metadata/MetadataFormatter;", "", "()V", "formatConversationFields", "", "", "fields", "", "formatConversationTags", "tags", "", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MetadataFormatter {

    @Deprecated
    public static final String CUSTOM_FIELD_ZRN_FORMAT = "zen:ticket_field:%s";
    private static final Companion Companion = new Companion(null);

    @Deprecated
    public static final String TAGS_ZRN_FORMAT = "zen:ticket:tags";

    public final Map<String, Object> formatConversationFields(Map<String, ? extends Object> fields) {
        Intrinsics.checkNotNullParameter(fields, "fields");
        LinkedHashMap linkedHashMap = new LinkedHashMap();
        for (Map.Entry<String, ? extends Object> entry : fields.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();
            StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
            String str = String.format(CUSTOM_FIELD_ZRN_FORMAT, Arrays.copyOf(new Object[]{key}, 1));
            Intrinsics.checkNotNullExpressionValue(str, "format(...)");
            linkedHashMap.put(str, value);
        }
        return linkedHashMap;
    }

    public final Map<String, String> formatConversationTags(List<String> tags) {
        Intrinsics.checkNotNullParameter(tags, "tags");
        LinkedHashMap linkedHashMap = new LinkedHashMap();
        if (tags.isEmpty()) {
            return linkedHashMap;
        }
        linkedHashMap.put(TAGS_ZRN_FORMAT, CollectionsKt.joinToString$default(tags, ",", null, null, 0, null, null, 62, null));
        return linkedHashMap;
    }

    @Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/metadata/MetadataFormatter$Companion;", "", "()V", "CUSTOM_FIELD_ZRN_FORMAT", "", "TAGS_ZRN_FORMAT", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
