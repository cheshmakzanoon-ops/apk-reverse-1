package zendesk.p026ui.android.conversation.waittimebanner;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\t\n\u0002\b\t\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B\u0019\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001J\t\u0010\u0011\u001a\u00020\u0012HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/conversation/waittimebanner/ResponseTime;", "", "lower", "", "upper", "(JJ)V", "getLower", "()J", "getUpper", "component1", "component2", "copy", "equals", "", "other", "hashCode", "", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ResponseTime {
    public static final int $stable = 0;
    private final long lower;
    private final long upper;

    public ResponseTime() {
        this(0L, 0L, 3, null);
    }

    public static ResponseTime copy$default(ResponseTime responseTime, long j, long j2, int i, Object obj) {
        if ((i & 1) != 0) {
            j = responseTime.lower;
        }
        if ((i & 2) != 0) {
            j2 = responseTime.upper;
        }
        return responseTime.copy(j, j2);
    }

    public final long getLower() {
        return this.lower;
    }

    public final long getUpper() {
        return this.upper;
    }

    public final ResponseTime copy(long lower, long upper) {
        return new ResponseTime(lower, upper);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ResponseTime)) {
            return false;
        }
        ResponseTime responseTime = (ResponseTime) other;
        return this.lower == responseTime.lower && this.upper == responseTime.upper;
    }

    public int hashCode() {
        return (UByte$$ExternalSyntheticBackport0.m27m(this.lower) * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.upper);
    }

    public String toString() {
        return "ResponseTime(lower=" + this.lower + ", upper=" + this.upper + ')';
    }

    public ResponseTime(long j, long j2) {
        this.lower = j;
        this.upper = j2;
    }

    public ResponseTime(long j, long j2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? 0L : j, (i & 2) != 0 ? 0L : j2);
    }

    public final long getLower() {
        return this.lower;
    }

    public final long getUpper() {
        return this.upper;
    }
}
