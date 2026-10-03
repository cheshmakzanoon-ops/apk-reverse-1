package zendesk.messaging.android.internal.conversationscreen;

import j$.time.LocalDateTime;
import j$.time.format.DateTimeFormatter;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.android.internal.DateKtxKt;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u0001B\u0017\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0004¢\u0006\u0004\b\u0006\u0010\u0007J\u0015\u0010\u000b\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\b¢\u0006\u0004\b\u000b\u0010\fJ\u0015\u0010\r\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\b¢\u0006\u0004\b\r\u0010\fR\u0014\u0010\u0003\u001a\u00020\u00028\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0003\u0010\u000eR\u0014\u0010\u0005\u001a\u00020\u00048\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0005\u0010\u000fR\u001c\u0010\u0012\u001a\n \u0011*\u0004\u0018\u00010\u00100\u00108\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0012\u0010\u0013¨\u0006\u0014"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/MessageLogTimestampFormatter;", "", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "localeProvider", "", "is24HourFormat", "<init>", "(Lzendesk/core/ui/android/internal/local/LocaleProvider;Z)V", "j$/time/LocalDateTime", "timestamp", "", "timeOnly", "(Lj$/time/LocalDateTime;)Ljava/lang/String;", "dayAndTime", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "Z", "j$/time/format/DateTimeFormatter", "kotlin.jvm.PlatformType", "dayAndTimeFormat", "Lj$/time/format/DateTimeFormatter;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageLogTimestampFormatter {
    private final DateTimeFormatter dayAndTimeFormat;
    private final boolean is24HourFormat;
    private final LocaleProvider localeProvider;

    public MessageLogTimestampFormatter(LocaleProvider localeProvider, boolean z) {
        Intrinsics.checkNotNullParameter(localeProvider, "localeProvider");
        this.localeProvider = localeProvider;
        this.is24HourFormat = z;
        this.dayAndTimeFormat = DateTimeFormatter.ofPattern(z ? "MMMM d, H:mm" : "MMMM d, h:mm a", localeProvider.getLocale());
    }

    public final String timeOnly(LocalDateTime timestamp) {
        Intrinsics.checkNotNullParameter(timestamp, "timestamp");
        return DateKtxKt.timeOnly(timestamp, this.localeProvider.getLocale(), this.is24HourFormat);
    }

    public final String dayAndTime(LocalDateTime timestamp) {
        Intrinsics.checkNotNullParameter(timestamp, "timestamp");
        DateTimeFormatter dayAndTimeFormat = this.dayAndTimeFormat;
        Intrinsics.checkNotNullExpressionValue(dayAndTimeFormat, "dayAndTimeFormat");
        return DateKtxKt.formatToLocalisedNumbers(timestamp, dayAndTimeFormat, this.localeProvider.getLocale());
    }
}
