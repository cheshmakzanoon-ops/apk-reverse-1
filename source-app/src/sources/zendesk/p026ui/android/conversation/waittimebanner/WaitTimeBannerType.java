package zendesk.p026ui.android.conversation.waittimebanner;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u00002\u00020\u0001:\u0003\u0003\u0004\u0005B\u0007\b\u0004¢\u0006\u0002\u0010\u0002\u0082\u0001\u0003\u0006\u0007\b¨\u0006\t"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;", "", "()V", "Assigned", "Cleared", "Queued", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType$Assigned;", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType$Cleared;", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType$Queued;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class WaitTimeBannerType {
    public static final int $stable = 0;

    public WaitTimeBannerType(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private WaitTimeBannerType() {
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\bÇ\n\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0013\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006HÖ\u0003J\t\u0010\u0007\u001a\u00020\bHÖ\u0001J\t\u0010\t\u001a\u00020\nHÖ\u0001¨\u0006\u000b"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType$Cleared;", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;", "()V", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Cleared extends WaitTimeBannerType {
        public static final int $stable = 0;
        public static final Cleared INSTANCE = new Cleared();

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Cleared)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return 1805919714;
        }

        public String toString() {
            return "Cleared";
        }

        private Cleared() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\bÇ\n\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0013\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006HÖ\u0003J\t\u0010\u0007\u001a\u00020\bHÖ\u0001J\t\u0010\t\u001a\u00020\nHÖ\u0001¨\u0006\u000b"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType$Assigned;", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;", "()V", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Assigned extends WaitTimeBannerType {
        public static final int $stable = 0;
        public static final Assigned INSTANCE = new Assigned();

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Assigned)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return -1011248552;
        }

        public String toString() {
            return "Assigned";
        }

        private Assigned() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0012\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B1\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b\u0012\b\b\u0002\u0010\t\u001a\u00020\b¢\u0006\u0002\u0010\nJ\t\u0010\u0013\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0014\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0016\u001a\u00020\bHÆ\u0003J\t\u0010\u0017\u001a\u00020\bHÆ\u0003J;\u0010\u0018\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\bHÆ\u0001J\u0013\u0010\u0019\u001a\u00020\u00032\b\u0010\u001a\u001a\u0004\u0018\u00010\u001bHÖ\u0003J\t\u0010\u001c\u001a\u00020\bHÖ\u0001J\t\u0010\u001d\u001a\u00020\u001eHÖ\u0001R\u0011\u0010\t\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\fR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0011\u0010\u0006\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0011¨\u0006\u001f"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType$Queued;", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;", "shouldShowResponseTime", "", "responseTime", "Lzendesk/ui/android/conversation/waittimebanner/ResponseTime;", "shouldShowQueue", "queuePosition", "", "lowestQueuePosition", "(ZLzendesk/ui/android/conversation/waittimebanner/ResponseTime;ZII)V", "getLowestQueuePosition", "()I", "getQueuePosition", "getResponseTime", "()Lzendesk/ui/android/conversation/waittimebanner/ResponseTime;", "getShouldShowQueue", "()Z", "getShouldShowResponseTime", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "other", "", "hashCode", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Queued extends WaitTimeBannerType {
        public static final int $stable = 0;
        private final int lowestQueuePosition;
        private final int queuePosition;
        private final ResponseTime responseTime;
        private final boolean shouldShowQueue;
        private final boolean shouldShowResponseTime;

        public static Queued copy$default(Queued queued, boolean z, ResponseTime responseTime, boolean z2, int i, int i2, int i3, Object obj) {
            if ((i3 & 1) != 0) {
                z = queued.shouldShowResponseTime;
            }
            if ((i3 & 2) != 0) {
                responseTime = queued.responseTime;
            }
            ResponseTime responseTime2 = responseTime;
            if ((i3 & 4) != 0) {
                z2 = queued.shouldShowQueue;
            }
            boolean z3 = z2;
            if ((i3 & 8) != 0) {
                i = queued.queuePosition;
            }
            int i4 = i;
            if ((i3 & 16) != 0) {
                i2 = queued.lowestQueuePosition;
            }
            return queued.copy(z, responseTime2, z3, i4, i2);
        }

        public final boolean getShouldShowResponseTime() {
            return this.shouldShowResponseTime;
        }

        public final ResponseTime getResponseTime() {
            return this.responseTime;
        }

        public final boolean getShouldShowQueue() {
            return this.shouldShowQueue;
        }

        public final int getQueuePosition() {
            return this.queuePosition;
        }

        public final int getLowestQueuePosition() {
            return this.lowestQueuePosition;
        }

        public final Queued copy(boolean shouldShowResponseTime, ResponseTime responseTime, boolean shouldShowQueue, int queuePosition, int lowestQueuePosition) {
            Intrinsics.checkNotNullParameter(responseTime, "responseTime");
            return new Queued(shouldShowResponseTime, responseTime, shouldShowQueue, queuePosition, lowestQueuePosition);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Queued)) {
                return false;
            }
            Queued queued = (Queued) other;
            return this.shouldShowResponseTime == queued.shouldShowResponseTime && Intrinsics.areEqual(this.responseTime, queued.responseTime) && this.shouldShowQueue == queued.shouldShowQueue && this.queuePosition == queued.queuePosition && this.lowestQueuePosition == queued.lowestQueuePosition;
        }

        public int hashCode() {
            return (((((((UByte$$ExternalSyntheticBackport0.m30m(this.shouldShowResponseTime) * 31) + this.responseTime.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldShowQueue)) * 31) + this.queuePosition) * 31) + this.lowestQueuePosition;
        }

        public String toString() {
            return "Queued(shouldShowResponseTime=" + this.shouldShowResponseTime + ", responseTime=" + this.responseTime + ", shouldShowQueue=" + this.shouldShowQueue + ", queuePosition=" + this.queuePosition + ", lowestQueuePosition=" + this.lowestQueuePosition + ')';
        }

        public Queued(boolean z, ResponseTime responseTime, boolean z2, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
            this(z, responseTime, z2, (i3 & 8) != 0 ? 1 : i, (i3 & 16) != 0 ? 1 : i2);
        }

        public final boolean getShouldShowResponseTime() {
            return this.shouldShowResponseTime;
        }

        public final ResponseTime getResponseTime() {
            return this.responseTime;
        }

        public final boolean getShouldShowQueue() {
            return this.shouldShowQueue;
        }

        public final int getQueuePosition() {
            return this.queuePosition;
        }

        public final int getLowestQueuePosition() {
            return this.lowestQueuePosition;
        }

        public Queued(boolean z, ResponseTime responseTime, boolean z2, int i, int i2) {
            super(null);
            Intrinsics.checkNotNullParameter(responseTime, "responseTime");
            this.shouldShowResponseTime = z;
            this.responseTime = responseTime;
            this.shouldShowQueue = z2;
            this.queuePosition = i;
            this.lowestQueuePosition = i2;
        }
    }
}
