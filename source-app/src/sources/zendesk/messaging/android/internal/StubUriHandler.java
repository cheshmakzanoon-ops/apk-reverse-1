package zendesk.messaging.android.internal;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.messaging.UrlSource;

@Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J \u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0016¨\u0006\u000b"}, m18d2 = {"Lzendesk/messaging/android/internal/StubUriHandler;", "Lzendesk/messaging/android/internal/UriHandler;", "()V", "onUriClicked", "", "uri", "", "urlSource", "Lzendesk/android/messaging/UrlSource;", "isPrivateAttachment", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class StubUriHandler implements UriHandler {
    public static final StubUriHandler INSTANCE = new StubUriHandler();

    @Override
    public void onUriClicked(String uri, UrlSource urlSource, boolean isPrivateAttachment) {
        Intrinsics.checkNotNullParameter(uri, "uri");
        Intrinsics.checkNotNullParameter(urlSource, "urlSource");
    }

    private StubUriHandler() {
    }
}
