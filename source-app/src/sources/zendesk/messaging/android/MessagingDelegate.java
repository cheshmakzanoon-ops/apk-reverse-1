package zendesk.messaging.android;

import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Deprecated(message = "Please use Zendesk SDK")
@Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0017\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0018\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0016¨\u0006\t"}, m18d2 = {"Lzendesk/messaging/android/MessagingDelegate;", "Lzendesk/android/messaging/MessagingDelegate;", "()V", "shouldHandleUrl", "", "url", "", "urlSource", "Lzendesk/messaging/android/UrlSource;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public class MessagingDelegate extends zendesk.android.messaging.MessagingDelegate {
    public boolean shouldHandleUrl(String url, UrlSource urlSource) {
        Intrinsics.checkNotNullParameter(url, "url");
        Intrinsics.checkNotNullParameter(urlSource, "urlSource");
        return true;
    }
}
