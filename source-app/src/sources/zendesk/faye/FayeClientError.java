package zendesk.faye;

import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;

@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0004\b\u0086\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004¨\u0006\u0005"}, m18d2 = {"Lzendesk/faye/FayeClientError;", "", "(Ljava/lang/String;I)V", "CLIENT_TRANSPORT_ERROR", "CLIENT_NOT_CONNECTED_ERROR", "zendesk.faye_faye"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public enum FayeClientError {
    CLIENT_TRANSPORT_ERROR,
    CLIENT_NOT_CONNECTED_ERROR;

    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static EnumEntries<FayeClientError> getEntries() {
        return $ENTRIES;
    }
}
