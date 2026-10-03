package zendesk.conversationkit.android.model;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u001e\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\u001a\n\u0010\u0000\u001a\u00020\u0001*\u00020\u0002\u001a7\u0010\u0003\u001a\u00020\u0001*\u00020\u00022\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\b\u0010\u0006\u001a\u0004\u0018\u00010\u00052\b\u0010\u0007\u001a\u0004\u0018\u00010\b2\b\u0010\t\u001a\u0004\u0018\u00010\b¢\u0006\u0002\u0010\n¨\u0006\u000b"}, m18d2 = {"shouldContinuePoll", "", "Lzendesk/conversationkit/android/model/WaitTimeConfig;", "shouldShowBanner", "lower", "", "upper", "queuePos", "", "lowestQueuePos", "(Lzendesk/conversationkit/android/model/WaitTimeConfig;Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/Integer;Ljava/lang/Integer;)Z", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class WaitTimeConfigKt {
    public static final boolean shouldShowBanner(WaitTimeConfig waitTimeConfig, Long l, Long l2, Integer num, Integer num2) {
        Intrinsics.checkNotNullParameter(waitTimeConfig, "<this>");
        boolean z = l == null && l2 == null;
        boolean z2 = num == null && num2 == null;
        return (waitTimeConfig.getWaitTimeEnabled() || waitTimeConfig.getQueuePositionEnabled()) && !((waitTimeConfig.getWaitTimeEnabled() && z && !waitTimeConfig.getQueuePositionEnabled()) || ((waitTimeConfig.getQueuePositionEnabled() && z2 && !waitTimeConfig.getWaitTimeEnabled()) || (z && z2)));
    }

    public static final boolean shouldContinuePoll(WaitTimeConfig waitTimeConfig) {
        Intrinsics.checkNotNullParameter(waitTimeConfig, "<this>");
        return waitTimeConfig.getWaitTimeEnabled() || waitTimeConfig.getQueuePositionEnabled();
    }
}
