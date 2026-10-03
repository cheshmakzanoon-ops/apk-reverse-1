package zendesk.android.messaging;

import android.content.Context;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;

@Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\bf\u0018\u0000 \u00122\u00020\u0001:\u0001\u0012J\b\u0010\u0002\u001a\u00020\u0003H&J\b\u0010\u0004\u001a\u00020\u0003H&J\b\u0010\u0005\u001a\u00020\u0006H&J\u001c\u0010\u0007\u001a\u00020\u00032\u0012\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\u00010\tH&J\u0016\u0010\u000b\u001a\u00020\u00032\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\n0\rH&J\u0010\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u000f\u001a\u00020\u0010H&J\u0018\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u0006H&¨\u0006\u0013"}, m18d2 = {"Lzendesk/android/messaging/Messaging;", "", "clearConversationFields", "", "clearConversationTags", "getUnreadMessageCount", "", "setConversationFields", "fields", "", "", "setConversationTags", "tags", "", "showMessaging", "context", "Landroid/content/Context;", "intentFlags", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface Messaging {

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    public final class CC {
        static {
            Companion companion = Messaging.INSTANCE;
        }

        @JvmStatic
        public static void setDelegate(MessagingDelegate messagingDelegate) {
            Messaging.INSTANCE.setDelegate(messagingDelegate);
        }
    }

    void clearConversationFields();

    void clearConversationTags();

    int getUnreadMessageCount();

    void setConversationFields(Map<String, ? extends Object> fields);

    void setConversationTags(List<String> tags);

    void showMessaging(Context context);

    void showMessaging(Context context, int intentFlags);

    @Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0006\u0010\u0006\u001a\u00020\u0004J\u0012\u0010\u0007\u001a\u00020\b2\b\u0010\u0005\u001a\u0004\u0018\u00010\u0004H\u0007R\u001e\u0010\u0005\u001a\u0004\u0018\u00010\u00042\b\u0010\u0003\u001a\u0004\u0018\u00010\u00048B@BX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\t"}, m18d2 = {"Lzendesk/android/messaging/Messaging$Companion;", "", "()V", "<set-?>", "Lzendesk/android/messaging/MessagingDelegate;", "messagingDelegate", "getDelegate", "setDelegate", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        static final Companion $$INSTANCE = new Companion();
        private static MessagingDelegate messagingDelegate;

        private Companion() {
        }

        @JvmStatic
        public final void setDelegate(MessagingDelegate messagingDelegate2) {
            messagingDelegate = messagingDelegate2;
        }

        public final MessagingDelegate getDelegate() {
            MessagingDelegate messagingDelegate2 = messagingDelegate;
            return messagingDelegate2 == null ? new MessagingDelegate() : messagingDelegate2;
        }
    }
}
