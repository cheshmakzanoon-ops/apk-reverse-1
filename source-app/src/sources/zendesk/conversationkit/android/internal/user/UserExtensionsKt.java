package zendesk.conversationkit.android.internal.user;

import java.util.Iterator;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import okhttp3.Credentials;
import zendesk.conversationkit.android.model.AuthenticationType;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.User;

@Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\u0005\"\u0015\u0010\u0000\u001a\u00020\u0001*\u00020\u00028F¢\u0006\u0006\u001a\u0004\b\u0003\u0010\u0004\"\u001a\u0010\u0005\u001a\u0004\u0018\u00010\u0001*\u00020\u00028@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0004¨\u0006\u0007"}, m18d2 = {"authorization", "", "Lzendesk/conversationkit/android/model/User;", "getAuthorization", "(Lzendesk/conversationkit/android/model/User;)Ljava/lang/String;", "defaultConversationId", "getDefaultConversationId", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserExtensionsKt {
    public static final String getAuthorization(User user) {
        Intrinsics.checkNotNullParameter(user, "<this>");
        AuthenticationType authenticationType = user.getAuthenticationType();
        if (authenticationType instanceof AuthenticationType.Jwt) {
            return "Bearer " + ((AuthenticationType.Jwt) authenticationType).getValue();
        }
        if (authenticationType instanceof AuthenticationType.SessionToken) {
            return Credentials.basic$default(user.getId(), ((AuthenticationType.SessionToken) authenticationType).getValue(), null, 4, null);
        }
        return "";
    }

    public static final String getDefaultConversationId(User user) {
        Object next;
        Intrinsics.checkNotNullParameter(user, "<this>");
        Iterator<T> it = user.getConversations().iterator();
        do {
            if (!it.hasNext()) {
                next = null;
                break;
            }
            next = it.next();
        } while (!((Conversation) next).isDefault());
        Conversation conversation = (Conversation) next;
        if (conversation != null) {
            return conversation.getId();
        }
        return null;
    }
}
