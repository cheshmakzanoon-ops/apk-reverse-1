package zendesk.messaging.android.internal.conversationscreen;

import java.util.List;
import java.util.ListIterator;
import kotlin.Metadata;
import zendesk.conversationkit.android.model.Author;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.Message;

@Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\u0014\u0010\u0000\u001a\u0004\u0018\u00010\u00012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0003H\u0000¨\u0006\u0004"}, m18d2 = {"mostRecentAuthorThatIsNotMySelf", "Lzendesk/conversationkit/android/model/Author;", "conversation", "Lzendesk/conversationkit/android/model/Conversation;", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationHelperKt {
    public static final Author mostRecentAuthorThatIsNotMySelf(Conversation conversation) {
        List<Message> messages;
        Message messagePrevious;
        Author author;
        if (conversation != null && (messages = conversation.getMessages()) != null) {
            ListIterator<Message> listIterator = messages.listIterator(messages.size());
            do {
                if (!listIterator.hasPrevious()) {
                    messagePrevious = null;
                    break;
                }
                messagePrevious = listIterator.previous();
            } while (messagePrevious.isAuthoredBy(conversation.getMyself()));
            Message message = messagePrevious;
            if (message != null && (author = message.getAuthor()) != null) {
                return author;
            }
        }
        return null;
    }
}
