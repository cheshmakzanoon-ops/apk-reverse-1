package zendesk.messaging.android.internal;

import android.content.Context;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;
import zendesk.messaging.android.Messaging;
import zendesk.messaging.android.MessagingError;

@Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\b\u0010\u0005\u001a\u00020\u0006H\u0016J\b\u0010\u0007\u001a\u00020\u0006H\u0016J\b\u0010\b\u001a\u00020\tH\u0016J\u001c\u0010\n\u001a\u00020\u00062\u0012\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\r0\fH\u0016J\u0016\u0010\u000e\u001a\u00020\u00062\f\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u00040\u0010H\u0016J\u0010\u0010\u0011\u001a\u00020\u00062\u0006\u0010\u0012\u001a\u00020\u0013H\u0016J\u0018\u0010\u0011\u001a\u00020\u00062\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\tH\u0016R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0015"}, m18d2 = {"Lzendesk/messaging/android/internal/StubMessaging;", "Lzendesk/messaging/android/Messaging;", "()V", "LOG_TAG", "", "clearConversationFields", "", "clearConversationTags", "getUnreadMessageCount", "", "setConversationFields", "fields", "", "", "setConversationTags", "tags", "", "showMessaging", "context", "Landroid/content/Context;", "intentFlags", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class StubMessaging implements Messaging {
    public static final StubMessaging INSTANCE = new StubMessaging();
    private static final String LOG_TAG = "Messaging";

    @Override
    public int getUnreadMessageCount() {
        return 0;
    }

    private StubMessaging() {
    }

    @Override
    public void showMessaging(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        Logger.m218e(LOG_TAG, MessagingError.NotInitialized.INSTANCE.getMessage(), MessagingError.NotInitialized.INSTANCE, new Object[0]);
    }

    @Override
    public void showMessaging(Context context, int intentFlags) {
        Intrinsics.checkNotNullParameter(context, "context");
        Logger.m218e(LOG_TAG, MessagingError.NotInitialized.INSTANCE.getMessage(), MessagingError.NotInitialized.INSTANCE, new Object[0]);
    }

    @Override
    public void setConversationFields(Map<String, ? extends Object> fields) {
        Intrinsics.checkNotNullParameter(fields, "fields");
        Logger.m218e(LOG_TAG, MessagingError.NotInitialized.INSTANCE.getMessage(), MessagingError.NotInitialized.INSTANCE, new Object[0]);
    }

    @Override
    public void setConversationTags(List<String> tags) {
        Intrinsics.checkNotNullParameter(tags, "tags");
        Logger.m218e(LOG_TAG, MessagingError.NotInitialized.INSTANCE.getMessage(), MessagingError.NotInitialized.INSTANCE, new Object[0]);
    }

    @Override
    public void clearConversationFields() {
        Logger.m218e(LOG_TAG, MessagingError.NotInitialized.INSTANCE.getMessage(), MessagingError.NotInitialized.INSTANCE, new Object[0]);
    }

    @Override
    public void clearConversationTags() {
        Logger.m218e(LOG_TAG, MessagingError.NotInitialized.INSTANCE.getMessage(), MessagingError.NotInitialized.INSTANCE, new Object[0]);
    }
}
