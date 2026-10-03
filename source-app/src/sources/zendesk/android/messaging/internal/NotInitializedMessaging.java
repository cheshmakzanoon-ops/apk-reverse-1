package zendesk.android.messaging.internal;

import android.content.Context;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.Zendesk;
import zendesk.android.internal.ZendeskError;
import zendesk.android.messaging.Messaging;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\b\u0010\u0003\u001a\u00020\u0004H\u0016J\b\u0010\u0005\u001a\u00020\u0004H\u0016J\b\u0010\u0006\u001a\u00020\u0007H\u0016J\u001c\u0010\b\u001a\u00020\u00042\u0012\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u00020\f0\nH\u0016J\u0016\u0010\r\u001a\u00020\u00042\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u000b0\u000fH\u0016J\u0010\u0010\u0010\u001a\u00020\u00042\u0006\u0010\u0011\u001a\u00020\u0012H\u0016J\u0018\u0010\u0010\u001a\u00020\u00042\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0007H\u0016¨\u0006\u0014"}, m18d2 = {"Lzendesk/android/messaging/internal/NotInitializedMessaging;", "Lzendesk/android/messaging/Messaging;", "()V", "clearConversationFields", "", "clearConversationTags", "getUnreadMessageCount", "", "setConversationFields", "fields", "", "", "", "setConversationTags", "tags", "", "showMessaging", "context", "Landroid/content/Context;", "intentFlags", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class NotInitializedMessaging implements Messaging {
    public static final NotInitializedMessaging INSTANCE = new NotInitializedMessaging();

    private NotInitializedMessaging() {
    }

    @Override
    public void showMessaging(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        Logger.m218e(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), ZendeskError.NotInitialized.INSTANCE, new Object[0]);
    }

    @Override
    public void showMessaging(Context context, int intentFlags) {
        Intrinsics.checkNotNullParameter(context, "context");
        Logger.m218e(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), ZendeskError.NotInitialized.INSTANCE, new Object[0]);
    }

    @Override
    public int getUnreadMessageCount() {
        Logger.m218e(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), ZendeskError.NotInitialized.INSTANCE, new Object[0]);
        return 0;
    }

    @Override
    public void setConversationFields(Map<String, ? extends Object> fields) {
        Intrinsics.checkNotNullParameter(fields, "fields");
        Logger.m218e(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), ZendeskError.NotInitialized.INSTANCE, new Object[0]);
    }

    @Override
    public void setConversationTags(List<String> tags) {
        Intrinsics.checkNotNullParameter(tags, "tags");
        Logger.m218e(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), ZendeskError.NotInitialized.INSTANCE, new Object[0]);
    }

    @Override
    public void clearConversationFields() {
        Logger.m218e(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), ZendeskError.NotInitialized.INSTANCE, new Object[0]);
    }

    @Override
    public void clearConversationTags() {
        Logger.m218e(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), ZendeskError.NotInitialized.INSTANCE, new Object[0]);
    }
}
