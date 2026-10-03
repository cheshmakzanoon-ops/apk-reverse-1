package zendesk.guidekit.android.model;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\f\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0080\b\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0003HÆ\u0003J'\u0010\u000e\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0005\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\bR\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\b¨\u0006\u0015"}, m18d2 = {"Lzendesk/guidekit/android/model/Brand;", "", "channelId", "", "subdomain", "hostMapping", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getChannelId", "()Ljava/lang/String;", "getHostMapping", "getSubdomain", "component1", "component2", "component3", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class Brand {
    private final String channelId;
    private final String hostMapping;
    private final String subdomain;

    public static Brand copy$default(Brand brand, String str, String str2, String str3, int i, Object obj) {
        if ((i & 1) != 0) {
            str = brand.channelId;
        }
        if ((i & 2) != 0) {
            str2 = brand.subdomain;
        }
        if ((i & 4) != 0) {
            str3 = brand.hostMapping;
        }
        return brand.copy(str, str2, str3);
    }

    public final String getChannelId() {
        return this.channelId;
    }

    public final String getSubdomain() {
        return this.subdomain;
    }

    public final String getHostMapping() {
        return this.hostMapping;
    }

    public final Brand copy(String channelId, String subdomain, String hostMapping) {
        Intrinsics.checkNotNullParameter(channelId, "channelId");
        Intrinsics.checkNotNullParameter(subdomain, "subdomain");
        Intrinsics.checkNotNullParameter(hostMapping, "hostMapping");
        return new Brand(channelId, subdomain, hostMapping);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Brand)) {
            return false;
        }
        Brand brand = (Brand) other;
        return Intrinsics.areEqual(this.channelId, brand.channelId) && Intrinsics.areEqual(this.subdomain, brand.subdomain) && Intrinsics.areEqual(this.hostMapping, brand.hostMapping);
    }

    public int hashCode() {
        return (((this.channelId.hashCode() * 31) + this.subdomain.hashCode()) * 31) + this.hostMapping.hashCode();
    }

    public String toString() {
        return "Brand(channelId=" + this.channelId + ", subdomain=" + this.subdomain + ", hostMapping=" + this.hostMapping + ')';
    }

    public Brand(String channelId, String subdomain, String hostMapping) {
        Intrinsics.checkNotNullParameter(channelId, "channelId");
        Intrinsics.checkNotNullParameter(subdomain, "subdomain");
        Intrinsics.checkNotNullParameter(hostMapping, "hostMapping");
        this.channelId = channelId;
        this.subdomain = subdomain;
        this.hostMapping = hostMapping;
    }

    public final String getChannelId() {
        return this.channelId;
    }

    public final String getSubdomain() {
        return this.subdomain;
    }

    public final String getHostMapping() {
        return this.hostMapping;
    }
}
