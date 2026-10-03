package zendesk.conversationkit.android.model;

import java.util.concurrent.TimeUnit;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B7\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0006\u0012\b\b\u0002\u0010\u0007\u001a\u00020\u0003\u0012\b\b\u0002\u0010\b\u001a\u00020\u0003¢\u0006\u0002\u0010\tJ\t\u0010\u0011\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0012\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0013\u001a\u00020\u0006HÆ\u0003J\t\u0010\u0014\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0003HÆ\u0003J;\u0010\u0016\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\u00032\b\b\u0002\u0010\b\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u0017\u001a\u00020\u00182\b\u0010\u0019\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001a\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001b\u001a\u00020\u001cHÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\u0007\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\u000bR\u0011\u0010\b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000bR\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010¨\u0006\u001d"}, m18d2 = {"Lzendesk/conversationkit/android/model/RestRetryPolicy;", "", "regular", "", "aggressive", "timeUnit", "Ljava/util/concurrent/TimeUnit;", "backoffMultiplier", "maxRetries", "(IILjava/util/concurrent/TimeUnit;II)V", "getAggressive", "()I", "getBackoffMultiplier", "getMaxRetries", "getRegular", "getTimeUnit", "()Ljava/util/concurrent/TimeUnit;", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "hashCode", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class RestRetryPolicy {
    private final int aggressive;
    private final int backoffMultiplier;
    private final int maxRetries;
    private final int regular;
    private final TimeUnit timeUnit;

    public RestRetryPolicy() {
        this(0, 0, null, 0, 0, 31, null);
    }

    public static RestRetryPolicy copy$default(RestRetryPolicy restRetryPolicy, int i, int i2, TimeUnit timeUnit, int i3, int i4, int i5, Object obj) {
        if ((i5 & 1) != 0) {
            i = restRetryPolicy.regular;
        }
        if ((i5 & 2) != 0) {
            i2 = restRetryPolicy.aggressive;
        }
        int i6 = i2;
        if ((i5 & 4) != 0) {
            timeUnit = restRetryPolicy.timeUnit;
        }
        TimeUnit timeUnit2 = timeUnit;
        if ((i5 & 8) != 0) {
            i3 = restRetryPolicy.backoffMultiplier;
        }
        int i7 = i3;
        if ((i5 & 16) != 0) {
            i4 = restRetryPolicy.maxRetries;
        }
        return restRetryPolicy.copy(i, i6, timeUnit2, i7, i4);
    }

    public final int getRegular() {
        return this.regular;
    }

    public final int getAggressive() {
        return this.aggressive;
    }

    public final TimeUnit getTimeUnit() {
        return this.timeUnit;
    }

    public final int getBackoffMultiplier() {
        return this.backoffMultiplier;
    }

    public final int getMaxRetries() {
        return this.maxRetries;
    }

    public final RestRetryPolicy copy(int regular, int aggressive, TimeUnit timeUnit, int backoffMultiplier, int maxRetries) {
        Intrinsics.checkNotNullParameter(timeUnit, "timeUnit");
        return new RestRetryPolicy(regular, aggressive, timeUnit, backoffMultiplier, maxRetries);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof RestRetryPolicy)) {
            return false;
        }
        RestRetryPolicy restRetryPolicy = (RestRetryPolicy) other;
        return this.regular == restRetryPolicy.regular && this.aggressive == restRetryPolicy.aggressive && this.timeUnit == restRetryPolicy.timeUnit && this.backoffMultiplier == restRetryPolicy.backoffMultiplier && this.maxRetries == restRetryPolicy.maxRetries;
    }

    public int hashCode() {
        return (((((((this.regular * 31) + this.aggressive) * 31) + this.timeUnit.hashCode()) * 31) + this.backoffMultiplier) * 31) + this.maxRetries;
    }

    public String toString() {
        return "RestRetryPolicy(regular=" + this.regular + ", aggressive=" + this.aggressive + ", timeUnit=" + this.timeUnit + ", backoffMultiplier=" + this.backoffMultiplier + ", maxRetries=" + this.maxRetries + ')';
    }

    public RestRetryPolicy(int i, int i2, TimeUnit timeUnit, int i3, int i4) {
        Intrinsics.checkNotNullParameter(timeUnit, "timeUnit");
        this.regular = i;
        this.aggressive = i2;
        this.timeUnit = timeUnit;
        this.backoffMultiplier = i3;
        this.maxRetries = i4;
    }

    public final int getRegular() {
        return this.regular;
    }

    public final int getAggressive() {
        return this.aggressive;
    }

    public RestRetryPolicy(int i, int i2, TimeUnit timeUnit, int i3, int i4, int i5, DefaultConstructorMarker defaultConstructorMarker) {
        this((i5 & 1) != 0 ? 60 : i, (i5 & 2) != 0 ? 15 : i2, (i5 & 4) != 0 ? TimeUnit.SECONDS : timeUnit, (i5 & 8) != 0 ? 2 : i3, (i5 & 16) != 0 ? 5 : i4);
    }

    public final TimeUnit getTimeUnit() {
        return this.timeUnit;
    }

    public final int getBackoffMultiplier() {
        return this.backoffMultiplier;
    }

    public final int getMaxRetries() {
        return this.maxRetries;
    }
}
