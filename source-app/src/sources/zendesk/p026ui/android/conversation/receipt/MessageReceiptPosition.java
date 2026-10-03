package zendesk.p026ui.android.conversation.receipt;

import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;

@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\b\b\u0086\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005j\u0002\b\u0006j\u0002\b\u0007j\u0002\b\b¨\u0006\t"}, m18d2 = {"Lzendesk/ui/android/conversation/receipt/MessageReceiptPosition;", "", "(Ljava/lang/String;I)V", "INBOUND", "INBOUND_FAILED", "OUTBOUND_SENDING", "OUTBOUND_SENT", "OUTBOUND_FAILED", "NONE", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public enum MessageReceiptPosition {
    INBOUND,
    INBOUND_FAILED,
    OUTBOUND_SENDING,
    OUTBOUND_SENT,
    OUTBOUND_FAILED,
    NONE;

    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static EnumEntries<MessageReceiptPosition> getEntries() {
        return $ENTRIES;
    }
}
