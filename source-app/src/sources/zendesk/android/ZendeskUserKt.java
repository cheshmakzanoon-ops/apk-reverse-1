package zendesk.android;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.User;

@Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0000¨\u0006\u0003"}, m18d2 = {"toZendeskUser", "Lzendesk/android/ZendeskUser;", "Lzendesk/conversationkit/android/model/User;", "zendesk_zendesk-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ZendeskUserKt {
    public static final ZendeskUser toZendeskUser(User user) {
        Intrinsics.checkNotNullParameter(user, "<this>");
        return new ZendeskUser(user.getId(), user.getExternalId());
    }
}
