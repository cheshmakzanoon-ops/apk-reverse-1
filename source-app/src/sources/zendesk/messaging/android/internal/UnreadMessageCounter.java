package zendesk.messaging.android.internal;

import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010%\n\u0002\u0010\u000e\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u0004\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0006\u0010\u0007\u001a\u00020\u0006J\u000e\u0010\b\u001a\u00020\u00062\u0006\u0010\t\u001a\u00020\u0005J\u000e\u0010\n\u001a\u00020\u00062\u0006\u0010\t\u001a\u00020\u0005J\u0006\u0010\u000b\u001a\u00020\fJ\u000e\u0010\r\u001a\u00020\f2\u0006\u0010\t\u001a\u00020\u0005J\u0016\u0010\u000e\u001a\u00020\u00062\u0006\u0010\t\u001a\u00020\u00052\u0006\u0010\u000f\u001a\u00020\u0006R\u001a\u0010\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00060\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/UnreadMessageCounter;", "", "()V", "unreadMessageCounters", "", "", "", "getTotalUnreadMessageCount", "getUnreadMessageCount", "conversationId", "increase", "reset", "", "resetConversationUnread", "update", "unreadCount", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class UnreadMessageCounter {
    public static final UnreadMessageCounter INSTANCE = new UnreadMessageCounter();
    private static final Map<String, Integer> unreadMessageCounters = new LinkedHashMap();

    private UnreadMessageCounter() {
    }

    public final void resetConversationUnread(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        unreadMessageCounters.put(conversationId, 0);
    }

    public final void reset() {
        unreadMessageCounters.clear();
    }

    public final int getUnreadMessageCount(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        Integer num = unreadMessageCounters.get(conversationId);
        if (num == null) {
            num = 0;
        }
        return num.intValue();
    }

    public final int update(String conversationId, int unreadCount) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        unreadMessageCounters.put(conversationId, Integer.valueOf(unreadCount));
        return unreadCount;
    }

    public final int increase(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        return update(conversationId, getUnreadMessageCount(conversationId) + 1);
    }

    public final int getTotalUnreadMessageCount() {
        Collection<Integer> collectionValues = unreadMessageCounters.values();
        if (collectionValues.isEmpty()) {
            return 0;
        }
        Iterator<T> it = collectionValues.iterator();
        if (!it.hasNext()) {
            throw new UnsupportedOperationException("Empty collection can't be reduced.");
        }
        Object next = it.next();
        while (it.hasNext()) {
            next = Integer.valueOf(((Number) next).intValue() + ((Number) it.next()).intValue());
        }
        return ((Number) next).intValue();
    }
}
