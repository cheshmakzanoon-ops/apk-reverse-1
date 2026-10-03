package zendesk.conversationkit.android.model;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0016\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B/\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\b\u001a\u00020\u0007¢\u0006\u0002\u0010\tJ\t\u0010\u0013\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0014\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0003HÆ\u0003J\u0010\u0010\u0016\u001a\u0004\u0018\u00010\u0007HÆ\u0003¢\u0006\u0002\u0010\u0011J\t\u0010\u0017\u001a\u00020\u0007HÆ\u0003JB\u0010\u0018\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00032\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00072\b\b\u0002\u0010\b\u001a\u00020\u0007HÆ\u0001¢\u0006\u0002\u0010\u0019J\u0013\u0010\u001a\u001a\u00020\u00032\b\u0010\u001b\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001c\u001a\u00020\u0007HÖ\u0001J\t\u0010\u001d\u001a\u00020\u001eHÖ\u0001R\u0011\u0010\u0005\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\b\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000bR\u0015\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\n\n\u0002\u0010\u0012\u001a\u0004\b\u0010\u0010\u0011¨\u0006\u001f"}, m18d2 = {"Lzendesk/conversationkit/android/model/WaitTimeConfig;", "", "waitTimeEnabled", "", "queuePositionEnabled", "onlyDecreasingQueue", "waitTimeOverride", "", "queuePollingInterval", "(ZZZLjava/lang/Integer;I)V", "getOnlyDecreasingQueue", "()Z", "getQueuePollingInterval", "()I", "getQueuePositionEnabled", "getWaitTimeEnabled", "getWaitTimeOverride", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "component1", "component2", "component3", "component4", "component5", "copy", "(ZZZLjava/lang/Integer;I)Lzendesk/conversationkit/android/model/WaitTimeConfig;", "equals", "other", "hashCode", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class WaitTimeConfig {
    private final boolean onlyDecreasingQueue;
    private final int queuePollingInterval;
    private final boolean queuePositionEnabled;
    private final boolean waitTimeEnabled;
    private final Integer waitTimeOverride;

    public static WaitTimeConfig copy$default(WaitTimeConfig waitTimeConfig, boolean z, boolean z2, boolean z3, Integer num, int i, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            z = waitTimeConfig.waitTimeEnabled;
        }
        if ((i2 & 2) != 0) {
            z2 = waitTimeConfig.queuePositionEnabled;
        }
        boolean z4 = z2;
        if ((i2 & 4) != 0) {
            z3 = waitTimeConfig.onlyDecreasingQueue;
        }
        boolean z5 = z3;
        if ((i2 & 8) != 0) {
            num = waitTimeConfig.waitTimeOverride;
        }
        Integer num2 = num;
        if ((i2 & 16) != 0) {
            i = waitTimeConfig.queuePollingInterval;
        }
        return waitTimeConfig.copy(z, z4, z5, num2, i);
    }

    public final boolean getWaitTimeEnabled() {
        return this.waitTimeEnabled;
    }

    public final boolean getQueuePositionEnabled() {
        return this.queuePositionEnabled;
    }

    public final boolean getOnlyDecreasingQueue() {
        return this.onlyDecreasingQueue;
    }

    public final Integer getWaitTimeOverride() {
        return this.waitTimeOverride;
    }

    public final int getQueuePollingInterval() {
        return this.queuePollingInterval;
    }

    public final WaitTimeConfig copy(boolean waitTimeEnabled, boolean queuePositionEnabled, boolean onlyDecreasingQueue, Integer waitTimeOverride, int queuePollingInterval) {
        return new WaitTimeConfig(waitTimeEnabled, queuePositionEnabled, onlyDecreasingQueue, waitTimeOverride, queuePollingInterval);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof WaitTimeConfig)) {
            return false;
        }
        WaitTimeConfig waitTimeConfig = (WaitTimeConfig) other;
        return this.waitTimeEnabled == waitTimeConfig.waitTimeEnabled && this.queuePositionEnabled == waitTimeConfig.queuePositionEnabled && this.onlyDecreasingQueue == waitTimeConfig.onlyDecreasingQueue && Intrinsics.areEqual(this.waitTimeOverride, waitTimeConfig.waitTimeOverride) && this.queuePollingInterval == waitTimeConfig.queuePollingInterval;
    }

    public int hashCode() {
        int iM30m = ((((UByte$$ExternalSyntheticBackport0.m30m(this.waitTimeEnabled) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.queuePositionEnabled)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.onlyDecreasingQueue)) * 31;
        Integer num = this.waitTimeOverride;
        return ((iM30m + (num == null ? 0 : num.hashCode())) * 31) + this.queuePollingInterval;
    }

    public String toString() {
        return "WaitTimeConfig(waitTimeEnabled=" + this.waitTimeEnabled + ", queuePositionEnabled=" + this.queuePositionEnabled + ", onlyDecreasingQueue=" + this.onlyDecreasingQueue + ", waitTimeOverride=" + this.waitTimeOverride + ", queuePollingInterval=" + this.queuePollingInterval + ')';
    }

    public WaitTimeConfig(boolean z, boolean z2, boolean z3, Integer num, int i) {
        this.waitTimeEnabled = z;
        this.queuePositionEnabled = z2;
        this.onlyDecreasingQueue = z3;
        this.waitTimeOverride = num;
        this.queuePollingInterval = i;
    }

    public final boolean getWaitTimeEnabled() {
        return this.waitTimeEnabled;
    }

    public final boolean getQueuePositionEnabled() {
        return this.queuePositionEnabled;
    }

    public final boolean getOnlyDecreasingQueue() {
        return this.onlyDecreasingQueue;
    }

    public final Integer getWaitTimeOverride() {
        return this.waitTimeOverride;
    }

    public final int getQueuePollingInterval() {
        return this.queuePollingInterval;
    }
}
