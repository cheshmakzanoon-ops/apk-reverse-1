package zendesk.messaging.android.push;

import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;

@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0005\b\u0086\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/push/PushResponsibility;", "", "(Ljava/lang/String;I)V", "MESSAGING_SHOULD_DISPLAY", "MESSAGING_SHOULD_NOT_DISPLAY", "NOT_FROM_MESSAGING", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public enum PushResponsibility {
    MESSAGING_SHOULD_DISPLAY,
    MESSAGING_SHOULD_NOT_DISPLAY,
    NOT_FROM_MESSAGING;

    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static EnumEntries<PushResponsibility> getEntries() {
        return $ENTRIES;
    }
}
