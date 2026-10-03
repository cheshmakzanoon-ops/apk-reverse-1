package zendesk.messaging.android.internal;

import j$.time.LocalDateTime;
import j$.time.chrono.ChronoLocalDateTime;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.Participant;

@Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0000¨\u0006\u0003"}, m18d2 = {"hasNewInboundMessages", "", "Lzendesk/conversationkit/android/model/Conversation;", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class NewMessagesDividerHandlerKt {
    public static final boolean hasNewInboundMessages(Conversation conversation) {
        Object next;
        Intrinsics.checkNotNullParameter(conversation, "<this>");
        if (conversation.getMessages().isEmpty()) {
            return false;
        }
        List<Message> messages = conversation.getMessages();
        ArrayList arrayList = new ArrayList();
        for (Object obj : messages) {
            if (!((Message) obj).isAuthoredBy(conversation.getMyself())) {
                arrayList.add(obj);
            }
        }
        Iterator it = arrayList.iterator();
        if (it.hasNext()) {
            next = it.next();
            if (it.hasNext()) {
                Comparable received = ((Message) next).getReceived();
                do {
                    Object next2 = it.next();
                    Comparable comparable = (Comparable) ((Message) next2).getReceived();
                    if (received.compareTo(comparable) < 0) {
                        next = next2;
                        received = comparable;
                    }
                } while (it.hasNext());
            }
        } else {
            next = null;
        }
        Message message = (Message) next;
        LocalDateTime received2 = message != null ? message.getReceived() : null;
        Participant myself = conversation.getMyself();
        LocalDateTime lastRead = myself != null ? myself.getLastRead() : null;
        return (lastRead == null || received2 == null || lastRead.compareTo((ChronoLocalDateTime) received2) >= 0) ? false : true;
    }
}
