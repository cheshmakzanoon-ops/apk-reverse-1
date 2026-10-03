package zendesk.p026ui.android.conversation.waittimebanner;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001:\u000b\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011B\u000f\b\u0004\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006\u0082\u0001\u000b\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c¨\u0006\u001d"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "", "resId", "", "(I)V", "getResId", "()I", "AboutDays", "AboutHours", "AboutMinute", "AboutMinutes", "DailyRange", "HourlyRange", "MinuteRange", "WithinDays", "WithinHours", "WithinMinute", "WithinMinutes", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$AboutDays;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$AboutHours;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$AboutMinute;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$AboutMinutes;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$DailyRange;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$HourlyRange;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$MinuteRange;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$WithinDays;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$WithinHours;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$WithinMinute;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$WithinMinutes;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class QueuedBannerStatusType {
    public static final int $stable = 0;
    private final int resId;

    public QueuedBannerStatusType(int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(i);
    }

    private QueuedBannerStatusType(int i) {
        this.resId = i;
    }

    public final int getResId() {
        return this.resId;
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u0003HÖ\u0001J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$WithinDays;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "upperDays", "", "(I)V", "getUpperDays", "()I", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class WithinDays extends QueuedBannerStatusType {
        public static final int $stable = 0;
        private final int upperDays;

        public static WithinDays copy$default(WithinDays withinDays, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                i = withinDays.upperDays;
            }
            return withinDays.copy(i);
        }

        public final int getUpperDays() {
            return this.upperDays;
        }

        public final WithinDays copy(int upperDays) {
            return new WithinDays(upperDays);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof WithinDays) && this.upperDays == ((WithinDays) other).upperDays;
        }

        public int hashCode() {
            return this.upperDays;
        }

        public String toString() {
            return "WithinDays(upperDays=" + this.upperDays + ')';
        }

        public final int getUpperDays() {
            return this.upperDays;
        }

        public WithinDays(int i) {
            super(R.string.zuia_static_wait_time_banner_join_within_days, null);
            this.upperDays = i;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u0003HÖ\u0001J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$AboutDays;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "upperDays", "", "(I)V", "getUpperDays", "()I", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class AboutDays extends QueuedBannerStatusType {
        public static final int $stable = 0;
        private final int upperDays;

        public static AboutDays copy$default(AboutDays aboutDays, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                i = aboutDays.upperDays;
            }
            return aboutDays.copy(i);
        }

        public final int getUpperDays() {
            return this.upperDays;
        }

        public final AboutDays copy(int upperDays) {
            return new AboutDays(upperDays);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof AboutDays) && this.upperDays == ((AboutDays) other).upperDays;
        }

        public int hashCode() {
            return this.upperDays;
        }

        public String toString() {
            return "AboutDays(upperDays=" + this.upperDays + ')';
        }

        public final int getUpperDays() {
            return this.upperDays;
        }

        public AboutDays(int i) {
            super(R.string.zuia_static_wait_time_banner_join_about_days, null);
            this.upperDays = i;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0011\u001a\u00020\u0012HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$DailyRange;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "lowerDays", "", "upperDays", "(II)V", "getLowerDays", "()I", "getUpperDays", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class DailyRange extends QueuedBannerStatusType {
        public static final int $stable = 0;
        private final int lowerDays;
        private final int upperDays;

        public static DailyRange copy$default(DailyRange dailyRange, int i, int i2, int i3, Object obj) {
            if ((i3 & 1) != 0) {
                i = dailyRange.lowerDays;
            }
            if ((i3 & 2) != 0) {
                i2 = dailyRange.upperDays;
            }
            return dailyRange.copy(i, i2);
        }

        public final int getLowerDays() {
            return this.lowerDays;
        }

        public final int getUpperDays() {
            return this.upperDays;
        }

        public final DailyRange copy(int lowerDays, int upperDays) {
            return new DailyRange(lowerDays, upperDays);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof DailyRange)) {
                return false;
            }
            DailyRange dailyRange = (DailyRange) other;
            return this.lowerDays == dailyRange.lowerDays && this.upperDays == dailyRange.upperDays;
        }

        public int hashCode() {
            return (this.lowerDays * 31) + this.upperDays;
        }

        public String toString() {
            return "DailyRange(lowerDays=" + this.lowerDays + ", upperDays=" + this.upperDays + ')';
        }

        public final int getLowerDays() {
            return this.lowerDays;
        }

        public final int getUpperDays() {
            return this.upperDays;
        }

        public DailyRange(int i, int i2) {
            super(R.string.zuia_static_wait_time_banner_join_days, null);
            this.lowerDays = i;
            this.upperDays = i2;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u0003HÖ\u0001J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$WithinHours;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "upperHours", "", "(I)V", "getUpperHours", "()I", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class WithinHours extends QueuedBannerStatusType {
        public static final int $stable = 0;
        private final int upperHours;

        public static WithinHours copy$default(WithinHours withinHours, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                i = withinHours.upperHours;
            }
            return withinHours.copy(i);
        }

        public final int getUpperHours() {
            return this.upperHours;
        }

        public final WithinHours copy(int upperHours) {
            return new WithinHours(upperHours);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof WithinHours) && this.upperHours == ((WithinHours) other).upperHours;
        }

        public int hashCode() {
            return this.upperHours;
        }

        public String toString() {
            return "WithinHours(upperHours=" + this.upperHours + ')';
        }

        public final int getUpperHours() {
            return this.upperHours;
        }

        public WithinHours(int i) {
            super(R.string.zuia_static_wait_time_banner_join_within_hours, null);
            this.upperHours = i;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u0003HÖ\u0001J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$AboutHours;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "upperHours", "", "(I)V", "getUpperHours", "()I", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class AboutHours extends QueuedBannerStatusType {
        public static final int $stable = 0;
        private final int upperHours;

        public static AboutHours copy$default(AboutHours aboutHours, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                i = aboutHours.upperHours;
            }
            return aboutHours.copy(i);
        }

        public final int getUpperHours() {
            return this.upperHours;
        }

        public final AboutHours copy(int upperHours) {
            return new AboutHours(upperHours);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof AboutHours) && this.upperHours == ((AboutHours) other).upperHours;
        }

        public int hashCode() {
            return this.upperHours;
        }

        public String toString() {
            return "AboutHours(upperHours=" + this.upperHours + ')';
        }

        public final int getUpperHours() {
            return this.upperHours;
        }

        public AboutHours(int i) {
            super(R.string.zuia_static_wait_time_banner_join_about_hours, null);
            this.upperHours = i;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0011\u001a\u00020\u0012HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$HourlyRange;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "lowerHours", "", "upperHours", "(II)V", "getLowerHours", "()I", "getUpperHours", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class HourlyRange extends QueuedBannerStatusType {
        public static final int $stable = 0;
        private final int lowerHours;
        private final int upperHours;

        public static HourlyRange copy$default(HourlyRange hourlyRange, int i, int i2, int i3, Object obj) {
            if ((i3 & 1) != 0) {
                i = hourlyRange.lowerHours;
            }
            if ((i3 & 2) != 0) {
                i2 = hourlyRange.upperHours;
            }
            return hourlyRange.copy(i, i2);
        }

        public final int getLowerHours() {
            return this.lowerHours;
        }

        public final int getUpperHours() {
            return this.upperHours;
        }

        public final HourlyRange copy(int lowerHours, int upperHours) {
            return new HourlyRange(lowerHours, upperHours);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof HourlyRange)) {
                return false;
            }
            HourlyRange hourlyRange = (HourlyRange) other;
            return this.lowerHours == hourlyRange.lowerHours && this.upperHours == hourlyRange.upperHours;
        }

        public int hashCode() {
            return (this.lowerHours * 31) + this.upperHours;
        }

        public String toString() {
            return "HourlyRange(lowerHours=" + this.lowerHours + ", upperHours=" + this.upperHours + ')';
        }

        public final int getLowerHours() {
            return this.lowerHours;
        }

        public final int getUpperHours() {
            return this.upperHours;
        }

        public HourlyRange(int i, int i2) {
            super(R.string.zuia_static_wait_time_banner_join_hours, null);
            this.lowerHours = i;
            this.upperHours = i2;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u0003HÖ\u0001J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$WithinMinutes;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "upperMinutes", "", "(I)V", "getUpperMinutes", "()I", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class WithinMinutes extends QueuedBannerStatusType {
        public static final int $stable = 0;
        private final int upperMinutes;

        public static WithinMinutes copy$default(WithinMinutes withinMinutes, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                i = withinMinutes.upperMinutes;
            }
            return withinMinutes.copy(i);
        }

        public final int getUpperMinutes() {
            return this.upperMinutes;
        }

        public final WithinMinutes copy(int upperMinutes) {
            return new WithinMinutes(upperMinutes);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof WithinMinutes) && this.upperMinutes == ((WithinMinutes) other).upperMinutes;
        }

        public int hashCode() {
            return this.upperMinutes;
        }

        public String toString() {
            return "WithinMinutes(upperMinutes=" + this.upperMinutes + ')';
        }

        public final int getUpperMinutes() {
            return this.upperMinutes;
        }

        public WithinMinutes(int i) {
            super(R.string.zuia_static_wait_time_banner_join_within_minutes, null);
            this.upperMinutes = i;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u0003HÖ\u0001J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$AboutMinutes;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "upperMinutes", "", "(I)V", "getUpperMinutes", "()I", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class AboutMinutes extends QueuedBannerStatusType {
        public static final int $stable = 0;
        private final int upperMinutes;

        public static AboutMinutes copy$default(AboutMinutes aboutMinutes, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                i = aboutMinutes.upperMinutes;
            }
            return aboutMinutes.copy(i);
        }

        public final int getUpperMinutes() {
            return this.upperMinutes;
        }

        public final AboutMinutes copy(int upperMinutes) {
            return new AboutMinutes(upperMinutes);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof AboutMinutes) && this.upperMinutes == ((AboutMinutes) other).upperMinutes;
        }

        public int hashCode() {
            return this.upperMinutes;
        }

        public String toString() {
            return "AboutMinutes(upperMinutes=" + this.upperMinutes + ')';
        }

        public final int getUpperMinutes() {
            return this.upperMinutes;
        }

        public AboutMinutes(int i) {
            super(R.string.zuia_static_wait_time_banner_join_about_minutes, null);
            this.upperMinutes = i;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0011\u001a\u00020\u0012HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$MinuteRange;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "lowerMinutes", "", "upperMinutes", "(II)V", "getLowerMinutes", "()I", "getUpperMinutes", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class MinuteRange extends QueuedBannerStatusType {
        public static final int $stable = 0;
        private final int lowerMinutes;
        private final int upperMinutes;

        public static MinuteRange copy$default(MinuteRange minuteRange, int i, int i2, int i3, Object obj) {
            if ((i3 & 1) != 0) {
                i = minuteRange.lowerMinutes;
            }
            if ((i3 & 2) != 0) {
                i2 = minuteRange.upperMinutes;
            }
            return minuteRange.copy(i, i2);
        }

        public final int getLowerMinutes() {
            return this.lowerMinutes;
        }

        public final int getUpperMinutes() {
            return this.upperMinutes;
        }

        public final MinuteRange copy(int lowerMinutes, int upperMinutes) {
            return new MinuteRange(lowerMinutes, upperMinutes);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof MinuteRange)) {
                return false;
            }
            MinuteRange minuteRange = (MinuteRange) other;
            return this.lowerMinutes == minuteRange.lowerMinutes && this.upperMinutes == minuteRange.upperMinutes;
        }

        public int hashCode() {
            return (this.lowerMinutes * 31) + this.upperMinutes;
        }

        public String toString() {
            return "MinuteRange(lowerMinutes=" + this.lowerMinutes + ", upperMinutes=" + this.upperMinutes + ')';
        }

        public final int getLowerMinutes() {
            return this.lowerMinutes;
        }

        public final int getUpperMinutes() {
            return this.upperMinutes;
        }

        public MinuteRange(int i, int i2) {
            super(R.string.zuia_static_wait_time_banner_join_minutes, null);
            this.lowerMinutes = i;
            this.upperMinutes = i2;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B\u000f\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u0003HÖ\u0001J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$WithinMinute;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "minute", "", "(I)V", "getMinute", "()I", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class WithinMinute extends QueuedBannerStatusType {
        public static final int $stable = 0;
        private final int minute;

        public WithinMinute() {
            this(0, 1, null);
        }

        public static WithinMinute copy$default(WithinMinute withinMinute, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                i = withinMinute.minute;
            }
            return withinMinute.copy(i);
        }

        public final int getMinute() {
            return this.minute;
        }

        public final WithinMinute copy(int minute) {
            return new WithinMinute(minute);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof WithinMinute) && this.minute == ((WithinMinute) other).minute;
        }

        public int hashCode() {
            return this.minute;
        }

        public String toString() {
            return "WithinMinute(minute=" + this.minute + ')';
        }

        public WithinMinute(int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
            this((i2 & 1) != 0 ? 1 : i);
        }

        public final int getMinute() {
            return this.minute;
        }

        public WithinMinute(int i) {
            super(R.string.zuia_static_wait_time_banner_join_within_minute, null);
            this.minute = i;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B\u000f\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u0003HÖ\u0001J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType$AboutMinute;", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "minute", "", "(I)V", "getMinute", "()I", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class AboutMinute extends QueuedBannerStatusType {
        public static final int $stable = 0;
        private final int minute;

        public AboutMinute() {
            this(0, 1, null);
        }

        public static AboutMinute copy$default(AboutMinute aboutMinute, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                i = aboutMinute.minute;
            }
            return aboutMinute.copy(i);
        }

        public final int getMinute() {
            return this.minute;
        }

        public final AboutMinute copy(int minute) {
            return new AboutMinute(minute);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof AboutMinute) && this.minute == ((AboutMinute) other).minute;
        }

        public int hashCode() {
            return this.minute;
        }

        public String toString() {
            return "AboutMinute(minute=" + this.minute + ')';
        }

        public AboutMinute(int i, int i2, DefaultConstructorMarker defaultConstructorMarker) {
            this((i2 & 1) != 0 ? 1 : i);
        }

        public final int getMinute() {
            return this.minute;
        }

        public AboutMinute(int i) {
            super(R.string.zuia_static_wait_time_banner_join_about_minute, null);
            this.minute = i;
        }
    }
}
