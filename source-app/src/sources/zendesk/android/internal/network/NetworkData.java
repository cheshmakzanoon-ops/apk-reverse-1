package zendesk.android.internal.network;

import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.internal.p013di.ZendeskComponentConfig;

@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u000f\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0006\u0010\u0005\u001a\u00020\u0006R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0007"}, m18d2 = {"Lzendesk/android/internal/network/NetworkData;", "", "config", "Lzendesk/android/internal/di/ZendeskComponentConfig;", "(Lzendesk/android/internal/di/ZendeskComponentConfig;)V", "userAgent", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class NetworkData {
    private final ZendeskComponentConfig config;

    @Inject
    public NetworkData(ZendeskComponentConfig config) {
        Intrinsics.checkNotNullParameter(config, "config");
        this.config = config;
    }

    public final String userAgent() {
        return "Zendesk-SDK/" + this.config.getVersionName() + " Android/" + this.config.getOsVersion() + " Variant/Zendesk";
    }
}
