package zendesk.messaging.android.internal;

import j$.time.LocalDateTime;
import j$.time.chrono.ChronoLocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.NoSuchElementException;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.Participant;

@Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0010%\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B\t\b\u0007¢\u0006\u0004\b\u0002\u0010\u0003J\u0017\u0010\u0007\u001a\u0004\u0018\u00010\u00062\u0006\u0010\u0005\u001a\u00020\u0004¢\u0006\u0004\b\u0007\u0010\bJ\u0015\u0010\f\u001a\u00020\u000b2\u0006\u0010\n\u001a\u00020\t¢\u0006\u0004\b\f\u0010\rJ\u0015\u0010\u000e\u001a\u00020\u000b2\u0006\u0010\u0005\u001a\u00020\u0004¢\u0006\u0004\b\u000e\u0010\u000fR \u0010\u0011\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00060\u00108\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0011\u0010\u0012¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/internal/NewMessagesDividerHandler;", "", "<init>", "()V", "", "conversationId", "j$/time/LocalDateTime", "getNewMessageDividerDate", "(Ljava/lang/String;)Lj$/time/LocalDateTime;", "Lzendesk/conversationkit/android/model/Conversation;", "conversation", "", "updateNewMessageDividerDate", "(Lzendesk/conversationkit/android/model/Conversation;)V", "clearNewMessageDividerDate", "(Ljava/lang/String;)V", "", "newMessageDivider", "Ljava/util/Map;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class NewMessagesDividerHandler {
    private final Map<String, LocalDateTime> newMessageDivider = new LinkedHashMap();

    @Inject
    public NewMessagesDividerHandler() {
    }

    public final LocalDateTime getNewMessageDividerDate(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        return this.newMessageDivider.get(conversationId);
    }

    public final void updateNewMessageDividerDate(Conversation conversation) {
        Intrinsics.checkNotNullParameter(conversation, "conversation");
        Participant myself = conversation.getMyself();
        LocalDateTime lastRead = myself != null ? myself.getLastRead() : null;
        if (!NewMessagesDividerHandlerKt.hasNewInboundMessages(conversation) || lastRead == null) {
            return;
        }
        Map<String, LocalDateTime> map = this.newMessageDivider;
        String id = conversation.getId();
        for (Message message : conversation.getMessages()) {
            if (!message.isAuthoredBy(conversation.getMyself()) && message.getReceived().compareTo((ChronoLocalDateTime) lastRead) > 0) {
                map.put(id, message.getReceived());
                return;
            }
        }
        throw new NoSuchElementException("Collection contains no element matching the predicate.");
    }

    public final void clearNewMessageDividerDate(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        this.newMessageDivider.remove(conversationId);
    }
}
