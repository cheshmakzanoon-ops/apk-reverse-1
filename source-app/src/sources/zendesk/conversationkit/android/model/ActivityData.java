package zendesk.conversationkit.android.model;

import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;

@Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0000\n\u0002\u0010\u000e\n\u0002\b\n\b\u0086\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006j\u0002\b\u0007j\u0002\b\bj\u0002\b\tj\u0002\b\nj\u0002\b\u000bj\u0002\b\f¨\u0006\r"}, m18d2 = {"Lzendesk/conversationkit/android/model/ActivityData;", "", "type", "", "(Ljava/lang/String;ILjava/lang/String;)V", "getType", "()Ljava/lang/String;", "TYPING_START", "TYPING_STOP", "CONVERSATION_READ", "CONVERSATION_ROUTING_QUEUED", "CONVERSATION_ROUTING_ASSIGNED", "CONVERSATION_ROUTING_CLEARED", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public enum ActivityData {
    TYPING_START("typing:start"),
    TYPING_STOP("typing:stop"),
    CONVERSATION_READ("conversation:read"),
    CONVERSATION_ROUTING_QUEUED("conversation:routing:queued"),
    CONVERSATION_ROUTING_ASSIGNED("conversation:routing:assigned"),
    CONVERSATION_ROUTING_CLEARED("conversation:routing:cleared");

    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());
    private final String type;

    public static EnumEntries<ActivityData> getEntries() {
        return $ENTRIES;
    }

    ActivityData(String str) {
        this.type = str;
    }

    public final String getType() {
        return this.type;
    }
}
