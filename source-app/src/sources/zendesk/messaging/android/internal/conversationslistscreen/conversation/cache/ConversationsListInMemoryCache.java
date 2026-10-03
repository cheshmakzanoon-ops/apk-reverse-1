package zendesk.messaging.android.internal.conversationslistscreen.conversation.cache;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.collections.MapsKt;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010%\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010$\n\u0002\b\u0004\n\u0002\u0010 \n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u0007\b\u0007¢\u0006\u0002\u0010\u0002J\u0006\u0010\u0007\u001a\u00020\bJ\u0012\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00060\nJ\u0010\u0010\u000b\u001a\u0004\u0018\u00010\u00062\u0006\u0010\f\u001a\u00020\u0005J\u0014\u0010\r\u001a\u00020\b2\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00060\u000fR\u001a\u0010\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00060\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListInMemoryCache;", "", "()V", "conversationsInMemoryCache", "", "", "Lzendesk/core/ui/android/internal/model/ConversationEntry;", "clearAll", "", "conversations", "", "getConversationById", "conversationId", "updateConversations", "conversationEntries", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListInMemoryCache {
    private final Map<String, ConversationEntry> conversationsInMemoryCache = new LinkedHashMap();

    @Inject
    public ConversationsListInMemoryCache() {
    }

    public final void updateConversations(List<? extends ConversationEntry> conversationEntries) {
        Intrinsics.checkNotNullParameter(conversationEntries, "conversationEntries");
        for (ConversationEntry conversationEntry : conversationEntries) {
            this.conversationsInMemoryCache.put(conversationEntry.getId(), conversationEntry);
        }
    }

    public final void clearAll() {
        this.conversationsInMemoryCache.clear();
    }

    public final Map<String, ConversationEntry> conversations() {
        return MapsKt.toMap(this.conversationsInMemoryCache);
    }

    public final ConversationEntry getConversationById(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        return this.conversationsInMemoryCache.get(conversationId);
    }
}
