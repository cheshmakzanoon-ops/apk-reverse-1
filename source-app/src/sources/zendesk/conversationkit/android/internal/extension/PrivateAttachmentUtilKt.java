package zendesk.conversationkit.android.internal.extension;

import kotlin.Metadata;
import zendesk.core.android.internal.InternalZendeskApi;

@Metadata(m17d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\u001a\u001c\u0010\u0000\u001a\u0004\u0018\u00010\u00012\b\u0010\u0002\u001a\u0004\u0018\u00010\u00012\u0006\u0010\u0003\u001a\u00020\u0004H\u0007¨\u0006\u0005"}, m18d2 = {"resolveAuthTokenForPrivateAttachment", "", "authorizationToken", "isPrivateAttachment", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class PrivateAttachmentUtilKt {
    @InternalZendeskApi
    public static final String resolveAuthTokenForPrivateAttachment(String str, boolean z) {
        if (z) {
            return str;
        }
        return null;
    }
}
