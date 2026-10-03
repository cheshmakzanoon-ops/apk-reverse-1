package zendesk.messaging.android.internal.conversationslistscreen;

import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;

@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0006\b\u0080\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005j\u0002\b\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/CreateConversationState;", "", "(Ljava/lang/String;I)V", "SUCCESS", "FAILED", "LOADING", "IDLE", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public enum CreateConversationState {
    SUCCESS,
    FAILED,
    LOADING,
    IDLE;

    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static EnumEntries<CreateConversationState> getEntries() {
        return $ENTRIES;
    }
}
