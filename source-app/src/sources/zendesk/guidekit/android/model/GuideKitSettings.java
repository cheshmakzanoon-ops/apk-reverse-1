package zendesk.guidekit.android.model;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u000b\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\u000e\u0010\t\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\nJ\u000e\u0010\u000b\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\fJ\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0011\u001a\u00020\u0012HÖ\u0001J\t\u0010\u0013\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0014\u0010\u0004\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0014"}, m18d2 = {"Lzendesk/guidekit/android/model/GuideKitSettings;", "", "baseUrl", "", "channelId", "(Ljava/lang/String;Ljava/lang/String;)V", "getBaseUrl$zendesk_guidekit_guidekit_android", "()Ljava/lang/String;", "getChannelId$zendesk_guidekit_guidekit_android", "component1", "component1$zendesk_guidekit_guidekit_android", "component2", "component2$zendesk_guidekit_guidekit_android", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class GuideKitSettings {
    private final String baseUrl;
    private final String channelId;

    public static GuideKitSettings copy$default(GuideKitSettings guideKitSettings, String str, String str2, int i, Object obj) {
        if ((i & 1) != 0) {
            str = guideKitSettings.baseUrl;
        }
        if ((i & 2) != 0) {
            str2 = guideKitSettings.channelId;
        }
        return guideKitSettings.copy(str, str2);
    }

    public final String getBaseUrl() {
        return this.baseUrl;
    }

    public final String getChannelId() {
        return this.channelId;
    }

    public final GuideKitSettings copy(String baseUrl, String channelId) {
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(channelId, "channelId");
        return new GuideKitSettings(baseUrl, channelId);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof GuideKitSettings)) {
            return false;
        }
        GuideKitSettings guideKitSettings = (GuideKitSettings) other;
        return Intrinsics.areEqual(this.baseUrl, guideKitSettings.baseUrl) && Intrinsics.areEqual(this.channelId, guideKitSettings.channelId);
    }

    public int hashCode() {
        return (this.baseUrl.hashCode() * 31) + this.channelId.hashCode();
    }

    public String toString() {
        return "GuideKitSettings(baseUrl=" + this.baseUrl + ", channelId=" + this.channelId + ')';
    }

    public GuideKitSettings(String baseUrl, String channelId) {
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(channelId, "channelId");
        this.baseUrl = baseUrl;
        this.channelId = channelId;
    }

    public final String getBaseUrl$zendesk_guidekit_guidekit_android() {
        return this.baseUrl;
    }

    public final String getChannelId$zendesk_guidekit_guidekit_android() {
        return this.channelId;
    }
}
