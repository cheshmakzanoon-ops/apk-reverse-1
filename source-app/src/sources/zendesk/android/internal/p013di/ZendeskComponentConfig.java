package zendesk.android.internal.p013di;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.ZendeskCredentials;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0080\b\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005¢\u0006\u0002\u0010\bJ\t\u0010\u000f\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0010\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0012\u001a\u00020\u0005HÆ\u0003J1\u0010\u0013\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0018HÖ\u0001J\t\u0010\u0019\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\nR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\n¨\u0006\u001a"}, m18d2 = {"Lzendesk/android/internal/di/ZendeskComponentConfig;", "", "channelKey", "Lzendesk/android/ZendeskCredentials;", "baseUrl", "", "versionName", "osVersion", "(Lzendesk/android/ZendeskCredentials;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getBaseUrl", "()Ljava/lang/String;", "getChannelKey", "()Lzendesk/android/ZendeskCredentials;", "getOsVersion", "getVersionName", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ZendeskComponentConfig {
    private final String baseUrl;
    private final ZendeskCredentials channelKey;
    private final String osVersion;
    private final String versionName;

    public static ZendeskComponentConfig copy$default(ZendeskComponentConfig zendeskComponentConfig, ZendeskCredentials zendeskCredentials, String str, String str2, String str3, int i, Object obj) {
        if ((i & 1) != 0) {
            zendeskCredentials = zendeskComponentConfig.channelKey;
        }
        if ((i & 2) != 0) {
            str = zendeskComponentConfig.baseUrl;
        }
        if ((i & 4) != 0) {
            str2 = zendeskComponentConfig.versionName;
        }
        if ((i & 8) != 0) {
            str3 = zendeskComponentConfig.osVersion;
        }
        return zendeskComponentConfig.copy(zendeskCredentials, str, str2, str3);
    }

    public final ZendeskCredentials getChannelKey() {
        return this.channelKey;
    }

    public final String getBaseUrl() {
        return this.baseUrl;
    }

    public final String getVersionName() {
        return this.versionName;
    }

    public final String getOsVersion() {
        return this.osVersion;
    }

    public final ZendeskComponentConfig copy(ZendeskCredentials channelKey, String baseUrl, String versionName, String osVersion) {
        Intrinsics.checkNotNullParameter(channelKey, "channelKey");
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(versionName, "versionName");
        Intrinsics.checkNotNullParameter(osVersion, "osVersion");
        return new ZendeskComponentConfig(channelKey, baseUrl, versionName, osVersion);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ZendeskComponentConfig)) {
            return false;
        }
        ZendeskComponentConfig zendeskComponentConfig = (ZendeskComponentConfig) other;
        return Intrinsics.areEqual(this.channelKey, zendeskComponentConfig.channelKey) && Intrinsics.areEqual(this.baseUrl, zendeskComponentConfig.baseUrl) && Intrinsics.areEqual(this.versionName, zendeskComponentConfig.versionName) && Intrinsics.areEqual(this.osVersion, zendeskComponentConfig.osVersion);
    }

    public int hashCode() {
        return (((((this.channelKey.hashCode() * 31) + this.baseUrl.hashCode()) * 31) + this.versionName.hashCode()) * 31) + this.osVersion.hashCode();
    }

    public String toString() {
        return "ZendeskComponentConfig(channelKey=" + this.channelKey + ", baseUrl=" + this.baseUrl + ", versionName=" + this.versionName + ", osVersion=" + this.osVersion + ')';
    }

    public ZendeskComponentConfig(ZendeskCredentials channelKey, String baseUrl, String versionName, String osVersion) {
        Intrinsics.checkNotNullParameter(channelKey, "channelKey");
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(versionName, "versionName");
        Intrinsics.checkNotNullParameter(osVersion, "osVersion");
        this.channelKey = channelKey;
        this.baseUrl = baseUrl;
        this.versionName = versionName;
        this.osVersion = osVersion;
    }

    public final ZendeskCredentials getChannelKey() {
        return this.channelKey;
    }

    public final String getBaseUrl() {
        return this.baseUrl;
    }

    public final String getVersionName() {
        return this.versionName;
    }

    public final String getOsVersion() {
        return this.osVersion;
    }
}
