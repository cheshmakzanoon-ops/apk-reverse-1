package zendesk.messaging.android.internal;

import kotlin.Metadata;
import zendesk.android.messaging.UrlSource;
import zendesk.core.p017ui.android.internal.model.MessageActionSize;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bà\u0080\u0001\u0018\u00002\u00020\u0001J \u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\tH&¨\u0006\n"}, m18d2 = {"Lzendesk/messaging/android/internal/WebViewUriHandler;", "", "onWebViewUriClicked", "", "uri", "", "size", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "urlSource", "Lzendesk/android/messaging/UrlSource;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface WebViewUriHandler {
    void onWebViewUriClicked(String uri, MessageActionSize size, UrlSource urlSource);
}
