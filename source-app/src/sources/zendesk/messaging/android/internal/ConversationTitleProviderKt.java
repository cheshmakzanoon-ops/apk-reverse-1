package zendesk.messaging.android.internal;

import j$.time.LocalDateTime;
import java.util.Locale;
import kotlin.Metadata;
import zendesk.core.android.internal.DateKtxKt;

@Metadata(m17d1 = {"\u0000\u0016\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\u001a#\u0010\u0006\u001a\u00020\u0005*\u00020\u00002\u0006\u0010\u0002\u001a\u00020\u00012\u0006\u0010\u0004\u001a\u00020\u0003H\u0002¢\u0006\u0004\b\u0006\u0010\u0007¨\u0006\b"}, m18d2 = {"j$/time/LocalDateTime", "Ljava/util/Locale;", "locale", "", "isFullMonthFormat", "", "resolveDate", "(Lj$/time/LocalDateTime;Ljava/util/Locale;Z)Ljava/lang/String;", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationTitleProviderKt {
    public static final String resolveDate(LocalDateTime localDateTime, Locale locale, boolean z) {
        if (localDateTime.getYear() == LocalDateTime.now().getYear()) {
            return z ? DateKtxKt.fullMonthAndDay(localDateTime, locale) : DateKtxKt.dayAndMonth(localDateTime, locale);
        }
        return z ? DateKtxKt.fullMonthDayAndYear(localDateTime, locale) : DateKtxKt.monthDayAndYear(localDateTime, locale);
    }
}
