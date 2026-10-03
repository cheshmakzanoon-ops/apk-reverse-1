package zendesk.p026ui.android.conversation.waittimebanner;

import kotlin.Metadata;
import kotlin.Pair;
import kotlin.TuplesKt;

@Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0006\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\t\n\u0002\b\u0002\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0018\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\b2\u0006\u0010\u000f\u001a\u00020\bH\u0002J\u0018\u0010\u0010\u001a\u00020\r2\u0006\u0010\u0011\u001a\u00020\b2\u0006\u0010\u0012\u001a\u00020\bH\u0002J\u0018\u0010\u0013\u001a\u00020\r2\u0006\u0010\u0014\u001a\u00020\b2\u0006\u0010\u0015\u001a\u00020\bH\u0002J\u0018\u0010\u0016\u001a\u00020\r2\u0006\u0010\u0014\u001a\u00020\b2\u0006\u0010\u0015\u001a\u00020\bH\u0002J\u0016\u0010\u0017\u001a\u00020\r2\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u0019R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\bX\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\bX\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\bX\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\bX\u0082T¢\u0006\u0002\n\u0000¨\u0006\u001b"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/WaitTimeQueuedBannerUtil;", "", "()V", "DAY_IN_HOURS", "", "HOUR_IN_MINUTES", "MINUTE_IN_SECONDS", "ONE_UNIT", "", "SECONDS_IN_AN_HOUR", "SECONDS_IN_A_DAY", "SECONDS_IN_A_MINUTE", "getDaysText", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "upperDays", "lowerDays", "getHoursText", "upperHours", "lowerHours", "getMinutesText", "upperMinutes", "lowerMinutes", "getSecondsText", "getType", "lower", "", "upper", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class WaitTimeQueuedBannerUtil {
    public static final int $stable = 0;
    private static final double DAY_IN_HOURS = 24.0d;
    private static final double HOUR_IN_MINUTES = 60.0d;
    public static final WaitTimeQueuedBannerUtil INSTANCE = new WaitTimeQueuedBannerUtil();
    private static final double MINUTE_IN_SECONDS = 60.0d;
    private static final int ONE_UNIT = 1;
    private static final int SECONDS_IN_AN_HOUR = 3600;
    private static final int SECONDS_IN_A_DAY = 86400;
    private static final int SECONDS_IN_A_MINUTE = 60;

    private WaitTimeQueuedBannerUtil() {
    }

    public final QueuedBannerStatusType getType(long lower, long upper) {
        Pair pairM25to;
        if (lower > upper) {
            pairM25to = TuplesKt.m25to(Long.valueOf(lower), Long.valueOf(upper));
        } else {
            pairM25to = TuplesKt.m25to(Long.valueOf(upper), Long.valueOf(lower));
        }
        long jLongValue = ((Number) pairM25to.component1()).longValue();
        long jLongValue2 = ((Number) pairM25to.component2()).longValue();
        int iCeil = (int) Math.ceil(jLongValue / 60.0d);
        int iFloor = (int) Math.floor(jLongValue2 / 60.0d);
        int iCeil2 = (int) Math.ceil(((double) iCeil) / 60.0d);
        int iFloor2 = (int) Math.floor(((double) iFloor) / 60.0d);
        int iCeil3 = (int) Math.ceil(((double) iCeil2) / DAY_IN_HOURS);
        int iFloor3 = (int) Math.floor(((double) iFloor2) / DAY_IN_HOURS);
        if (jLongValue > 86400) {
            return getDaysText(iCeil3, iFloor3);
        }
        if (jLongValue > 3600) {
            return getHoursText(iCeil2, iFloor2);
        }
        if (jLongValue <= 60) {
            return getSecondsText(iCeil, iFloor);
        }
        return getMinutesText(iCeil, iFloor);
    }

    private final QueuedBannerStatusType getDaysText(int upperDays, int lowerDays) {
        if (lowerDays < 1) {
            return new QueuedBannerStatusType.WithinDays(upperDays);
        }
        if (upperDays == lowerDays) {
            return new QueuedBannerStatusType.AboutDays(upperDays);
        }
        return new QueuedBannerStatusType.DailyRange(lowerDays, upperDays);
    }

    private final QueuedBannerStatusType getHoursText(int upperHours, int lowerHours) {
        if (lowerHours < 1) {
            return new QueuedBannerStatusType.WithinHours(upperHours);
        }
        if (upperHours == lowerHours) {
            return new QueuedBannerStatusType.AboutHours(upperHours);
        }
        return new QueuedBannerStatusType.HourlyRange(lowerHours, upperHours);
    }

    private final QueuedBannerStatusType getSecondsText(int upperMinutes, int lowerMinutes) {
        if (upperMinutes == 1 && lowerMinutes == 1) {
            return new QueuedBannerStatusType.AboutMinute(0, 1, null);
        }
        return new QueuedBannerStatusType.WithinMinute(0, 1, null);
    }

    private final QueuedBannerStatusType getMinutesText(int upperMinutes, int lowerMinutes) {
        if (lowerMinutes < 1) {
            return new QueuedBannerStatusType.WithinMinutes(upperMinutes);
        }
        if (upperMinutes == lowerMinutes) {
            return new QueuedBannerStatusType.AboutMinutes(upperMinutes);
        }
        return new QueuedBannerStatusType.MinuteRange(lowerMinutes, upperMinutes);
    }
}
