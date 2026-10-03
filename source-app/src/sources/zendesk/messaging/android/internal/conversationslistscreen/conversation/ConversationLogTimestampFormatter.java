package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import android.content.Context;
import j$.time.LocalDateTime;
import j$.time.temporal.ChronoUnit;
import j$.time.temporal.Temporal;
import javax.inject.Inject;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.android.internal.DateKtxKt;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.conversationscreen.TimeConstants;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0007\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0007\b\u0000\u0018\u00002\u00020\u0001B#\b\u0007\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\b\b\u0001\u0010\u0007\u001a\u00020\u0006¢\u0006\u0004\b\b\u0010\tJ\u001f\u0010\f\u001a\u00020\u00062\u0006\u0010\n\u001a\u00020\u00062\u0006\u0010\u000b\u001a\u00020\u0006H\u0002¢\u0006\u0004\b\f\u0010\rJ\u001f\u0010\u0014\u001a\u00020\u00112\u0006\u0010\u000f\u001a\u00020\u000e2\u0006\u0010\u0010\u001a\u00020\u000eH\u0000¢\u0006\u0004\b\u0012\u0010\u0013R\u0014\u0010\u0003\u001a\u00020\u00028\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0003\u0010\u0015R\u0014\u0010\u0005\u001a\u00020\u00048\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0005\u0010\u0016R\u0014\u0010\u0007\u001a\u00020\u00068\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0007\u0010\u0017¨\u0006\u0018"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationLogTimestampFormatter;", "", "Landroid/content/Context;", "context", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "localeProvider", "", "is24HourFormat", "<init>", "(Landroid/content/Context;Lzendesk/core/ui/android/internal/local/LocaleProvider;Z)V", "firstPrecondition", "secondPrecondition", "compareLinkedPreconditions", "(ZZ)Z", "j$/time/LocalDateTime", "localDateTimeFromMessage", "currentDateTime", "", "formatWhenConversationWasUpdatedAt$zendesk_messaging_messaging_android", "(Lj$/time/LocalDateTime;Lj$/time/LocalDateTime;)Ljava/lang/String;", "formatWhenConversationWasUpdatedAt", "Landroid/content/Context;", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "Z", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationLogTimestampFormatter {
    private final Context context;
    private final boolean is24HourFormat;
    private final LocaleProvider localeProvider;

    private final boolean compareLinkedPreconditions(boolean firstPrecondition, boolean secondPrecondition) {
        return firstPrecondition && secondPrecondition;
    }

    @Inject
    public ConversationLogTimestampFormatter(Context context, LocaleProvider localeProvider, @Named(ConversationLogTimestampFormatterKt.FORMAT_24H) boolean z) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(localeProvider, "localeProvider");
        this.context = context;
        this.localeProvider = localeProvider;
        this.is24HourFormat = z;
    }

    public final String m280xff406d0b(LocalDateTime localDateTimeFromMessage, LocalDateTime currentDateTime) {
        Intrinsics.checkNotNullParameter(localDateTimeFromMessage, "localDateTimeFromMessage");
        Intrinsics.checkNotNullParameter(currentDateTime, "currentDateTime");
        if (currentDateTime.getYear() - localDateTimeFromMessage.getYear() >= 1) {
            return DateKtxKt.monthDayAndYear(localDateTimeFromMessage, this.localeProvider.getLocale());
        }
        boolean z = ChronoUnit.DAYS.between((Temporal) localDateTimeFromMessage, (Temporal) currentDateTime) >= 1;
        boolean z2 = currentDateTime.getDayOfMonth() != localDateTimeFromMessage.getDayOfMonth();
        boolean z3 = currentDateTime.getMonthValue() == localDateTimeFromMessage.getMonthValue();
        boolean z4 = currentDateTime.getMonthValue() > localDateTimeFromMessage.getMonthValue();
        boolean z5 = currentDateTime.getDayOfMonth() > localDateTimeFromMessage.getDayOfMonth();
        if (z || compareLinkedPreconditions(z4, z2) || compareLinkedPreconditions(z3, z5)) {
            return DateKtxKt.dayAndMonth(localDateTimeFromMessage, this.localeProvider.getLocale());
        }
        if (DateKtxKt.toTimestamp$default(currentDateTime, null, 1, null) - DateKtxKt.toTimestamp$default(localDateTimeFromMessage, null, 1, null) >= TimeConstants.ONE_MINUTE_DIFFERENCE) {
            return DateKtxKt.timeOnly(localDateTimeFromMessage, this.localeProvider.getLocale(), this.is24HourFormat);
        }
        String string = this.context.getString(C1256R.string.zma_conversation_list_item_timestamp_just_now);
        Intrinsics.checkNotNull(string);
        return string;
    }
}
