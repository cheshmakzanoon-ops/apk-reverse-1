package zendesk.guidekit.android.exception;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\t\n\u0002\b\u0002\u0018\u00002\u00060\u0001j\u0002`\u0002B\u0015\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007¨\u0006\b"}, m18d2 = {"Lzendesk/guidekit/android/exception/RestrictedArticleException;", "Ljava/lang/Exception;", "Lkotlin/Exception;", "locale", "", "articleId", "", "(Ljava/lang/String;J)V", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class RestrictedArticleException extends Exception {
    public RestrictedArticleException(String locale, long j) {
        super("Article with ID: " + j + " and locale " + locale + " is restricted to authorised users");
        Intrinsics.checkNotNullParameter(locale, "locale");
    }
}
