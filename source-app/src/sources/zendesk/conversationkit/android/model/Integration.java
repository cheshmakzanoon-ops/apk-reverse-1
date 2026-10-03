package zendesk.conversationkit.android.model;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ\t\u0010\u0011\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0012\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0013\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0014\u001a\u00020\bHÆ\u0003J1\u0010\u0015\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\bHÆ\u0001J\u0013\u0010\u0016\u001a\u00020\u00052\b\u0010\u0017\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0019HÖ\u0001J\t\u0010\u001a\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\u000bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010¨\u0006\u001b"}, m18d2 = {"Lzendesk/conversationkit/android/model/Integration;", "", "id", "", "canUserCreateMoreConversations", "", "canUserSeeConversationList", "waitTimeConfig", "Lzendesk/conversationkit/android/model/WaitTimeConfig;", "(Ljava/lang/String;ZZLzendesk/conversationkit/android/model/WaitTimeConfig;)V", "getCanUserCreateMoreConversations", "()Z", "getCanUserSeeConversationList", "getId", "()Ljava/lang/String;", "getWaitTimeConfig", "()Lzendesk/conversationkit/android/model/WaitTimeConfig;", "component1", "component2", "component3", "component4", "copy", "equals", "other", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class Integration {
    private final boolean canUserCreateMoreConversations;
    private final boolean canUserSeeConversationList;
    private final String id;
    private final WaitTimeConfig waitTimeConfig;

    public static Integration copy$default(Integration integration, String str, boolean z, boolean z2, WaitTimeConfig waitTimeConfig, int i, Object obj) {
        if ((i & 1) != 0) {
            str = integration.id;
        }
        if ((i & 2) != 0) {
            z = integration.canUserCreateMoreConversations;
        }
        if ((i & 4) != 0) {
            z2 = integration.canUserSeeConversationList;
        }
        if ((i & 8) != 0) {
            waitTimeConfig = integration.waitTimeConfig;
        }
        return integration.copy(str, z, z2, waitTimeConfig);
    }

    public final String getId() {
        return this.id;
    }

    public final boolean getCanUserCreateMoreConversations() {
        return this.canUserCreateMoreConversations;
    }

    public final boolean getCanUserSeeConversationList() {
        return this.canUserSeeConversationList;
    }

    public final WaitTimeConfig getWaitTimeConfig() {
        return this.waitTimeConfig;
    }

    public final Integration copy(String id, boolean canUserCreateMoreConversations, boolean canUserSeeConversationList, WaitTimeConfig waitTimeConfig) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(waitTimeConfig, "waitTimeConfig");
        return new Integration(id, canUserCreateMoreConversations, canUserSeeConversationList, waitTimeConfig);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Integration)) {
            return false;
        }
        Integration integration = (Integration) other;
        return Intrinsics.areEqual(this.id, integration.id) && this.canUserCreateMoreConversations == integration.canUserCreateMoreConversations && this.canUserSeeConversationList == integration.canUserSeeConversationList && Intrinsics.areEqual(this.waitTimeConfig, integration.waitTimeConfig);
    }

    public int hashCode() {
        return (((((this.id.hashCode() * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.canUserCreateMoreConversations)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.canUserSeeConversationList)) * 31) + this.waitTimeConfig.hashCode();
    }

    public String toString() {
        return "Integration(id=" + this.id + ", canUserCreateMoreConversations=" + this.canUserCreateMoreConversations + ", canUserSeeConversationList=" + this.canUserSeeConversationList + ", waitTimeConfig=" + this.waitTimeConfig + ')';
    }

    public Integration(String id, boolean z, boolean z2, WaitTimeConfig waitTimeConfig) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(waitTimeConfig, "waitTimeConfig");
        this.id = id;
        this.canUserCreateMoreConversations = z;
        this.canUserSeeConversationList = z2;
        this.waitTimeConfig = waitTimeConfig;
    }

    public final String getId() {
        return this.id;
    }

    public final boolean getCanUserCreateMoreConversations() {
        return this.canUserCreateMoreConversations;
    }

    public final boolean getCanUserSeeConversationList() {
        return this.canUserSeeConversationList;
    }

    public final WaitTimeConfig getWaitTimeConfig() {
        return this.waitTimeConfig;
    }
}
