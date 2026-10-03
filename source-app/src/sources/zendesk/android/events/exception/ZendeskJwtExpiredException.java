package zendesk.android.events.exception;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(m17d1 = {"\u0000\u0010\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\u0018\u0000 \u00042\u00060\u0001j\u0002`\u0002:\u0001\u0004B\u0005¢\u0006\u0002\u0010\u0003¨\u0006\u0005"}, m18d2 = {"Lzendesk/android/events/exception/ZendeskJwtExpiredException;", "Ljava/lang/Exception;", "Lkotlin/Exception;", "()V", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ZendeskJwtExpiredException extends Exception {
    private static final Companion Companion = new Companion(null);
    private static final String JWT_EXPIRED_EXCEPTION_MESSAGE = "The JWT has expired";

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/android/events/exception/ZendeskJwtExpiredException$Companion;", "", "()V", "JWT_EXPIRED_EXCEPTION_MESSAGE", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }

    public ZendeskJwtExpiredException() {
        super(JWT_EXPIRED_EXCEPTION_MESSAGE);
    }
}
