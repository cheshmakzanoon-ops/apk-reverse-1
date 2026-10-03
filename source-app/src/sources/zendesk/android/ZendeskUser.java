package zendesk.android;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\u000b\u0010\n\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u001f\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001J\t\u0010\u0011\u001a\u00020\u0003HÖ\u0001R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/android/ZendeskUser;", "", "id", "", "externalId", "(Ljava/lang/String;Ljava/lang/String;)V", "getExternalId", "()Ljava/lang/String;", "getId", "component1", "component2", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ZendeskUser {
    private final String externalId;
    private final String id;

    public static ZendeskUser copy$default(ZendeskUser zendeskUser, String str, String str2, int i, Object obj) {
        if ((i & 1) != 0) {
            str = zendeskUser.id;
        }
        if ((i & 2) != 0) {
            str2 = zendeskUser.externalId;
        }
        return zendeskUser.copy(str, str2);
    }

    public final String getId() {
        return this.id;
    }

    public final String getExternalId() {
        return this.externalId;
    }

    public final ZendeskUser copy(String id, String externalId) {
        Intrinsics.checkNotNullParameter(id, "id");
        return new ZendeskUser(id, externalId);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ZendeskUser)) {
            return false;
        }
        ZendeskUser zendeskUser = (ZendeskUser) other;
        return Intrinsics.areEqual(this.id, zendeskUser.id) && Intrinsics.areEqual(this.externalId, zendeskUser.externalId);
    }

    public int hashCode() {
        int iHashCode = this.id.hashCode() * 31;
        String str = this.externalId;
        return iHashCode + (str == null ? 0 : str.hashCode());
    }

    public String toString() {
        return "ZendeskUser(id=" + this.id + ", externalId=" + this.externalId + ')';
    }

    public ZendeskUser(String id, String str) {
        Intrinsics.checkNotNullParameter(id, "id");
        this.id = id;
        this.externalId = str;
    }

    public final String getId() {
        return this.id;
    }

    public final String getExternalId() {
        return this.externalId;
    }
}
