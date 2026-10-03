package zendesk.conversationkit.android.model;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0014\n\u0000\n\u0002\u0010\t\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\u001a\u0012\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004\u001a\n\u0010\u0005\u001a\u00020\u0001*\u00020\u0002¨\u0006\u0006"}, m18d2 = {"exponentialBackoffInterval", "", "Lzendesk/conversationkit/android/model/Config;", "retry", "", "waitTimePollingInterval", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConfigKt {
    public static final long waitTimePollingInterval(Config config) {
        Intrinsics.checkNotNullParameter(config, "<this>");
        return config.getIntegration().getWaitTimeConfig().getQueuePollingInterval();
    }

    public static final long exponentialBackoffInterval(Config config, int i) {
        Intrinsics.checkNotNullParameter(config, "<this>");
        return config.getRestRetryPolicy().getRegular() * config.getRestRetryPolicy().getBackoffMultiplier() * i;
    }
}
