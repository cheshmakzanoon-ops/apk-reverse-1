package zendesk.guidekit.android.exception;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\u0018\u00002\u00060\u0001j\u0002`\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005¨\u0006\u0006"}, m18d2 = {"Lzendesk/guidekit/android/exception/InvalidGuideArticleUrl;", "Ljava/lang/Exception;", "Lkotlin/Exception;", "url", "", "(Ljava/lang/String;)V", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class InvalidGuideArticleUrl extends Exception {
    public InvalidGuideArticleUrl(String url) {
        super("Url: " + url + " is an invalid article url");
        Intrinsics.checkNotNullParameter(url, "url");
    }
}
