package zendesk.messaging.android.internal;

import android.content.Context;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.Zendesk;
import zendesk.messaging.android.Messaging;

@Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\b\u0010\u0005\u001a\u00020\u0006H\u0016J\b\u0010\u0007\u001a\u00020\u0006H\u0016J\b\u0010\b\u001a\u00020\tH\u0016J\u001c\u0010\n\u001a\u00020\u00062\u0012\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u000e0\fH\u0016J\u0016\u0010\u000f\u001a\u00020\u00062\f\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\r0\u0011H\u0016J\u0010\u0010\u0012\u001a\u00020\u00062\u0006\u0010\u0013\u001a\u00020\u0014H\u0016J\u0018\u0010\u0012\u001a\u00020\u00062\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\tH\u0016R\u0010\u0010\u0002\u001a\u00020\u00038\u0000X\u0081\u0004¢\u0006\u0002\n\u0000¨\u0006\u0016"}, m18d2 = {"Lzendesk/messaging/android/internal/WrapperMessaging;", "Lzendesk/messaging/android/Messaging;", "zendesk", "Lzendesk/android/Zendesk;", "(Lzendesk/android/Zendesk;)V", "clearConversationFields", "", "clearConversationTags", "getUnreadMessageCount", "", "setConversationFields", "fields", "", "", "", "setConversationTags", "tags", "", "showMessaging", "context", "Landroid/content/Context;", "intentFlags", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class WrapperMessaging implements Messaging {
    public final Zendesk zendesk;

    public WrapperMessaging(Zendesk zendesk2) {
        Intrinsics.checkNotNullParameter(zendesk2, "zendesk");
        this.zendesk = zendesk2;
    }

    @Override
    public void showMessaging(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        this.zendesk.getMessaging().showMessaging(context);
    }

    @Override
    public void showMessaging(Context context, int intentFlags) {
        Intrinsics.checkNotNullParameter(context, "context");
        this.zendesk.getMessaging().showMessaging(context, intentFlags);
    }

    @Override
    public int getUnreadMessageCount() {
        return this.zendesk.getMessaging().getUnreadMessageCount();
    }

    @Override
    public void setConversationFields(Map<String, ? extends Object> fields) {
        Intrinsics.checkNotNullParameter(fields, "fields");
        this.zendesk.getMessaging().setConversationFields(fields);
    }

    @Override
    public void setConversationTags(List<String> tags) {
        Intrinsics.checkNotNullParameter(tags, "tags");
        this.zendesk.getMessaging().setConversationTags(tags);
    }

    @Override
    public void clearConversationFields() {
        this.zendesk.getMessaging().clearConversationFields();
    }

    @Override
    public void clearConversationTags() {
        this.zendesk.getMessaging().clearConversationTags();
    }
}
